//
//  MarkerDetailsView.m
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MarkerDetailsView.h"

@implementation MarkerDetailsView

@synthesize iconLabel, title, subtitle, rankings, viewContainer, hideButton, moreInfoButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) loadDefaults
{
    //[viewContainer setBackgroundColor:[[LookAndFeel oran] colorWithAlphaComponent:0.4]];
    
    [subtitle setFont:[LookAndFeel defaultFontLightWithSize:10]];
    [subtitle setTextColor:[LookAndFeel blueColor]];
    
    [title setFont:[LookAndFeel defaultFontLightWithSize:20]];
    [title setTextColor:[LookAndFeel orangeColor]];
    
    [rankings setFont:[LookAndFeel defaultFontLightWithSize:18]];
    [rankings setTextColor:[LookAndFeel blueColor]];
}

@end
