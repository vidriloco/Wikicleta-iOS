//
//  InstantDetailsView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/25/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface InstantDetailsView : UIView


@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *timingTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *timingValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedUnitLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceUnitLabel;
@property (nonatomic, weak) IBOutlet UILabel *timingUnitLabel;

- (void) stylizeView;

@end
