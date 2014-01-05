//
//  SelectOnTapView.m
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "SelectOnTapView.h"

@implementation SelectOnTapView

@synthesize iconImage, titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) stylizeView
{
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:17]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
}

@end
