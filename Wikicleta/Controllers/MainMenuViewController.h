//
//  MainMenuViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/26/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuListViewController.h"
#import "App.h"
#import "IIViewDeckController.h"
#import "User.h"
#import "LocationManager.h"

@interface MainMenuViewController : UIViewController {
}

@property (nonatomic, strong) UIView *menuViewContainer;

- (void) deselectAll;
- (void) loadMenuView;
@end
