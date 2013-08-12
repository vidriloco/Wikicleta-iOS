//
//  MenuViewController.m
//  Wikicleta
//
//  Created by Spalatinje on 8/9/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MenuViewController.h"

#define bottomMargin 40

@interface MenuViewController () {
    MenuListViewController *firstList;
    MenuListViewController *frequentUsedList;
}

@end

@implementation MenuViewController

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) loadView
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:[App viewBounds]];
    
    UIImage *imageNamedLogo = [UIImage imageNamed:@"logo_menu.png"];
    UIImageView *pinLogo = [[UIImageView alloc] initWithImage:imageNamedLogo];
    [pinLogo setCenter:CGPointMake(imageNamedLogo.size.width/2+20, 60)];
    [self.view addSubview:pinLogo];
    
    NSArray* mainSections = [NSArray arrayWithObjects:@"map", @"activity", @"tour", @"now", nil];
    firstList = [[MenuListViewController alloc] initWithFrame:CGRectMake(10, pinLogo.center.y+60, 190, 180) withOptions:mainSections];
    [self.view addSubview:firstList.view];
    
    UIImage *gears = [UIImage imageNamed:@"gear_menu.png"];
    UIImage *gearsSelected = [UIImage imageNamed:@"gear_menu_selected.png"];
    UIButton *gearButton = [[UIButton alloc] initWithFrame:
                            CGRectMake(25, [App viewBounds].size.height-gears.size.height-bottomMargin, gears.size.width, gears.size.height)];
    [gearButton setBackgroundImage:gears forState:UIControlStateNormal];
    [gearButton setBackgroundImage:gearsSelected forState:UIControlStateHighlighted];
    
    [self.view addSubview:gearButton];
    
    UIImage *user = [UIImage imageNamed:@"user_menu.png"];
    UIImage *userSelected = [UIImage imageNamed:@"user_menu_selected.png"];
    UIButton *userButton = [[UIButton alloc] initWithFrame:
                            CGRectMake(user.size.width+55, [App viewBounds].size.height-user.size.height-bottomMargin, user.size.width, user.size.height)];
    [userButton setBackgroundImage:user forState:UIControlStateNormal];
    [userButton setBackgroundImage:userSelected forState:UIControlStateHighlighted];
    [self.view addSubview:userButton];
    
    UIImage *messages = [UIImage imageNamed:@"messages_menu.png"];
    UIImage *messagesSelected = [UIImage imageNamed:@"messages_menu_selected.png"];
    UIButton *messagesButton = [[UIButton alloc] initWithFrame:
                                CGRectMake(messages.size.width*2+85, [App viewBounds].size.height-messages.size.height-bottomMargin, messages.size.width, messages.size.height)];
    [messagesButton setBackgroundImage:messages forState:UIControlStateNormal];
    [messagesButton setBackgroundImage:messagesSelected forState:UIControlStateHighlighted];
    [self.view addSubview:messagesButton];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
