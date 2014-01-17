//
//  POICellView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/16/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface POICellView : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdatedAtLabel;
@property (nonatomic, weak) IBOutlet UIButton *viewOnMapButton;

- (void) stylizeView;

@end
