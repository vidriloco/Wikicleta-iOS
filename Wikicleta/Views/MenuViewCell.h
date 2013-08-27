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

@property (nonatomic, strong) IBOutlet UILabel *mainLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconCell;

- (void) setIconAndTextByName:(NSString*)name;
- (void) setDefaultLookAndFeel;
@end
