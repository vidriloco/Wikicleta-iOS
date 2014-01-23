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

@synthesize decoratorView, loginButton, registerButton, loginLabel, registerLabel;

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
        [decoratorView.layer setBorderColor:[UIColor colorWithHexString:@"d5e6f3"].CGColor];
        [decoratorView.layer setBorderWidth:0.3];
        [decoratorView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.4]];
        [decoratorView setFrame:CGRectMake(decoratorView.frame.origin.x-2, decoratorView.frame.origin.x+2, [App viewBounds].size.width+4, decoratorView.frame.size.height)];
        // Buttons load
        
        /*[exploreButton addTarget:self action:@selector(launchDiscoverController) forControlEvents:UIControlEventTouchUpInside];
        [exploreLabel setText:NSLocalizedString(@"explore", nil)];
        [exploreLabel setFont:[LookAndFeel defaultFontBookWithSize:16]];
        [exploreLabel setTextColor:[LookAndFeel orangeColor]];*/
        
        [registerButton addTarget:self action:@selector(launchJoinController) forControlEvents:UIControlEventTouchUpInside];
        [registerLabel setText:NSLocalizedString(@"join", nil)];
        [registerLabel setFont:[LookAndFeel defaultFontBookWithSize:16]];
        [registerLabel setTextColor:[LookAndFeel orangeColor]];
        
        [loginButton addTarget:self action:@selector(launchLoginController) forControlEvents:UIControlEventTouchUpInside];
        [loginLabel setText:NSLocalizedString(@"login", nil)];
        [loginLabel setFont:[LookAndFeel defaultFontBookWithSize:16]];
        [loginLabel setTextColor:[LookAndFeel orangeColor]];
        
        [UIView animateWithDuration:1 animations:^{
            [decoratorView setAlpha:1];
            [decoratorView setTransform:CGAffineTransformMakeTranslation(0, [App viewBounds].size.height-decoratorView.center.y-100)];
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
