//
//  HomeViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/6/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
    UIView *backgroundColorView;
    UIButtonWS *exploreButton;
    UIButtonWS *registerButton;
}

@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        UIColor *backgroundColor = [UIColor colorWithHexString:Kblue];
        backgroundColorView = [[UIView alloc] initWithFrame:[App viewBounds]];
        [backgroundColorView setBackgroundColor:[backgroundColor colorWithAlphaComponent:0.8]];
        [self.view addSubview:backgroundColorView];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wikicleta_logo.png"]];
        [logo setCenter:CGPointMake([App viewBounds].size.width/2, 180)];
        [self.view addSubview:logo];
        
        exploreButton = [[UIButtonWS alloc] initWithTitle:@"Explora" withFrame:CGRectMake(30, 400, 100, 40)];
        registerButton = [[UIButtonWS alloc] initWithTitle:@"Iniciar" withFrame:CGRectMake(190, 400, 100, 40)];
        
        [registerButton addTarget:self
                           action:@selector(presentLoginController)
                 forControlEvents:UIControlEventTouchUpInside];
        [exploreButton addTarget:self
                           action:@selector(presentExploreController)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:exploreButton];
        [self.view addSubview:registerButton];
        
    }
    return self;
}

- (void) presentLoginController
{
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void) presentExploreController
{
    ExploreViewController *exploreController = [[ExploreViewController alloc] init];
    [self presentViewController:exploreController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"stripe.png"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate
{
    return FALSE;
}

@end
