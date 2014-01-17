//
//  GenericBigMessageView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/17/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface GenericBigMessageView : UIView

@property (nonatomic, weak) IBOutlet UILabel* messageLabel;
@property (nonatomic, weak) IBOutlet UILabel* submessageLabel;
@property (nonatomic, weak) IBOutlet UIImageView* imageView;

- (void) stylizeView;

@end
