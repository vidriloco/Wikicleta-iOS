//
//  MainMenuViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/26/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MainMenuViewController.h"

#define bottomMargin 40

@interface MainMenuViewController () {
    MenuListViewController *firstList;
    UIButton *trackerActivator;
}

- (void) toggleTrackingEngine;

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self loadMenuView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadGPSActiveButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) deselectAll {
    [firstList deselectAllRows];
}

// Probably should REFACTOR
- (void) loadMenuView
{
    if (firstList != NULL) {
        [firstList.view removeFromSuperview];
    }
    
    NSMutableArray* mainSections = [NSMutableArray arrayWithObjects: @"discover", nil];
    
    if ([User userLoggedIn]) {
        [mainSections addObject:@"profile"];
    } else {
        [mainSections addObject:@"join"];
    }
    
    [mainSections addObject:@"pedal_pow"];
    
    firstList = [[MenuListViewController alloc] initWithFrame:CGRectMake(10, 10, 130, 390) withOptions:mainSections withController:self];
    [self.view addSubview:firstList.view];
    
}

- (void) loadGPSActiveButton {
    if (trackerActivator == NULL) {
        trackerActivator = [[UIButton alloc] initWithFrame:CGRectMake(35, [App viewBounds].size.height-110, 80 , 80)];
        
        [trackerActivator addTarget:self action:@selector(toggleTrackingEngine) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:trackerActivator];
    }
    if ([[LocationManager sharedInstance] active]) {
        [trackerActivator setImage:[UIImage imageNamed:@"compass_activated_menu.png"] forState:UIControlStateNormal];
    } else {
        [trackerActivator setImage:[UIImage imageNamed:@"compass_deactivated_menu.png"] forState:UIControlStateNormal];
    }

}

- (void) toggleTrackingEngine {
    if ([[LocationManager sharedInstance] active]) {
        [trackerActivator setImage:[UIImage imageNamed:@"compass_deactivated_menu.png"] forState:UIControlStateNormal];
        [[LocationManager sharedInstance] deactivateUpdating];
    } else {
        [trackerActivator setImage:[UIImage imageNamed:@"compass_activated_menu.png"] forState:UIControlStateNormal];
        [[LocationManager sharedInstance] activateUpdating];
    }
    [[self viewDeckController] closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        [[LocationManager sharedInstance] displayDialog];
    }];
}

@end
