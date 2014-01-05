//
//  OnProfileSectionView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "OnProfileSectionView.h"

@implementation OnProfileSectionView

@synthesize titleLabel, pictureImageView;

- (void) stylizeViewWithString:(NSString *)string
{
    [LookAndFeel decorateUILabelAsMainViewTitle:titleLabel withLocalizedString:string];
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:23]];
}

- (void) animateSelectionExecutingBlockOnComplete:( void ( ^ )( void ) )block
{
    [self setBackgroundColor:[LookAndFeel lightBlueColor]];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setBackgroundColor:[UIColor clearColor]];
        block();
    });
}

@end
