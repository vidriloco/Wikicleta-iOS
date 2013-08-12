//
//  UIButtonWS.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/7/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "UIButtonWS.h"
#import "UIColor-Expanded.h"

@implementation UIButtonWS

- (id)initWithTitle:(NSString*)title withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [label setText:title];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor colorWithHexString:@"#FFF"]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [self addSubview:label];
        [self setHighlighted:YES];
        
        [self setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    }
    return self;
}

@end
