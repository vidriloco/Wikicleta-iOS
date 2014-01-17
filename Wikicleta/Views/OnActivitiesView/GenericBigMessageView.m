//
//  GenericBigMessageView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/17/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "GenericBigMessageView.h"

@implementation GenericBigMessageView

@synthesize messageLabel, submessageLabel, imageView;

- (void) stylizeView
{
    [messageLabel setTextColor:[LookAndFeel orangeColor]];
    [messageLabel setFont:[LookAndFeel defaultFontBookWithSize:20]];
    
    [submessageLabel setTextColor:[LookAndFeel blueColor]];
    [submessageLabel setFont:[LookAndFeel defaultFontLightWithSize:17]];
}

@end
