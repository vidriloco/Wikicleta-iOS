//
//  RegistrationViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

#import "App.h"
#import "User.h"

@interface RegistrationViewController : UIViewController {
    UITextField* name;
    UITextField* password;
    UITextField* passwordConfirmation;
    UITextField* email;
}

@property (nonatomic, strong) IBOutlet UITextField* name;
@property (nonatomic, strong) IBOutlet UITextField* password;
@property (nonatomic, strong) IBOutlet UITextField* passwordConfirmation;
@property (nonatomic, strong) IBOutlet UITextField* email;


- (void) dismiss;

- (IBAction)commitRegistrationData:(id)sender;

@end
