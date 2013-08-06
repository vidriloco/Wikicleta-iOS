//
//  UIButtonWithLabel.h
//  Wikicleta
//
//  Created by Spalatinje on 8/6/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor-Expanded.h"

@interface UIButtonWithLabel : UIButton

- (id) initWithFrame:(CGRect)frame withImageNamed:(NSString*)image withTextLabel:(NSString*)label;

@end
