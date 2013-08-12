//
//  MenuViewCell.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/11/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MenuViewCell.h"

@interface MenuViewCell() {
    NSString *sectionName;
}

@end

@implementation MenuViewCell

@synthesize mainLabel, iconCell;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
    withSectionName:(NSString *)name
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Helpers
        CGSize size = self.contentView.frame.size;
        // Initialize Main Label
        self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 9, size.width - 16.0, size.height - 16.0)];
        // Configure Main Label
        [self.mainLabel setTextColor:[UIColor colorWithHexString:@"1f3a50"]];
        [self.mainLabel setFont:[UIFont fontWithName:@"Gotham Rounded" size:20]];
        [self.mainLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        // Add Main Label to Content View
        [self.contentView addSubview:self.mainLabel];
        
        UIView *selectedBackground = [[UIView alloc] initWithFrame:self.contentView.frame];
        [selectedBackground.layer setCornerRadius:7];
        [selectedBackground.layer setBackgroundColor:[UIColor colorWithHexString:@"fb4e15"].CGColor];
        [self setSelectedBackgroundView:selectedBackground];
        
        sectionName = name;
        iconCell = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[sectionName stringByAppendingString:@"_menu.png"]]];
        [iconCell setCenter:CGPointMake(iconCell.center.x+5, iconCell.center.y+5)];
        [self.contentView addSubview:iconCell];
        [self.mainLabel setText:NSLocalizedString(sectionName, @"Translate sectionId name to human name")];
    }
    return self;
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.mainLabel setTextColor:[UIColor whiteColor]];
        [self.iconCell setImage:[UIImage imageNamed:[sectionName stringByAppendingString:@"_menu_selected.png"]]];
    } else {
        [self.mainLabel setTextColor:[UIColor colorWithHexString:@"1f3a50"]];
        [self.iconCell setImage:[UIImage imageNamed:[sectionName stringByAppendingString:@"_menu.png"]]];
    }
}

@end
