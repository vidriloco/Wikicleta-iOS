//
//  RouteUIView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "RouteUIView.h"

@implementation RouteUIView

@synthesize distanceNumberLabel, distanceWordsLabel, titleLabel, subtitleLabel, leftBottomLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) stylizeView {
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9f]];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.layer setShadowOpacity:0.7];
    
    [distanceWordsLabel setFont:[LookAndFeel defaultFontBoldWithSize:25]];
    [distanceWordsLabel setTextColor:[LookAndFeel orangeColor]];
    
    [distanceNumberLabel setTextColor:[LookAndFeel blueColor]];
    [distanceNumberLabel setFont:[LookAndFeel defaultFontLightWithSize:30]];
    
    [leftBottomLabel setFont:[LookAndFeel defaultFontLightWithSize:12]];
    [leftBottomLabel setTextColor:[LookAndFeel middleBlueColor]];
    
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:18]];
    [subtitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:14]];
    [titleLabel setTextColor:[LookAndFeel blueColor]];
    [subtitleLabel setTextColor:[LookAndFeel orangeColor]];
}

@end
