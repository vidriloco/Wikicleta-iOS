//
//  GradientView.m
//  Wikicleta
//
//  Created by Spalatinje on 8/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id) initWithFrame:(CGRect)frame
      withFirstColor:(NSString *)firstColor
      andSecondColor:(NSString *)secondColor {
    
    return [self initWithFrame:frame
                withBeginColor:[UIColor colorWithHexString:firstColor]
                   andEndColor:[UIColor colorWithHexString:secondColor]];
}

- (id)initWithFrame:(CGRect)frame withBeginColor:(UIColor*)firstColor andEndColor:(UIColor*)endColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        AKGradientImageEffect *gradientEffect =
        [[AKGradientImageEffect alloc] initWithAlpha:1.0f
                                           blendMode:kCGBlendModeMultiply
                                              colors:@[firstColor, endColor]
                                           direction:AKGradientDirectionVertical
                                           locations:[NSArray arrayWithObjects:[NSNumber numberWithDouble:0.2], nil]];
        
        
        // Create the image renderer
        AKImageRenderer *imageRenderer = [[AKImageRenderer alloc] init];
        
        [imageRenderer setImageEffects:@[
         gradientEffect,
         ]];
        
        AKImageCoordinator *imageCoordinator = [[AKImageCoordinator alloc] init];
        [imageCoordinator setImageRenderer:imageRenderer];
        
        [imageCoordinator addImageView:self];
    }
    return self;
}

@end
