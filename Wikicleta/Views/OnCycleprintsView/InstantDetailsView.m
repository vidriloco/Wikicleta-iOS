//
//  InstantDetailsView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/25/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "InstantDetailsView.h"

@implementation InstantDetailsView

@synthesize speedTextLabel, speedUnitLabel, speedValueLabel, distanceTextLabel, distanceUnitLabel, distanceValueLabel, timingTextLabel, timingUnitLabel, timingValueLabel, titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) stylizeView
{
    [LookAndFeel decorateUILabelAsMainViewTitle:titleLabel withLocalizedString:@"pedal_punch_at_this_point"];
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    
    [speedTextLabel setFont:[LookAndFeel defaultFontBookWithSize:10]];
    [distanceTextLabel setFont:[LookAndFeel defaultFontBookWithSize:10]];
    [timingTextLabel setFont:[LookAndFeel defaultFontBookWithSize:10]];
    [speedTextLabel setTextColor:[LookAndFeel blueColor]];
    [distanceTextLabel setTextColor:[LookAndFeel blueColor]];
    [timingTextLabel setTextColor:[LookAndFeel blueColor]];
    [speedTextLabel setText:NSLocalizedString(@"pedal_punch_at_this_point_speed", nil).uppercaseString];
    [distanceTextLabel setText:NSLocalizedString(@"pedal_punch_at_this_point_distance", nil).uppercaseString];
    [timingTextLabel  setText:NSLocalizedString(@"pedal_punch_at_this_point_timing", nil).uppercaseString];
    
    [speedValueLabel setFont:[LookAndFeel defaultFontBoldWithSize:20]];
    [distanceValueLabel setFont:[LookAndFeel defaultFontBoldWithSize:20]];
    [timingValueLabel setFont:[LookAndFeel defaultFontBoldWithSize:20]];
    [speedValueLabel setTextColor:[LookAndFeel orangeColor]];
    [distanceValueLabel setTextColor:[LookAndFeel orangeColor]];
    [timingValueLabel setTextColor:[LookAndFeel orangeColor]];
    
    
    [speedUnitLabel setFont:[LookAndFeel defaultFontBoldWithSize:11]];
    [distanceUnitLabel setFont:[LookAndFeel defaultFontBoldWithSize:11]];
    [timingUnitLabel setFont:[LookAndFeel defaultFontBoldWithSize:11]];
    [speedUnitLabel setTextColor:[LookAndFeel orangeColor]];
    [distanceUnitLabel setTextColor:[LookAndFeel orangeColor]];
    [timingUnitLabel setTextColor:[LookAndFeel orangeColor]];
    [timingUnitLabel setText:NSLocalizedString(@"pedal_punch_at_this_minutes", nil)];
}


@end
