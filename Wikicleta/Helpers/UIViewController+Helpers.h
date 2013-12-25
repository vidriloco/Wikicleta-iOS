//
//  UIViewController+Helpers.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/22/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "LookAndFeel.h"

@interface UIViewController (Helpers)

- (void) loadImageBackgroundNamed:(NSString*)imageName;
- (void) loadNavigationBarDefaultStyle;
- (void) loadRightButtonWithString:(NSString*)string andStringSelector:(NSString*)selector;

// Validators

- (void) showAlertDialogWith:(NSString *)title andContent:(NSString *)content andTextButton:(NSString*) textButton;

@end
