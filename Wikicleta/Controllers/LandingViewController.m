//
//  LandingViewController.m
//  Wikicleta
//
//  Created by Spalatinje on 8/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LandingViewController.h"

@interface LandingViewController ()

- (void) launchExploreController;
- (void) launchJoinController;
- (void) launchLoginController;

@end

@implementation LandingViewController

- (void) launchLoginController
{
    NSLog(@"Login controller launched");
    [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
}

- (void) launchJoinController
{
    [self presentViewController:[[RegistrationViewController alloc] init] animated:YES completion:nil];
}

- (void) launchExploreController
{
    [self.viewDeckController setCenterController:[[MapViewController alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [explore.button addTarget:self action:@selector(launchExploreController) forControlEvents:UIControlEventTouchUpInside];
    
    [join.button addTarget:self action:@selector(launchJoinController) forControlEvents:UIControlEventTouchUpInside];
    
    [login.button addTarget:self action:@selector(launchLoginController) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:accessButtons];
    
    
    [UIView animateWithDuration:1 animations:^{
        [accessButtons setAlpha:1];
        [accessButtons setTransform:CGAffineTransformMakeTranslation(0, [App viewBounds].size.height-accessButtons.center.y-100)];
    }];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
