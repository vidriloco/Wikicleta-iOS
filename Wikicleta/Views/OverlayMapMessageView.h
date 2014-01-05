//
//  OverlayMapMessageView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface OverlayMapMessageView : UIView {
    UILabel *titleLabel;
    UILabel *subtitleLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;

- (void) loadViewWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle;

@end
