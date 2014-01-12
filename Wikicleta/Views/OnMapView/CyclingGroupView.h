//
//  CyclingGroupView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/11/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import <QuartzCore/QuartzCore.h>

@interface CyclingGroupView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *picImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *leftBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightBottomLabel;
@property (nonatomic, weak) IBOutlet UIButton *moreDetailsButton;


- (void) stylizeView;

@end
