//
//  GradientView.h
//  Wikicleta
//
//  Created by Spalatinje on 8/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor-Expanded.h"
#import "AKNoiseImageEffect.h"
#import "AKGradientImageEffect.h"
#import "AKColorImageEffect.h"
#import "AKImageRenderer.h"
#import "AKImageCoordinator.h"

@interface GradientView : UIImageView

- (id) initWithFrame:(CGRect)frame withFirstColor:(NSString *)firstColor andSecondColor:(NSString *)secondColor;
- (id)initWithFrame:(CGRect)frame withBeginColor:(UIColor*)firstColor andEndColor:(UIColor*)endColor;

@end
