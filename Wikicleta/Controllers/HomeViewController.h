//
//  HomeViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/6/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor-Expanded.h"
#import "App.h"
#import "UIButtonWS.h"

#import "FirstAccessViewController.h"
#import "ExploreViewController.h"

#define Kblue    @"0x3F71F5"

@interface HomeViewController : UIViewController

- (void) presentLoginController;
- (void) presentExploreController;

@end
