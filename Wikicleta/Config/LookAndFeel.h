//
//  LookAndFeel.h
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor-Expanded.h"

@interface LookAndFeel : NSObject

+ (UIColor*) blueColor;
+ (UIColor*) orangeColor;
+ (UIColor*) lightBlueColor;
+ (UIFont*) defaultFontLightWithSize:(int) size;
+ (UIFont*) defaultFontBoldWithSize:(int) size;
+ (UIFont*) defaultFontBookWithSize:(int) size;

@end
