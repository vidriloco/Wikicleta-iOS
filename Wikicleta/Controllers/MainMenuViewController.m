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

- (void) displaySettingsPanel;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray* mainSections = [NSMutableArray arrayWithObjects: @"discover", @"events", nil];

    if ([User userLoggedIn]) {
        [mainSections addObject:@"profile"];
    } else {
        [mainSections addObject:@"join"];
    }
    
    firstList = [[MenuListViewController alloc] initWithFrame:CGRectMake(10, 10, 130, 390) withOptions:mainSections withController:self];
    [self.view addSubview:firstList.view];
    
    UIImage *config = [UIImage imageNamed:@"gear_menu.png"];
    UIImage *configSelected = [UIImage imageNamed:@"gear_menu_selected.png"];
    configButton = [[UIButton alloc] initWithFrame:
                            CGRectMake([App viewBounds].size.width/4-config.size.width/2-2, [App viewBounds].size.height-config.size.height-bottomMargin, config.size.width, config.size.height)];
    [configButton setBackgroundImage:config forState:UIControlStateNormal];
    [configButton setBackgroundImage:configSelected forState:UIControlStateHighlighted];
    [configButton setBackgroundImage:configSelected forState:UIControlStateSelected];
    [self.view addSubview:configButton];
    
    [configButton addTarget:self action:@selector(displaySettingsPanel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displaySettingsPanel
{
    [self deselectAll];
    
    [self.viewDeckController setRightController:nil];
    /*SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:settings];
    [rootNav setNavigationBarHidden:YES];
    [self.viewDeckController setCenterController:rootNav];
    [self.viewDeckController closeLeftViewAnimated:YES];
    [configButton setSelected:YES];*/
}

- (void) deselectAll {
    [configButton setSelected:NO];
    [firstList deselectAllRows];
}


@end
