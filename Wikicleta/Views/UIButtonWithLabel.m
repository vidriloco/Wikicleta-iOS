//
//  UIButtonWithLabel.m
//  Wikicleta
//
//  Created by Spalatinje on 8/6/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "UIButtonWithLabel.h"
#define kLabelHeight 30
#define kLabelMarginTop 50

@implementation UIButtonWithLabel

- (id)initWithFrame:(CGRect)frame withImageNamed:(NSString *)image withTextLabel:(NSString *)textLabel
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAlpha:0.8];
        float labelWidth = frame.size.width+20;
        
        UILabel *label = [[UILabel alloc]
                          initWithFrame:CGRectMake(self.frame.size.width/2-labelWidth/2, kLabelMarginTop, labelWidth, kLabelHeight)];
        [label setText:textLabel];
        [label setFont:[UIFont fontWithName:@"Gotham Rounded" size:15]];
        [label setTextColor:[UIColor colorWithHexString:@"fb4e15"]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        
        [self addSubview:backgroundImage];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
