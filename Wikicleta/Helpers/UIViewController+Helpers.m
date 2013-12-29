//
//  UIViewController+Helpers.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/22/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "UIViewController+Helpers.h"

@implementation UIViewController (Helpers)

- (void) setImageAsBackground:(UIImage *)image
{
    UIImageView *backPicture = [[UIImageView alloc] initWithImage:image];
    
    int translateY = IS_OS_7_OR_LATER ? 30 : -30;
    
    [backPicture setFrame:CGRectMake(-20, [App viewBounds].size.height- backPicture.frame.size.height+translateY, backPicture.frame.size.width, backPicture.frame.size.height)];
    [backPicture setAlpha:0];
    [self.view addSubview:backPicture];
    [UIView animateWithDuration:1 animations:^{
        [backPicture setAlpha:0.5];
    } completion:nil];

}

- (void) loadImageBackgroundNamed:(NSString*)imageName {
    [self setImageAsBackground:[UIImage imageNamed:imageName]];
}

- (void) loadNavigationBarDefaultStyle
{
    if (IS_OS_7_OR_LATER) {
        [[UINavigationBar appearance] setBarTintColor:[LookAndFeel lightBlueColor]];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];

    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_back.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:3.0 forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor: [LookAndFeel blueColor],
                                                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                           UITextAttributeFont: [LookAndFeel defaultFontBookWithSize:19],
                                                           }];
}

- (void) loadRightButtonWithString:(NSString *)string andStringSelector:(NSString *)selector
{
    SEL propSelector = NSSelectorFromString(selector);
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(string, nil)
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                              action:propSelector];
    if (!IS_OS_7_OR_LATER) {
        [button setTitleTextAttributes:@{ UITextAttributeTextColor: [UIColor whiteColor],
                                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                               UITextAttributeFont: [LookAndFeel defaultFontBookWithSize:14],
                                               } forState:UIControlStateNormal];
        [button setTitlePositionAdjustment:UIOffsetMake(0, 2) forBarMetrics:UIBarMetricsDefault];
    }
    // For iOS 6 and below
    [button setTintColor:[LookAndFeel orangeColor]];
    self.navigationItem.rightBarButtonItem = button;
}

- (void) showAlertDialogWith:(NSString *)title andContent:(NSString *)content andTextButton:(NSString*) textButton
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:content
                                                   delegate:nil
                                          cancelButtonTitle:textButton
                                          otherButtonTitles:nil];
    [alert show];
}

@end
