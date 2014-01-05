//
//  SelectOnTapView.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface SelectOnTapView : UIButton

@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

- (void) stylizeView;

@end
