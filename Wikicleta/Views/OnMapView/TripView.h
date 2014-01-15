//
//  TripView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/12/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface TripView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *hiddenTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UIImageView *picImageView;
@property (nonatomic, weak) IBOutlet UIButton *fixateTogglerButton;

- (void) stylizeView;

@end
