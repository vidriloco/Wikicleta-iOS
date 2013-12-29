//
//  RouteUIView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface RouteUIView : UIView

@property (nonatomic, weak) IBOutlet UILabel *distanceNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceWordsLabel;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *leftBottomLabel;

@property (nonatomic, weak) IBOutlet UIButton *goToButton;
@property (nonatomic, weak) IBOutlet UIButton *attachButton;

@property (nonatomic, weak) IBOutlet UIButton *moreDetailsButton;

- (void) stylizeView;

@end
