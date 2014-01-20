//
//  SettingsViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/18/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "UIViewController+Helpers.h"
#import "User.h"
#import "FormBaseViewController.h"
#import "NSObject+FieldValidators.h"
#import "UITextView+UIPlus.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface SettingsViewController : FormBaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

}

@property (nonatomic, weak) IBOutlet UITextView *userBioTextView;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UIButton *userPicButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (void) dismiss;

@end
