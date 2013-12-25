//
//  FormBaseViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/23/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"

@interface FormBaseViewController : UIViewController  <UITextFieldDelegate>

- (UIScrollView*) scrollableView;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
- (void) subscribeToKeyboardEvents:(BOOL)subscribe;
- (void)dismissTap:(id)sender;

@end
