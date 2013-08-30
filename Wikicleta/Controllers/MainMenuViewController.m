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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray* mainSections = [NSArray arrayWithObjects:@"map", @"discover", @"profile", nil];
    firstList = [[MenuListViewController alloc] initWithFrame:CGRectMake(10, 10, 130, 390) withOptions:mainSections withViewDeckController:self.viewDeckController];
    [self.view addSubview:firstList.view];
    
    UIImage *config = [UIImage imageNamed:@"gear_menu.png"];
    UIImage *configSelected = [UIImage imageNamed:@"gear_menu_selected.png"];
    UIButton *configButton = [[UIButton alloc] initWithFrame:
                            CGRectMake([App viewBounds].size.width/4-config.size.width/2-2, [App viewBounds].size.height-config.size.height-bottomMargin, config.size.width, config.size.height)];
    [configButton setBackgroundImage:config forState:UIControlStateNormal];
    [configButton setBackgroundImage:configSelected forState:UIControlStateHighlighted];
    [self.view addSubview:configButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
