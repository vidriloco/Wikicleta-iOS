//
//  ActivityViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController () {
    GenericBigMessageView *overlayMessage;
}

- (void) displayEmptyActivitiesMessageView;
- (void) displayReloadAttemptMessageView;
- (void) tryFetchingAgain;
@end


@implementation ActivityViewController

@synthesize contributionsTableView, activityList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"profile_your_activity", nil);
        [self fetchUserActivity];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImageBackgroundNamed:@"activity_icon_big.png"];
    
    [self loadLeftButtonWithString:NSLocalizedString(@"close", nil) andStringSelector:@"dismiss"];
    [contributionsTableView setHidden:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.viewDeckController setDelegate:self];
    [[Mixpanel sharedInstance] track:@"On Activity View" properties:nil];
    [self loadNavigationBarDefaultStyle];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) displayEmptyActivitiesMessageView
{
    if (overlayMessage != nil) {
        [overlayMessage removeFromSuperview];
    }
    
    overlayMessage = [[[NSBundle mainBundle] loadNibNamed:@"GenericBigMessageView" owner:self options:nil] objectAtIndex:0];
    [[overlayMessage messageLabel] setText:NSLocalizedString(@"no_activities_to_show", nil)];
    
    UIImage *image = [UIImage imageNamed:@"activity_icon_big"];
    [[overlayMessage imageView] setImage:image];
    [[overlayMessage submessageLabel] setHidden:YES];
    [overlayMessage stylizeView];
    [self.view addSubview:overlayMessage];
}

- (void) displayReloadAttemptMessageView
{
    if (overlayMessage != nil) {
        [overlayMessage removeFromSuperview];
    }
    
    overlayMessage = [[[NSBundle mainBundle] loadNibNamed:@"GenericBigMessageView" owner:self options:nil] objectAtIndex:0];
    [[overlayMessage messageLabel] setText:NSLocalizedString(@"no_activities_loaded", nil)];
    [[overlayMessage submessageLabel] setText:NSLocalizedString(@"no_activities_loaded_try", nil)];

    UIImage *image = [UIImage imageNamed:@"reload_icon"];
    [[overlayMessage imageView] setImage:image];
    [overlayMessage stylizeView];
    [self.view addSubview:overlayMessage];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tryFetchingAgain)];
    [overlayMessage addGestureRecognizer:tapRecognizer];
}

- (void) dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) tryFetchingAgain
{
    [overlayMessage removeFromSuperview];
    [self fetchUserActivity];
}

- (void) fetchUserActivity
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"updating", nil);
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    
    NSString *url = [[App urlForResource:@"ownerships" withSubresource:@"get"]
                     stringByReplacingOccurrencesOfString:@":id"
                     withString:[NSString stringWithFormat:@"%d", [[[User currentUser] identifier] intValue]]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            NSArray *ownerships = [response objectForKey:@"ownerships"];
            NSMutableArray *temporalList = [NSMutableArray array];
            for (NSDictionary *ownership in ownerships) {
                LightPOI *poi = [[LightPOI alloc] initWithDictionary:ownership];
                [temporalList addObject:poi];
            }
            
            NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                sortDescriptorWithKey:@"updatedAt"
                                                ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
            activityList = [temporalList sortedArrayUsingDescriptors:sortDescriptors];
            [contributionsTableView reloadData];
        }
        [hud hide:YES];
        
        if ([activityList count] > 0) {
            [contributionsTableView setHidden:NO];
        } else {
            [contributionsTableView setHidden:YES];
            [self displayEmptyActivitiesMessageView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [contributionsTableView setHidden:YES];
        [self displayReloadAttemptMessageView];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activityList count];
}

static NSString *simpleTableIdentifier = @"POICellView";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POICellView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    LightPOI *poi = [activityList objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSString *updatedAtString = [timeIntervalFormatter stringForTimeInterval:[poi.updatedAt timeIntervalSinceNow]];
    [[cell lastUpdatedAtLabel] setText:[NSLocalizedString(@"updated_at", nil) stringByAppendingString:updatedAtString]];
    
    [[cell titleLabel] setText:[poi titleForLabel]];
    [[cell subtitleLabel] setText:[poi kindForLabel]];
    [[cell categoryImageView] setImage:[poi markerIcon]];
    [[cell detailsLabel] setText:[poi details]];
    [cell stylizeView];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *controller in [[self navigationController] viewControllers]) {
        if ([controller isKindOfClass:[MapViewController class]]) {
            [(MapViewController*) controller centerOnLightPOI:[activityList objectAtIndex:indexPath.row]];

            [[self navigationController] popToViewController:controller animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 184;
}

- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide
{
    return NO;
}

@end
