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
    
    NSArray* mainSections = [NSArray arrayWithObjects:@"map", @"discover", @"activity", nil];
    firstList = [[MenuListViewController alloc] initWithFrame:CGRectMake(10, 10, 130, 390) withOptions:mainSections withViewDeckController:self.viewDeckController];
    [self.view addSubview:firstList.view];
    
    UIImage *user = [UIImage imageNamed:@"user_menu.png"];
    UIImage *userSelected = [UIImage imageNamed:@"user_menu_selected.png"];
    UIButton *userButton = [[UIButton alloc] initWithFrame:
                            CGRectMake(20, [App viewBounds].size.height-user.size.height-bottomMargin, user.size.width, user.size.height)];
    [userButton setBackgroundImage:user forState:UIControlStateNormal];
    [userButton setBackgroundImage:userSelected forState:UIControlStateHighlighted];
    [self.view addSubview:userButton];
    
    UIImage *messages = [UIImage imageNamed:@"messages_menu.png"];
    UIImage *messagesSelected = [UIImage imageNamed:@"messages_menu_selected.png"];
    UIButton *messagesButton = [[UIButton alloc] initWithFrame:
                                CGRectMake(messages.size.width+35, [App viewBounds].size.height-messages.size.height-bottomMargin, messages.size.width, messages.size.height)];
    [messagesButton setBackgroundImage:messages forState:UIControlStateNormal];
    [messagesButton setBackgroundImage:messagesSelected forState:UIControlStateHighlighted];
    [self.view addSubview:messagesButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
