//
//  FirstAccessViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface FirstAccessViewController : UINavigationController

+ (FirstAccessViewController*) build;
- (void) dismiss;

@end
