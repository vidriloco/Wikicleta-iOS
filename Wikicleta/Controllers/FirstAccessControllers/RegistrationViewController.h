//
//  RegistrationViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "User.h"
#import "UIViewController+Helpers.h"
#import "UITextField+UIPlus.h"
#import "NSObject+FieldValidators.h"
#import "MapViewController.h"
#import "FormBaseViewController.h"
#import "LandingViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface RegistrationViewController : FormBaseViewController {

}

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UITextField* username;
@property (nonatomic, weak) IBOutlet UITextField* password;
@property (nonatomic, weak) IBOutlet UITextField* passwordConfirmation;
@property (nonatomic, weak) IBOutlet UITextField* email;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

- (void) setAuthenticatedFields:(NSDictionary*)fields;

@end
