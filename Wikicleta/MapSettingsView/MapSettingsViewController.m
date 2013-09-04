//
//  MapSettingsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 9/1/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MapSettingsViewController.h"

@interface MapSettingsViewController ()

- (void) returnToRootController:(id)receiver;
- (void) selectYourLayers;
- (void) pageChanged;
- (void) propagatePageChanges;
- (void) loadChoosenLayerMod;

@end

@implementation MapSettingsViewController

@synthesize scrollView, pageControl, settingsText, navigationBar, jumpGroupsController, navBarTitle, closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) returnToRootController:(id)receiver
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [pageControl setNumberOfPages:kPagesLevelOne];
    [pageControl setCurrentPage:0];
    [pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
        
    [scrollView setDelegate:self];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*kPagesLevelOne, scrollView.frame.size.height)];
    
    int i = 0;
    for (NSString *viewType in @[@"layers", @"groups"]) {
        UIView *modMapView;
        if ([viewType isEqualToString:@"layers"]) {
            modMapView = [[[NSBundle mainBundle] loadNibNamed:[@"LayerBasedView" stringByAppendingString:[App postfixView]] owner:self options:nil] objectAtIndex:0];
        } else {
            modMapView = [[[NSBundle mainBundle] loadNibNamed:[@"GroupsBasedView" stringByAppendingString:[App postfixView]] owner:self options:nil] objectAtIndex:0];
        }
        
        UILabel *label = (UILabel*) [modMapView viewWithTag:1];
        [label setFont:[LookAndFeel defaultFontLightWithSize:16]];
        [label setTextColor:[LookAndFeel orangeColor]];
        
        [settingsText setTextColor:[LookAndFeel blueColor]];
        [settingsText setFont:[LookAndFeel defaultFontLightWithSize:16]];
        
        [modMapView setFrame:CGRectMake(scrollView.frame.size.width * i, modMapView.frame.origin.y, modMapView.frame.size.width, modMapView.frame.size.height)];
        [scrollView addSubview:modMapView];

        i=i+1;
    }
    
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_back.png"] forBarMetrics:UIBarMetricsDefault];
    
    [navBarTitle setText:NSLocalizedString(@"map_settings_title", nil)];
    [navBarTitle setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [navBarTitle setTextColor:[LookAndFeel blueColor]];
    [navBarTitle.layer setShadowOffset:CGSizeMake(2, 2)];
    [navBarTitle.layer setShadowColor:[LookAndFeel lightBlueColor].CGColor];
    
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    [[closeButton titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[closeButton titleLabel] setTextColor:[UIColor whiteColor]];
    [closeButton addTarget:self action:@selector(returnToRootController:) forControlEvents:UIControlEventTouchUpInside];
    
    [jumpGroupsController setImageEdgeInsets:UIEdgeInsetsMake(2, 8, 0, 0)];
    [[jumpGroupsController titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[jumpGroupsController titleLabel] setTextColor:[UIColor whiteColor]];
    
    [jumpGroupsController addTarget:self action:@selector(selectYourLayers) forControlEvents:UIControlEventTouchUpInside];
    [self loadChoosenLayerMod];
}

- (void)selectYourLayers
{
    LayersGroupsViewController *layers = [[LayersGroupsViewController alloc] initWithNibName:[@"LayersGroupsViewController" stringByAppendingString:[App postfixView]] bundle:Nil];
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
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
    
    [self presentModalViewController:layers animated:NO];
    
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self propagatePageChanges];
}

- (void) pageChanged
{
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
    [self propagatePageChanges];
}

- (void) propagatePageChanges
{
    if (pageControl.currentPage == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            [jumpGroupsController setAlpha:0];
        } completion:^(BOOL finished) {
            [jumpGroupsController setHidden:YES];
            [GlobalSettings setMapLayeringMod:LayersAtRight];
        }];
    } else {
        [jumpGroupsController setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [jumpGroupsController setAlpha:1];
        } completion:^(BOOL finished) {
            [jumpGroupsController setHidden:NO];
            [GlobalSettings setMapLayeringMod:LayersOnSets];
        }];
    }
}

- (void) loadChoosenLayerMod
{
    if ([GlobalSettings mapLayeringMod] == LayersAtRight) {
        [pageControl setCurrentPage:0];
    } else if([GlobalSettings mapLayeringMod] == LayersOnSets) {
        [pageControl setCurrentPage:1];
    }
    [self pageChanged];
}

@end
