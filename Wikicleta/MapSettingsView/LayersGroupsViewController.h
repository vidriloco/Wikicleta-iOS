//
//  LayersGroupsViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 9/1/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "App.h"
#import "CheckableViewCell.h"
#import "GlobalSettings.h"

#define rowHeight 63

@interface LayersGroupsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *layerTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *navBarTitle;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UIImageView *selectedSetImage;

@property (assign, nonatomic) NSInteger index;

@end
