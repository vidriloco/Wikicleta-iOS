//
//  LookAndFeel.m
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LookAndFeel.h"

@implementation LookAndFeel

+ (UIColor*) blueColor
{
    return [UIColor colorWithHexString:@"1f3a50"];
}

+ (UIColor*) orangeColor
{
    return [UIColor colorWithHexString:@"fb4e15"];
}

+ (UIColor*) lightBlueColor
{
    return [UIColor colorWithHexString:@""];
}

+ (UIFont*) defaultFontLightWithSize:(int)size
{
    return [UIFont fontWithName:@"Gotham Rounded" size:size];
}

@end
