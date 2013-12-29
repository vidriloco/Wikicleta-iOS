//
//  CyclestationUIView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "CyclestationUIView.h"

@implementation CyclestationUIView

@synthesize titleLabel, subtitleLabel, availableBikesNumberLabel, availableBikesTextLabel, availableSlotsNumberLabel, availableSlotsTextLabel, leftBottomLabel, rightBottomLabel;


- (void) stylizeView {
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9f]];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.layer setShadowOpacity:0.7];
    [titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:17]];
    [subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:14]];
    [titleLabel setTextColor:[LookAndFeel blueColor]];
    [subtitleLabel setTextColor:[LookAndFeel orangeColor]];
    
    [rightBottomLabel setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [rightBottomLabel setTextColor:[LookAndFeel orangeColor]];
    
    [leftBottomLabel setFont:[LookAndFeel defaultFontLightWithSize:12]];
    [leftBottomLabel setTextColor:[LookAndFeel middleBlueColor]];
    
    [availableBikesNumberLabel setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [availableBikesNumberLabel setTextColor:[LookAndFeel orangeColor]];
    [availableSlotsNumberLabel setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [availableSlotsNumberLabel setTextColor:[LookAndFeel orangeColor]];

    [availableBikesTextLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [availableBikesTextLabel setTextColor:[LookAndFeel blueColor]];
    [availableSlotsTextLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [availableSlotsTextLabel setTextColor:[LookAndFeel blueColor]];
}

@end
