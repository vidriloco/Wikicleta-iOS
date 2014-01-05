//
//  CyclestationUIView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LookAndFeel.h"

@interface CyclestationUIView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *availableBikesNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *availableBikesTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *availableSlotsNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *availableSlotsTextLabel;

@property (nonatomic, weak) IBOutlet UILabel *leftBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightBottomLabel;

- (void) stylizeView;

@end
