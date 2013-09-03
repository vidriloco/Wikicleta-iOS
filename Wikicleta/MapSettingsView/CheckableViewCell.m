//
//  CheckableViewCell.m
//  Wikicleta
//
//  Created by Spalatinje on 9/2/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "CheckableViewCell.h"

@implementation CheckableViewCell

@synthesize mainLabel, settingsIcon, checkedImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [[self settingsIcon] setAlpha:1];
        [[self checkedImage] setAlpha:1];
    } else {
        [[self settingsIcon] setAlpha:0.3];
        [[self checkedImage] setAlpha:0.1];

    }
}

@end
