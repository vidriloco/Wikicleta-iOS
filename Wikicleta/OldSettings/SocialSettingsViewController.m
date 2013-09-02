//
//  SocialViewSettingsController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 9/1/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "SocialSettingsViewController.h"

@interface SocialSettingsViewController ()
- (void) returnToRootController:(id)receiver;
@end

@implementation SocialSettingsViewController

@synthesize backgroundView, navBarTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) returnToRootController:(id)receiver
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnToRootController:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    [navBarTitle setTextColor:[LookAndFeel orangeColor]];
    [navBarTitle setFont:[LookAndFeel defaultFontLightWithSize:17]];
    [navBarTitle setText:NSLocalizedString(@"settings_social", nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
