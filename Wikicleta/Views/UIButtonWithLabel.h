//
//  UIButtonWithLabel.h
//  Wikicleta
//
//  Created by Spalatinje on 8/6/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor-Expanded.h"

@interface UIButtonWithLabel : UIView {
    UIButton *button;
    UILabel *label;
    NSString *name;
}

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *name;

- (id) initWithFrame:(CGRect)frame withName:(NSString*)name withTextSeparation:(int)separation;
- (void) setSelected:(BOOL)selected;

@end
