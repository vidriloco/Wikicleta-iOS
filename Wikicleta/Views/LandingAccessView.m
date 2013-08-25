//
//  LandingAccessView.m
//  Wikicleta
//
//  Created by Spalatinje on 8/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LandingAccessView.h"

@implementation LandingAccessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [self.layer setBorderColor:[UIColor colorWithHexString:@"d5e6f3"].CGColor];
        [self.layer setBorderWidth:0.3];
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
