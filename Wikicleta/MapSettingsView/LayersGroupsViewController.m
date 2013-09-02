//
//  LayersGroupsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 9/1/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayersGroupsViewController.h"

@interface LayersGroupsViewController ()

- (void) backToPreviousController;

@end

@implementation LayersGroupsViewController

@synthesize backButton, navBarTitle, navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_back.png"] forBarMetrics:UIBarMetricsDefault];
    
    [navBarTitle setText:NSLocalizedString(@"map_layers_settings_title", nil)];
    [navBarTitle setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [navBarTitle setTextColor:[LookAndFeel blueColor]];
    [navBarTitle.layer setShadowOffset:CGSizeMake(2, 2)];
    [navBarTitle.layer setShadowColor:[LookAndFeel lightBlueColor].CGColor];
    
    [[backButton titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[backButton titleLabel] setTextColor:[UIColor whiteColor]];
    [backButton addTarget:self action:@selector(backToPreviousController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backToPreviousController {
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 0.25f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [CATransaction commit];
}

@end
