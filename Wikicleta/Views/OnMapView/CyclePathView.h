//
//  CyclePathView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/10/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface CyclePathView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *extraSubtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *leftBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightBottomLabel;


- (void) stylizeView;

@end
