//
//  MarkerDetailsView.h
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface MarkerDetailsView : UIView {
    UILabel         *title;
    UIImageView     *iconLabel;
    UILabel         *subtitle;
    
    UIView          *viewContainer;
    UILabel         *rankings;
    UIButton        *hideButton;
    UIButton        *moreInfoButton;
}

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UIImageView *iconLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitle;
@property (nonatomic, strong) IBOutlet UIView *viewContainer;
@property (nonatomic, strong) IBOutlet UILabel *rankings;

@property (nonatomic, strong) IBOutlet UIButton *hideButton;
@property (nonatomic, strong) IBOutlet UIButton *moreInfoButton;


- (void) loadDefaults;

@end
