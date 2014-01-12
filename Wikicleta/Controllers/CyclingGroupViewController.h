//
//  CyclingGroupViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 1/11/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "UIViewController+Helpers.h"
#import "TTTTimeIntervalFormatter.h"
#import "CyclingGroup.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface CyclingGroupViewController : UIViewController {
    CyclingGroup *selectedModel;
}

@property (nonatomic, strong) CyclingGroup *selectedModel;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *daysToEventLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *departureTimeTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *meetingTimeTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *departureTimeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *meetingTimeValueLabel;

@property (nonatomic, weak) IBOutlet UILabel *updatedAtLabel;
@property (nonatomic, weak) IBOutlet UILabel *createdByLabel;

@property (nonatomic, weak) IBOutlet UIImageView *contributorPicImageView;
@property (nonatomic, weak) IBOutlet UIImageView *picImageView;

@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, weak) IBOutlet UIButton *facebookButton;
@property (nonatomic, weak) IBOutlet UIButton *websiteButton;

@property (nonatomic, weak) IBOutlet UIView *detailsView;
@property (nonatomic, weak) IBOutlet UIView *attributionView;


@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

- (void) completeLoadView;

@end