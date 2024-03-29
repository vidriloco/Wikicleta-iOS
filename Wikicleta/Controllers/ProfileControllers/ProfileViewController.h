//
//  ProfileViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 1/1/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "AFHTTPRequestOperationManager.h"
#import "App.h"
#import "LookAndFeel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "IIViewDeckController.h"
#import "OnProfileSectionView.h"
#import "MainMenuViewController.h"
#import "ActivityViewController.h"
#import "FavoritesViewController.h"
#import "SettingsViewController.h"
#import "LocationManager.h"
#import "LocationManagerDelegate.h"

@interface ProfileViewController : UIViewController<IIViewDeckControllerDelegate, LocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userBioLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userPictureImage;
@property (nonatomic, weak) IBOutlet OnProfileSectionView *activityButton;
@property (nonatomic, weak) IBOutlet OnProfileSectionView *favoriteButton;
@property (nonatomic, weak) IBOutlet OnProfileSectionView *settingsButton;
@property (nonatomic, weak) IBOutlet UIView *leftborderView;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;

@property (nonatomic, weak) IBOutlet UILabel *distanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedTextLabel;

- (void) loadPictureImage;
- (void) loadUserInfo;

@end
