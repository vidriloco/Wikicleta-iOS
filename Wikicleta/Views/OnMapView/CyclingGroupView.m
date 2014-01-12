//
//  CyclingGroupView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/11/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "CyclingGroupView.h"

@implementation CyclingGroupView

@synthesize picImageView, leftBottomLabel, rightBottomLabel, titleLabel, subtitleLabel, moreDetailsButton, detailsLabel;

- (void) stylizeView {
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:18]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
    
    [subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:11]];
    [subtitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [rightBottomLabel setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [rightBottomLabel setTextColor:[LookAndFeel orangeColor]];
    
    [leftBottomLabel setFont:[LookAndFeel defaultFontLightWithSize:12]];
    [leftBottomLabel setTextColor:[LookAndFeel middleBlueColor]];

    [detailsLabel setFont:[LookAndFeel defaultFontBookWithSize:13]];
    [detailsLabel setTextColor:[LookAndFeel blueColor]];
    
    [picImageView.layer setCornerRadius:10];
    picImageView.layer.masksToBounds = YES;
}

@end
