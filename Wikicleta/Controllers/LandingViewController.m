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

- (id) init
{
    self = [super init];
    
    if (self) {
        
        self.view = [[UIView alloc] initWithFrame:[App viewBounds]];
 
    }
    
    return self;
}

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
    [self performSegueWithIdentifier:@"explore" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LandingAccessView *accessButtons = [[LandingAccessView alloc] initWithFrame:CGRectMake(-2, [App viewBounds].size.height, [App viewBounds].size.width+4, 100)];
    
    // Buttons load
    
    UIButtonWithLabel *explore = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(35, 15, 45, 60)
                                                           withImageNamed:@"explore.png"
                                                            withTextLabel:NSLocalizedString(@"explore", @"")];
    [accessButtons addSubview:explore];
    
    UIButtonWithLabel *login = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(135, 15, 45, 60)
                                                         withImageNamed:@"login.png"
                                                          withTextLabel:NSLocalizedString(@"login", @"")];
    [accessButtons addSubview:login];
    
    UIButtonWithLabel *join = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(235, 15, 45, 60)
                                                        withImageNamed:@"unite.png"
                                                         withTextLabel:NSLocalizedString(@"join", @"")];
    [accessButtons addSubview:join];
    
    [explore addTarget:self action:@selector(launchExploreController) forControlEvents:UIControlEventTouchUpInside];
    
    [join addTarget:self action:@selector(launchJoinController) forControlEvents:UIControlEventTouchUpInside];
    
    [login addTarget:self action:@selector(launchLoginController) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:accessButtons];
    
    
    [UIView animateWithDuration:1 animations:^{
        [accessButtons setAlpha:1];
        [accessButtons setTransform:CGAffineTransformMakeTranslation(0, -100)];
    }];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
