//
//  POICellView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/16/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "POICellView.h"

@implementation POICellView

@synthesize titleLabel, subtitleLabel, categoryImageView, detailsLabel, lastUpdatedAtLabel, viewOnMapButton;

- (void) stylizeView {
    [titleLabel setFont:[LookAndFeel defaultFontLightWithSize:17]];
    [subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:14]];
    [titleLabel setTextColor:[LookAndFeel blueColor]];
    [subtitleLabel setTextColor:[LookAndFeel orangeColor]];
    
    [detailsLabel setTextColor:[LookAndFeel blueColor]];
    [detailsLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    
    [lastUpdatedAtLabel setFont:[LookAndFeel defaultFontBoldWithSize:13]];
    [lastUpdatedAtLabel setTextColor:[LookAndFeel blueColor]];

    [viewOnMapButton setTitleColor:[LookAndFeel orangeColor] forState:UIControlStateNormal];
    [viewOnMapButton setTitle:NSLocalizedString(@"see_on_map", nil) forState:UIControlStateNormal];
    [viewOnMapButton.titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:13]];
    
}

@end
