//
//  POIChooserOverlayView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "POIChooserOverlayView.h"

@implementation POIChooserOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) stylizeUI
{
    [[self titleLabel] setTextColor:[LookAndFeel blueColor]];
    [[self titleLabel] setFont:[LookAndFeel defaultFontBoldWithSize:20]];
    [[self titleLabel] setText:[NSLocalizedString(@"share_title", nil) uppercaseString]];
    
    [[self tipLabel] setTextColor:[LookAndFeel orangeColor]];
    [[self tipLabel] setFont:[LookAndFeel defaultFontBoldWithSize:16]];
    [[self tipLabel] setText:NSLocalizedString(@"tip", nil)];
    [[self tipButton].layer setShadowColor:[UIColor grayColor].CGColor];
    [[self tipButton].layer setShadowOpacity:0.3f];
    [[self tipButton].layer setShadowOffset:CGSizeMake(0.2, 0.2)];
    [[self tipButton].layer setCornerRadius:5];
    [[self tipButton] setTag:2];

    [[self workshopLabel] setTextColor:[LookAndFeel orangeColor]];
    [[self workshopLabel] setFont:[LookAndFeel defaultFontBoldWithSize:16]];
    [[self workshopLabel] setText:NSLocalizedString(@"workshop", nil)];
    [[self workshopButton].layer setShadowColor:[UIColor grayColor].CGColor];
    [[self workshopButton].layer setShadowOpacity:0.3f];
    [[self workshopButton].layer setShadowOffset:CGSizeMake(0.2, 0.2)];
    [[self workshopButton].layer setCornerRadius:5];
    [[self workshopButton] setTag:0];

    [[self parkingLabel] setTextColor:[LookAndFeel orangeColor]];
    [[self parkingLabel] setFont:[LookAndFeel defaultFontBoldWithSize:16]];
    [[self parkingLabel] setText:NSLocalizedString(@"parking", nil)];
    [[self parkingButton].layer setShadowColor:[UIColor grayColor].CGColor];
    [[self parkingButton].layer setShadowOpacity:0.3f];
    [[self parkingButton].layer setShadowOffset:CGSizeMake(0.2, 0.2)];
    [[self parkingButton].layer setCornerRadius:5];
    [[self parkingButton] setTag:1];

    [[[self closeButton] titleLabel] setTextColor:[LookAndFeel orangeColor]];
    [[[self closeButton] titleLabel] setFont:[LookAndFeel defaultFontLightWithSize:16]];
    [[[self closeButton] titleLabel] setText:NSLocalizedString(@"share_close_text", nil)];
    [[self closeButton] setFrame:CGRectMake(self.closeButton.frame.origin.x,
                                            [App viewBounds].size.height-self.closeButton.frame.size.height-10,
                                            self.closeButton.frame.size.width, self.closeButton.frame.size.height)];
}

@end
