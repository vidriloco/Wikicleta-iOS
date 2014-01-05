//
//  OnProfileSectionView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface OnProfileSectionView : UIButton

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *pictureImageView;

- (void) stylizeViewWithString:(NSString*)string;
- (void) animateSelectionExecutingBlockOnComplete:( void ( ^ )( void ) )block;

@end
