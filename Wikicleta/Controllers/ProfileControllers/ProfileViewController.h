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

@interface ProfileViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userBioLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userPictureImage;

- (void) loadPictureImage;

@end
