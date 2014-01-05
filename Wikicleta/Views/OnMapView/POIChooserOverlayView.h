//
//  POIChooserOverlayView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "App.h"

@interface POIChooserOverlayView : UIView

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;


@property (nonatomic, weak) IBOutlet UILabel* workshopLabel;
@property (nonatomic, weak) IBOutlet UILabel* parkingLabel;
@property (nonatomic, weak) IBOutlet UILabel* tipLabel;

@property (nonatomic, weak) IBOutlet UIButton* workshopButton;
@property (nonatomic, weak) IBOutlet UIButton* parkingButton;
@property (nonatomic, weak) IBOutlet UIButton* tipButton;

@property (nonatomic, weak) IBOutlet UIButton* closeButton;


- (void) stylizeUI;

@end
