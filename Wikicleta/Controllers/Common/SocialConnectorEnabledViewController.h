//
//  SocialConnectorEnabledViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 2/28/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialAccountConnectorDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Accounts/Accounts.h>
#import "SocialAccountConnector.h"

@interface SocialConnectorEnabledViewController : UIViewController<SocialAccountConnectorDelegate, UIActionSheetDelegate> {
    SocialAccountConnector *socialConnector;
}

@property (nonatomic, strong) SocialAccountConnector *socialConnector;

@end
