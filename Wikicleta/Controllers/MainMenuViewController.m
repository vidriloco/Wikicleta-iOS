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
    UIButton *configButton;
}

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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadMenuView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) deselectAll {
    [configButton setSelected:NO];
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
    
    firstList = [[MenuListViewController alloc] initWithFrame:CGRectMake(10, 10, 130, 390) withOptions:mainSections withController:self];
    [self.view addSubview:firstList.view];
}


@end
