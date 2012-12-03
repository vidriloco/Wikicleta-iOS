//
//  RegistrationViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

@synthesize name, password, passwordConfirmation, email;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Registro";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)commitRegistrationData:(id)sender
{
    User *user = [User initWithName:name.text
                          withEmail:email.text
                       withPassword:password.text
            andPasswordConfirmation:passwordConfirmation.text];
    
    if ([user isValidForSave]) {
        NSURL *url = [NSURL URLWithString:[App urlForResource:@"createUsers"]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:[[user toJSON]  dataUsingEncoding:NSUTF8StringEncoding]];
        [request startSynchronous];
        
        if ([request isFinished] && [request responseStatusCode] == 200) {
            NSLog(@"Success");
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[user errorMsj]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Aceptar", nil];
        [alert show];
    }

}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
