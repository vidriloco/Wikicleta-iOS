//
//  UIButtonWithLabel.m
//  Wikicleta
//
//  Created by Spalatinje on 8/6/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "UIButtonWithLabel.h"
#define kLabelHeight 30

@implementation UIButtonWithLabel

@synthesize button, name;

- (id)initWithFrame:(CGRect)frame withName:(NSString *)name_ withTextSeparation:(int)separation
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAlpha:0.8];
        float labelWidth = frame.size.width+20;
        
        label = [[UILabel alloc]
                          initWithFrame:CGRectMake(self.frame.size.width/2-labelWidth/2, separation, labelWidth, kLabelHeight)];
        
        self.name = name_;
        [label setText:NSLocalizedString(name, nil)];
        [label setFont:[UIFont fontWithName:@"Gotham Rounded" size:13]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setNumberOfLines:2];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithHexString:@"fb4e15"]];

        [self addSubview:label];
        
        UIImage *imageForButton = [UIImage imageNamed:[name stringByAppendingString:@".png"]];
        button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-imageForButton.size.width/2, 0, 45, 45)];
        [button setBackgroundImage:imageForButton forState:UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}

- (void) setSelected:(BOOL)selected
{
    if (selected) {
        [UIView animateWithDuration:0.5f animations:^{
            [label setTextColor:[UIColor colorWithHexString:@"fb4e15"]];
            [button setAlpha:1];
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            [label setTextColor:[UIColor colorWithHexString:@"1f3a50"]];
            [button setAlpha:0.3];
        }];
    }
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
