//
//  TripPoiView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/13/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface TripPoiView : UIView


@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;

- (void) stylizeView;

@end
