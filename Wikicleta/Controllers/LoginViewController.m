//
//  LoginViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/29/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Iniciar Sesión";
    }
    return self;
}

- (IBAction)loginWithFacebook:(id)sender
{

}

- (IBAction)loginWithTwitter:(id)sender
{

}

- (IBAction)displayRegistrationView:(id)sender
{
    RegistrationViewController *registration = [[RegistrationViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:registration animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar"
                                                                    style:UIBarButtonSystemItemCancel
                                                                   target:self.navigationController
                                                                   action:@selector(dismiss)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
