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

@synthesize name, username, password, passwordConfirmation, email;

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
   /* if (password.text != passwordConfirmation.text || [password.text length] < 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verifica tu contraseña"
                                                        message:@"Debe tener al menos 5 caracteres y debe ser igual a la confirmación"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Aceptar", nil];
        [alert show];
    } else {*/
        // Data
        NSMutableDictionary *newUser = [NSMutableDictionary dictionary];
        NSMutableDictionary *user = [NSMutableDictionary dictionary];
    
    [user setObject:[name text] forKey:kName];
    [user setObject:[username text] forKey:kUsername];
    [user setObject:[email text] forKey:kEmail];
    [user setObject:[password text] forKey:kPassword];
    [newUser setObject:user forKey:@"user"];

    
        NSURL *url = [NSURL URLWithString:[App urlForResource:@"createUsers"]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:[[newUser JSONRepresentation]  dataUsingEncoding:NSUTF8StringEncoding]];
        [request startSynchronous];
    //}

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
