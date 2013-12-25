//
//  LoginViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/29/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "UIViewController+Helpers.h"
#import "UITextField+UIPlus.h"
#import "FormBaseViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "User.h"
#import "MapViewController.h"
#import "NSObject+FieldValidators.h"
#import "MBProgressHUD.h"

@interface LoginViewController : FormBaseViewController {

}

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

- (void) attemptLogin;
- (void) dismissToMapViewController;

@end
