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

@property (nonatomic, weak) IBOutlet UIView *decoratorView;

//@property (nonatomic, weak) IBOutlet UIButton *exploreButton;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

//@property (nonatomic, weak) IBOutlet UILabel *exploreLabel;
@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, weak) IBOutlet UILabel *registerLabel;

@end
