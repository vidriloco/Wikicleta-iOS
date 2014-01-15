//
//  TripPoiView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/13/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "TripPoiView.h"

@implementation TripPoiView

@synthesize titleLabel, detailsLabel, subtitleLabel;

- (void) stylizeView
{
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:18]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
    
    [subtitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:13]];
    [subtitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [detailsLabel setFont:[LookAndFeel defaultFontBookWithSize:12]];
    [detailsLabel setTextColor:[LookAndFeel blueColor]];
    
    [titleLabel setText:@""];
    [subtitleLabel setText:@""];
    [detailsLabel setText:@""];

    [self setBackgroundColor:[UIColor colorWithWhite:255 alpha:0.7]];
}


@end
