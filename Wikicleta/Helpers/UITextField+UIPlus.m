//
//  UITextField+UIPlus.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/23/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "UITextField+UIPlus.h"

@implementation UITextField (UIPlus)

- (void) fixUI
{
    if (!IS_OS_7_OR_LATER) {
        [self setFont:[LookAndFeel defaultFontLightWithSize:18]];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setKeyboardType:UIKeyboardTypeDefault];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        self.borderStyle = UITextBorderStyleNone;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[LookAndFeel lightBlueColor] CGColor];
        self.layer.cornerRadius = 5.0f;
    }
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    if (!IS_OS_7_OR_LATER) {
        return CGRectMake(bounds.origin.x+7, bounds.origin.y+5, bounds.size.width, bounds.size.height-7);
    }
    return CGRectMake(bounds.origin.x+7, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (!IS_OS_7_OR_LATER) {
        return CGRectMake(bounds.origin.x+7, bounds.origin.y+5, bounds.size.width, bounds.size.height-7);
    }
    return CGRectMake(bounds.origin.x+7, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (!IS_OS_7_OR_LATER) {
        return CGRectMake(bounds.origin.x+7, bounds.origin.y+7, bounds.size.width, bounds.size.height-9);
    }
    return CGRectMake(bounds.origin.x+7, bounds.origin.y, bounds.size.width, bounds.size.height);
}

@end
