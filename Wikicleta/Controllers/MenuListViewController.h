//
//  MenuListViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/10/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewCell.h"
#import "IIViewDeckController.h"
#import "MapViewController.h"
#import "User.h"
#import "LandingViewController.h"
#import "ProfileViewController.h"
#import "CycleprintsViewController.h"

@class MainMenuViewController;

@interface MenuListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
}

- (id) initWithFrame:(CGRect)frame withOptions:(NSArray*)options withController:(MainMenuViewController*)menuController;
- (void) deselectAllRows;

@end
