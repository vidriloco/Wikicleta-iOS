//
//  LayerItemView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface LayerItemView : UIButton {
    NSString *name;
}

@property (nonatomic, strong) NSString *name;

@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

- (void) setSelected:(BOOL)selected;

@end
