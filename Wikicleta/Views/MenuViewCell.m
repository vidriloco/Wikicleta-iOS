//
//  MenuViewCell.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/11/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MenuViewCell.h"

@implementation MenuViewCell

@synthesize mainLabel, iconCell;

- (void) setIconAndTextByName:(NSString *)name
{
    [self.mainLabel setText:NSLocalizedString([name stringByAppendingString:@"_menu"], nil)];
    [self.mainLabel setTextAlignment:NSTextAlignmentCenter];
    [self.iconCell setImage:[UIImage imageNamed:[name stringByAppendingString:@"_menu.png"]]];
    [self.mainLabel setFont:[LookAndFeel defaultFontLightWithSize:18]];
}

- (void) setDefaultLookAndFeel
{
    UIView *selectedBackground = [[UIView alloc] initWithFrame:self.contentView.frame];
    [selectedBackground.layer setCornerRadius:7];
    [selectedBackground.layer setBackgroundColor:[[LookAndFeel orangeColor]
                         colorWithAlphaComponent:0.1].CGColor];
    [selectedBackground.layer setOpacity:0.4];
    [self setSelectedBackgroundView:selectedBackground];
}

@end
