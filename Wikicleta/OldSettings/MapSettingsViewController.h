//
//  MapSettingsViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 9/1/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "App.h"
#import "LayersGroupsViewController.h"

#define kPagesLevelOne  2

@interface MapSettingsViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet UILabel *navBarTitle;
@property (nonatomic, strong) IBOutlet UILabel *settingsText;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *jumpGroupsController;

@end
