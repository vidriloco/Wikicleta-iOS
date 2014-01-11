//
//  CyclePathView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/10/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "CyclePathView.h"

@implementation CyclePathView

@synthesize titleLabel, leftBottomLabel, detailsLabel, subtitleLabel, rightBottomLabel, extraSubtitleLabel;


- (void) stylizeView
{
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:19]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
    
    [subtitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [subtitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [extraSubtitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [extraSubtitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [detailsLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [detailsLabel setTextColor:[LookAndFeel blueColor]];
    
    [rightBottomLabel setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [rightBottomLabel setTextColor:[LookAndFeel orangeColor]];
    
    [leftBottomLabel setFont:[LookAndFeel defaultFontLightWithSize:12]];
    [leftBottomLabel setTextColor:[LookAndFeel middleBlueColor]];

}

@end
