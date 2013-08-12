//
//  MenuViewCell.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/11/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor-Expanded.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewCell : UITableViewCell {
    UILabel *mainLabel;
    UIImageView *iconCell;
}

@property (strong, nonatomic) UILabel *mainLabel;
@property (strong, nonatomic) UIImageView *iconCell;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
    withSectionName:(NSString*)name;
@end
