//
//  LandingViewController.m
//  Wikicleta
//
//  Created by Spalatinje on 8/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LandingViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface LandingViewController () {
}

- (void) launchJoinController;
- (void) launchLoginController;
- (void) launchDiscoverController;
- (void) twitterSignIn;
- (void) facebookSignIn;

@end

@implementation LandingViewController

@synthesize loginLabel, registerLabel, titleLabel, twitterSigninButton, facebookSigninButton;

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

- (void) twitterSignIn
{
    [socialConnector connectWithTwitter];
}

- (void) onAuthenticationFinishedWith:(NSDictionary *)dictionary
{
    RegistrationViewController *registrationController = [[RegistrationViewController alloc] init];
    [registrationController setAuthenticatedFields:dictionary];
    [[self navigationController] pushViewController:registrationController animated:YES];    
}


- (void) facebookSignIn
{
    //[socialConnector connectWithFacebook];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([User userLoggedIn]) {
        [self launchDiscoverController];
    } else {
        [twitterSigninButton addTarget:self action:@selector(twitterSignIn) forControlEvents:UIControlEventTouchUpInside];
        [facebookSigninButton addTarget:self action:@selector(facebookSignIn) forControlEvents:UIControlEventTouchUpInside];

        [titleLabel setFont:[LookAndFeel defaultFontLightWithSize:19]];
        [titleLabel setTextColor:[LookAndFeel orangeColor]];
        [titleLabel setText:NSLocalizedString(@"connect_with", nil)];
        
        [registerLabel setFont:[LookAndFeel defaultFontBookWithSize:14]];
        [registerLabel setTextColor:[LookAndFeel orangeColor]];
        [registerLabel setText:NSLocalizedString(@"join", nil)];
        UITapGestureRecognizer *tapRegisterLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchJoinController)];
        [tapRegisterLabel setNumberOfTapsRequired:1];
        [registerLabel addGestureRecognizer:tapRegisterLabel];
        [registerLabel setUserInteractionEnabled:YES];
        
        [loginLabel setFont:[LookAndFeel defaultFontBookWithSize:14]];
        [loginLabel setTextColor:[LookAndFeel orangeColor]];
        [loginLabel setText:NSLocalizedString(@"login", nil)];
        UITapGestureRecognizer *tapLoginLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchLoginController)];
        [tapLoginLabel setNumberOfTapsRequired:1];
        [loginLabel addGestureRecognizer:tapLoginLabel];
        [loginLabel setUserInteractionEnabled:YES];

        //[[Mixpanel sharedInstance] track:@"On Landing Page" properties:@{
        //    @"date": [[NSDate new] description]
        //}];
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
