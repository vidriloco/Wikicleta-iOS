//
//  MarkerInfoUIView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/25/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LookAndFeel.h"

@interface MarkerInfoUIView : UIView 

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@property (nonatomic, weak) IBOutlet UILabel *leftBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightBottomLabel;
@property (nonatomic, weak) IBOutlet UIButton *moreDetailsButton;

@property (nonatomic, weak) IBOutlet UIView *editView;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;


- (void) stylizeView;
- (void) clearEditArea;
@end
