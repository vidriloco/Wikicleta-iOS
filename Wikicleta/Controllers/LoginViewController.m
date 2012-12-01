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
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    }
    return self;
}

- (IBAction)loginWithFacebook:(id)sender
{
    SinglyService *service = [SinglyService serviceWithIdentifier:@"facebook"];
    service.delegate = self;
    [service requestAuthorizationWithViewController:self];
}

- (IBAction)loginWithTwitter:(id)sender
{
    SinglyService *service = [SinglyService serviceWithIdentifier:@"twitter"];
    service.delegate = self;
    [service requestAuthorizationWithViewController:self];
}

- (IBAction) dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) singlyServiceDidAuthorize:(SinglyService *)service
{
    //NSLog([[[SinglySession sharedSession] profiles] description]);
    //NSLog([[SinglySession sharedSession] accessToken]);
}

- (void) singlyServiceDidFail:(SinglyService *)service withError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                    message:[error localizedDescription]
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
