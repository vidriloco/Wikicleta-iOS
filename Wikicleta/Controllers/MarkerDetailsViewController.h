//
//  MarkerDetailsViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/26/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "UIViewController+Helpers.h"
#import "BaseModel.h"
#import <QuartzCore/QuartzCore.h>
#import "TTTTimeIntervalFormatter.h"
#import "ModelHumanizer.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "Workshop.h"

@interface MarkerDetailsViewController : UIViewController {
    id <ModelHumanizer> selectedModel;
}

@property (nonatomic, strong) id <ModelHumanizer> selectedModel;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UIView *detailsView;

@property (nonatomic, weak) IBOutlet UILabel *createdBy;
@property (nonatomic, weak) IBOutlet UILabel *updatedAt;
@property (nonatomic, weak) IBOutlet UIView *attributionView;
@property (nonatomic, weak) IBOutlet UIImageView *contributorPic;

@property (nonatomic, weak) IBOutlet UILabel *extraAnnotationLabel;
@property (nonatomic, weak) IBOutlet UILabel *communityTitleLabel;


@property (nonatomic, weak) IBOutlet UIButton *likesButton;
@property (nonatomic, weak) IBOutlet UIButton *dislikesButton;
@property (nonatomic, weak) IBOutlet UIImageView *likesImage;
@property (nonatomic, weak) IBOutlet UIImageView *dislikesImage;
@property (nonatomic, weak) IBOutlet UILabel *likesLabel;
@property (nonatomic, weak) IBOutlet UILabel *dislikesLabel;

@property (nonatomic, weak) IBOutlet UIView *communityOpinionsView;

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;

// Properties for Workshops

@property (nonatomic, weak) IBOutlet UILabel *contactTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *twitterAccountLabel;
@property (nonatomic, weak) IBOutlet UILabel *websiteLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellphoneLabel;
@property (nonatomic, weak) IBOutlet UIView *contactView;

@end
