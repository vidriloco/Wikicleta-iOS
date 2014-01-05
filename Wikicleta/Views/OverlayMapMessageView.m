//
//  OverlayMapMessageView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "OverlayMapMessageView.h"

@implementation OverlayMapMessageView

@synthesize titleLabel, subtitleLabel;


- (void) loadViewWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle
{
    [LookAndFeel decorateUILabelAsMainViewTitle:titleLabel withLocalizedString:title];
    [LookAndFeel decorateUILabelAsMainViewSubtitle:subtitleLabel withLocalizedString:subtitle];
}

@end
