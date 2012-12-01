//
//  LoginViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/29/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import <SinglySDK/SinglySDK.h>

@interface LoginViewController : UIViewController<SinglyServiceDelegate>

- (IBAction)loginWithTwitter:(id)sender;
- (IBAction)loginWithFacebook:(id)sender;
- (IBAction) dismiss;

@end
