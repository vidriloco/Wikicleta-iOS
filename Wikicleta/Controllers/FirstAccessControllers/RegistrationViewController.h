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

@interface RegistrationViewController : UIViewController <UITextFieldDelegate> {
  
  
}

@property (nonatomic, weak) IBOutlet UITextField* name;
@property (nonatomic, weak) IBOutlet UITextField* password;
@property (nonatomic, weak) IBOutlet UITextField* passwordConfirmation;
@property (nonatomic, weak) IBOutlet UITextField* email;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

- (void) dismiss;
- (IBAction)commitRegistrationData:(id)sender;

@end
