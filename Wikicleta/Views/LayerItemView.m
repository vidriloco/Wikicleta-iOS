//
//  LayerItemView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayerItemView.h"

@implementation LayerItemView

@synthesize titleLabel, iconImage, name;

- (void) setSelected:(BOOL)selected
{
    if (selected) {
        [titleLabel setTextColor:[LookAndFeel orangeColor]];
        [iconImage setAlpha:1];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            [titleLabel setTextColor:[LookAndFeel blueColor]];
            [iconImage setAlpha:0.3];
        }];
    }
}

@end
