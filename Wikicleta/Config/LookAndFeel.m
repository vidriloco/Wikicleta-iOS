//
//  LookAndFeel.m
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LookAndFeel.h"

@implementation LookAndFeel

+ (UIColor*) blueColor
{
    return [UIColor colorWithHexString:@"1f3a50"];
}

+ (UIColor*) orangeColor
{
    return [UIColor colorWithHexString:@"fb4e15"];
}

+ (UIColor*) lightBlueColor
{
    return [UIColor colorWithHexString:@"E0EAF4"];
}

+ (UIColor*) middleBlueColor
{
    return [UIColor colorWithHexString:@"357CB7"];
}

+ (UIColor*) greenColor
{
    return [UIColor colorWithHexString:@"22B204"];
}

+ (UIFont*) defaultFontLightWithSize:(int)size
{
    return [UIFont fontWithName:@"Gotham Rounded" size:size];
}

+ (UIFont*) defaultFontBoldWithSize:(int)size
{
    return [UIFont fontWithName:@"GothamRounded-Bold" size:size];
}

+ (UIFont*) defaultFontBookWithSize:(int)size
{
    return [UIFont fontWithName:@"GothamRounded-Book" size:size];
}

+ (void) decorateUILabelAsMainViewTitle:(UILabel*) titleLabel withLocalizedString:(NSString *)localizedString
{
    if (localizedString != nil) {
        [titleLabel setText:NSLocalizedString(localizedString, nil)];
    }
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:titleFontSize]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
}

+ (void) decorateUILabelAsMainViewSubtitle:(UILabel*) subtitleLabel withLocalizedString:(NSString *)localizedString
{
    if (localizedString != nil) {
        [subtitleLabel setText:NSLocalizedString(localizedString, nil)];
    }
    [subtitleLabel setFont:[LookAndFeel defaultFontLightWithSize:subtitleFontSize]];
    [subtitleLabel setTextColor:[LookAndFeel blueColor]];
}

+ (void) decorateUILabelAsCommon:(UILabel*) label withLocalizedString:(NSString*)localizedString
{
    if (localizedString != nil) {
        [label setText:NSLocalizedString(localizedString, nil)];
    }
    [label setFont:[LookAndFeel defaultFontBookWithSize:normalFontSize]];
    [label setTextColor:[LookAndFeel blueColor]];
}

+ (void) decorateUITextField:(UITextField*)textField withLocalizedPlaceholder:(NSString *)localizedPlaceholder
{
    if (localizedPlaceholder != nil) {
        [textField setPlaceholder:NSLocalizedString(localizedPlaceholder, nil)];
    }
    [textField setFont:[LookAndFeel defaultFontLightWithSize:formFontSize]];
}

+ (void) decorateUITextView:(UITextView*)textView withLocalizedPlaceholder:(NSString *)localizedPlaceholder
{
    if (localizedPlaceholder != nil) {
        [textView setText:NSLocalizedString(localizedPlaceholder, nil)];
    }
    [textView setFont:[LookAndFeel defaultFontLightWithSize:formFontSize]];
}


@end
