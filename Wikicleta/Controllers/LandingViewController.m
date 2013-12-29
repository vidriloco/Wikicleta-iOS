//
//  LandingViewController.m
//  Wikicleta
//
//  Created by Spalatinje on 8/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LandingViewController.h"

@interface LandingViewController ()

- (void) launchJoinController;
- (void) launchLoginController;
- (void) launchDiscoverController;

@end

@implementation LandingViewController

- (void) launchLoginController
{
    [[self navigationController] pushViewController:[[LoginViewController alloc] init] animated:YES];
}

- (void) launchJoinController
{
    [[self navigationController] pushViewController:[[RegistrationViewController alloc] init] animated:YES];
}

- (void) launchDiscoverController
{
    [[self navigationController] pushViewController:[[MapViewController alloc] init] animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([User userLoggedIn]) {
        [self launchDiscoverController];
    } else {
        LandingAccessView *accessButtons = [[LandingAccessView alloc] initWithFrame:CGRectMake(-2, [App viewBounds].size.height, [App viewBounds].size.width+2, 100)];
        
        // Buttons load
        
        UIButtonWithLabel *explore = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(35, 15, 45, 60)
                                                                     withName:@"explore"
                                                           withTextSeparation:45];
        [accessButtons addSubview:explore];
        
        UIButtonWithLabel *login = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(135, 15, 45, 60)
                                                                   withName:@"login"
                                                         withTextSeparation:45];
        [accessButtons addSubview:login];
        
        UIButtonWithLabel *join = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(235, 15, 45, 60)
                                                                  withName:@"join"
                                                        withTextSeparation:45];
        [accessButtons addSubview:join];
        
        [explore.button addTarget:self action:@selector(launchDiscoverController) forControlEvents:UIControlEventTouchUpInside];
        
        [join.button addTarget:self action:@selector(launchJoinController) forControlEvents:UIControlEventTouchUpInside];
        
        [login.button addTarget:self action:@selector(launchLoginController) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:accessButtons];
        
        
        [UIView animateWithDuration:1 animations:^{
            [accessButtons setAlpha:1];
            [accessButtons setTransform:CGAffineTransformMakeTranslation(0, [App viewBounds].size.height-accessButtons.center.y-100)];
        }];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)
                                                               style:UIBarButtonItemStyleBordered
                                                              target:nil
                                                              action:nil];
    
    if (!IS_OS_7_OR_LATER) {
        [backButton setTitleTextAttributes:@{ UITextAttributeTextColor: [UIColor whiteColor],
                                          UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                          UITextAttributeFont: [LookAndFeel defaultFontBookWithSize:14],
                                          } forState:UIControlStateNormal];
    }

    // For iOS 6 and below
    [backButton setTintColor:[LookAndFeel middleBlueColor]];
    self.navigationItem.backBarButtonItem = backButton;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
