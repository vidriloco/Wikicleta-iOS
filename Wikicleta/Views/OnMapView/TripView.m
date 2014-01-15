//
//  TripView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/12/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "TripView.h"

@implementation TripView

@synthesize titleLabel, detailsLabel, subtitleLabel, picImageView, fixateTogglerButton, hiddenTitleLabel;

- (void) stylizeView
{
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:18]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];

    [hiddenTitleLabel setFont:[LookAndFeel defaultFontBookWithSize:18]];
    [hiddenTitleLabel setTextColor:[LookAndFeel orangeColor]];
    [hiddenTitleLabel setHidden:YES];
    
    [subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:11]];
    [subtitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [detailsLabel setFont:[LookAndFeel defaultFontBookWithSize:12]];
    [detailsLabel setTextColor:[LookAndFeel blueColor]];
    
    [picImageView.layer setCornerRadius:10];
    picImageView.layer.masksToBounds = YES;
}

@end
