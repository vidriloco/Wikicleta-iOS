//
//  LayersGroupsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 9/1/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayersGroupsViewController.h"
#define reuseIdentifierK @"layersGroupsIdentifier"

@interface LayersGroupsViewController () {
    NSArray *layers;
    ChoosingLayerMode mode;
}

- (void) backToPreviousController;
- (void) switchSegmentedView:(id)sender;
- (void) readAndUpdateDataForMode:(ChoosingLayerMode)mode;

@end

@implementation LayersGroupsViewController

@synthesize backButton, navBarTitle, navigationBar, layerTableView, scrollView, segmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        layers = @[layersBicycleLanes, layersBicycleSharings, layersParkings, layersRoutes, layersTips, layersWorkshops];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_back.png"] forBarMetrics:UIBarMetricsDefault];
    
    [navBarTitle setText:NSLocalizedString(@"map_layers_settings_title", nil)];
    [navBarTitle setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [navBarTitle setTextColor:[LookAndFeel blueColor]];
    [navBarTitle.layer setShadowOffset:CGSizeMake(2, 2)];
    [navBarTitle.layer setShadowColor:[LookAndFeel lightBlueColor].CGColor];
    
    [[backButton titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[backButton titleLabel] setTextColor:[UIColor whiteColor]];
    [backButton addTarget:self action:@selector(backToPreviousController) forControlEvents:UIControlEventTouchUpInside];
    
    [layerTableView setDelegate:self];
    [layerTableView setDataSource:self];
    [layerTableView setBackgroundColor:[UIColor clearColor]];
    [layerTableView registerNib:[UINib nibWithNibName:@"CheckableViewCell"
                                          bundle:[NSBundle mainBundle]]
    forCellReuseIdentifier:reuseIdentifierK];
    [layerTableView setFrame:CGRectMake(layerTableView.frame.origin.x, layerTableView.frame.origin.y, layerTableView.frame.size.width, rowHeight*layers.count)];
    [layerTableView setAllowsMultipleSelection:YES];
    [scrollView setContentSize:CGSizeMake(layerTableView.frame.size.width, layerTableView.frame.size.height)];
    [segmentedControl addTarget:self
                         action:@selector(switchSegmentedView:)
               forControlEvents:UIControlEventValueChanged];
}

- (void) switchSegmentedView:(id)sender
{
    UISegmentedControl *sControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = sControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        [self readAndUpdateDataForMode:SelectingBlue];
    } else{
        [self readAndUpdateDataForMode:SelectingOrange];
    }
    [layerTableView reloadData];
}

- (void) readAndUpdateDataForMode:(ChoosingLayerMode)mode
{
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backToPreviousController {
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 0.25f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [CATransaction commit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionId = [layers objectAtIndex:indexPath.row];
    
    CheckableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:reuseIdentifierK];
    if (cell == nil) {
        cell = [[CheckableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierK];
        
    }
    [[cell selectedBackgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    UIImage *image = [UIImage imageNamed:[sectionId stringByAppendingString:@"_layers.png"]];
    [[cell settingsIcon] setImage:image];
    [[cell mainLabel] setText:NSLocalizedString([sectionId stringByAppendingString:@"_layers"], nil)];
    [[cell mainLabel] setFont:[LookAndFeel defaultFontBookWithSize:18]];
    [[cell mainLabel] setTextColor:[LookAndFeel blueColor]];
    return cell;
}

- (void) tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView_ selectRowAtIndexPath:indexPath animated:YES scrollPosition:nil];
    CheckableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:reuseIdentifierK];
    [cell setSelected:YES animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [layers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

@end
