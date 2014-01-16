//
//  MarkerInfoUIView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/25/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MarkerInfoUIView.h"

@implementation MarkerInfoUIView

@synthesize titleLabel, subtitleLabel, favoriteButton, leftBottomLabel, rightBottomLabel, editButton, editView, deleteButton;

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
    
    [editView setBackgroundColor:[LookAndFeel orangeColor]];
    
    [editButton.titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:14]];
    [editButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [deleteButton.titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:14]];
    [deleteButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [deleteButton setTitle:NSLocalizedString(@"delete", nil) forState:UIControlStateNormal];
    [editButton setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];

}

- (void) clearEditArea
{
    [editView removeFromSuperview];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 107)];
}

@end
