//
//  SettingsViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/31/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "IIViewDeckController.h"
#import "UzysSlideMenu.h"
#import "MapSettingsViewController.h"
#import "SocialSettingsViewController.h"

@interface SettingsViewController : UIViewController<UIScrollViewDelegate> {
    UILabel *sectionNameLabel;
    UILabel *dragMsgLabel;
    UIImageView *imageBackground;
    UIView *mapViewSettings;
}
@property (nonatomic, strong) IBOutlet UILabel *dragMsgLabel;
@property (nonatomic, strong) IBOutlet UILabel *sectionNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageBackground;

@property (nonatomic, strong) UIView *mapViewSettings;

@end
