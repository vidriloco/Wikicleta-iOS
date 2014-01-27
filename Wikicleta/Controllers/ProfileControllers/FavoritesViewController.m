//
//  FavoritesViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController (){
    GenericBigMessageView *overlayMessage;
}

- (void) displayEmptyFavoritesMessageView;
- (void) displayReloadAttemptMessageView;
- (void) tryFetchingAgain;
@end


@implementation FavoritesViewController

@synthesize favoritesTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"profile_your_favorites", nil);
        [self fetchUserFavorites];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImageBackgroundNamed:@"favorites_icon_big.png"];
    [self loadNavigationBarDefaultStyle];
    [self loadLeftButtonWithString:NSLocalizedString(@"close", nil) andStringSelector:@"dismiss"];
    [favoritesTableView setHidden:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.viewDeckController setDelegate:self];
    [[Mixpanel sharedInstance] track:@"On Favorites View" properties:nil];
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

- (void) dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) displayEmptyFavoritesMessageView
{
    if (overlayMessage != nil) {
        [overlayMessage removeFromSuperview];
    }
    
    overlayMessage = [[[NSBundle mainBundle] loadNibNamed:@"GenericBigMessageView" owner:self options:nil] objectAtIndex:0];
    [[overlayMessage messageLabel] setText:NSLocalizedString(@"no_favorites_to_show", nil)];
    
    UIImage *image = [UIImage imageNamed:@"favorites_icon_big"];
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
    [[overlayMessage messageLabel] setText:NSLocalizedString(@"no_favorites_loaded", nil)];
    [[overlayMessage submessageLabel] setText:NSLocalizedString(@"no_favorites_loaded_try", nil)];
    
    UIImage *image = [UIImage imageNamed:@"reload_icon"];
    [[overlayMessage imageView] setImage:image];
    [overlayMessage stylizeView];
    [self.view addSubview:overlayMessage];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tryFetchingAgain)];
    [overlayMessage addGestureRecognizer:tapRecognizer];
}

- (void) tryFetchingAgain
{
    [overlayMessage removeFromSuperview];
    [self fetchUserFavorites];
}

- (void) fetchUserFavorites
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"updating", nil);
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    
    NSString *url = [[App urlForResource:@"favorites" withSubresource:@"get"]
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
            favoritesList = [NSMutableDictionary dictionary];
            NSArray *keys = [[response objectForKey:@"favorites"] allKeys];
            for (NSString *key in keys) {
                NSMutableArray *temporalList = [NSMutableArray array];
                NSArray *objects = [[response objectForKey:@"favorites"] objectForKey:key];
                for (NSDictionary *object in objects) {
                    LightPOI *poi = [[LightPOI alloc] initWithDictionary:object];
                    [temporalList addObject:poi];
                }
                NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                    sortDescriptorWithKey:@"updatedAt"
                                                    ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                [favoritesList setObject:[temporalList sortedArrayUsingDescriptors:sortDescriptors] forKey:key];
            }
            
            [favoritesTableView reloadData];
        }
        [hud hide:YES];
        if ([[favoritesList allValues] count] > 0) {
            [favoritesTableView setHidden:NO];
        } else {
            [favoritesTableView setHidden:YES];
            [self displayEmptyFavoritesMessageView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [favoritesTableView setHidden:YES];
        [self displayReloadAttemptMessageView];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[favoritesList allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[favoritesList allKeys] objectAtIndex:section];
    return [[favoritesList objectForKey:key] count];
}

static NSString *simpleTableIdentifier = @"POICellView";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POICellView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSString *key = [[favoritesList allKeys] objectAtIndex:indexPath.section];
    LightPOI *poi = [[favoritesList objectForKey:key] objectAtIndex:indexPath.row];
    [poi setKind:key];
    
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [[favoritesList allKeys] objectAtIndex:section];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -9, self.view.frame.size.width, 40)];
    [label setFont:[LookAndFeel defaultFontBoldWithSize:15]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    if ([key isEqualToString:@"Tip"]) {
        [label setText:NSLocalizedString(@"tips_title_plural", nil).uppercaseString];
    } else if ([key isEqualToString:@"Parking"]) {
        [label setText:NSLocalizedString(@"parkings_title_plural", nil).uppercaseString];
    } else if ([key isEqualToString:@"Route"]) {
        [label setText:NSLocalizedString(@"routes_title_plural", nil).uppercaseString];
    } else if ([key isEqualToString:@"Workshop"]) {
        [label setText:NSLocalizedString(@"workshop_store_title_plural", nil).uppercaseString];
    }
    [headerView addSubview:label];
    [headerView setBackgroundColor:[LookAndFeel orangeColor]];
    return headerView;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *controller in [[self navigationController] viewControllers]) {
        if ([controller isKindOfClass:[MapViewController class]]) {
            NSString *key = [[favoritesList allKeys] objectAtIndex:indexPath.section];
            LightPOI *poi = [[favoritesList objectForKey:key] objectAtIndex:indexPath.row];
            [(MapViewController*) controller centerOnLightPOI:poi];
            
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
