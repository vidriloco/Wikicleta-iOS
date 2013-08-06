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
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_gradient_iphone.png"]]];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wikicleta"]];
        [logo setCenter:CGPointMake(160, 150)];
        
        UIImageView *pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];
        [pin setCenter:CGPointMake(pin.frame.size.width/2, 250)];
        
        
        [self.view addSubview:logo];
        [self.view addSubview:pin];
        
        LandingAccessView *accessButtons = [[LandingAccessView alloc] initWithFrame:CGRectMake(0, [App viewBounds].size.height, [App viewBounds].size.width, 100)];
        
        // Buttons load
        
        UIButtonWithLabel *explore = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(35, 15, 45, 60) withImageNamed:@"explore.png" withTextLabel:@"Explora"];
        [accessButtons addSubview:explore];
        
        UIButtonWithLabel *login = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(135, 15, 45, 60) withImageNamed:@"login.png" withTextLabel:@"Entra"];
        [accessButtons addSubview:login];
        
        UIButtonWithLabel *join = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(235, 15, 45, 60) withImageNamed:@"unite.png" withTextLabel:@"Únete"];
        [accessButtons addSubview:join];
        
        [explore addTarget:self action:@selector(launchExploreController) forControlEvents:UIControlEventTouchUpInside];
        
        [join addTarget:self action:@selector(launchJoinController) forControlEvents:UIControlEventTouchUpInside];

        [login addTarget:self action:@selector(launchLoginController) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:accessButtons];
        
        
        [UIView animateWithDuration:1 animations:^{
            [accessButtons setAlpha:1];
            [accessButtons setTransform:CGAffineTransformMakeTranslation(0, -160)];
        }];
    }
    
    return self;
}

- (void) launchLoginController
{
    NSLog(@"Login controller launched");
}

- (void) launchJoinController
{
    NSLog(@"Join controller launched");

}

- (void) launchExploreController
{
    NSLog(@"Explore controller launched");

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
