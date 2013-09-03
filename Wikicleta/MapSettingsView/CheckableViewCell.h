//
//  CheckableViewCell.h
//  Wikicleta
//
//  Created by Spalatinje on 9/2/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckableViewCell : UITableViewCell {
    UILabel *mainLabel;
    UIImageView *settingsIcon;
    UIImageView *checkedImage;
}

@property (nonatomic, strong) IBOutlet UILabel *mainLabel;
@property (nonatomic, strong) IBOutlet UIImageView *settingsIcon;
@property (nonatomic, strong) IBOutlet UIImageView *checkedImage;

@end
