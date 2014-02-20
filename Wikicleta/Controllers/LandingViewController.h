//
//  LandingViewController.h
//  Wikicleta
//
//  Created by Spalatinje on 8/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "MapViewController.h"
#import "RegistrationViewController.h"
#import "LoginViewController.h"
#import "IIViewDeckController.h"


@interface LandingViewController : UIViewController {
}


@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, weak) IBOutlet UILabel *registerLabel;

@property (nonatomic, weak) IBOutlet UIButton *twitterSigninButton;
@property (nonatomic, weak) IBOutlet UIButton *facebookSigninButton;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end
