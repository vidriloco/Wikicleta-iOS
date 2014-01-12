//
//  CyclingGroupViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz on 1/11/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "CyclingGroupViewController.h"

@interface CyclingGroupViewController () {
    
}

- (void) visitWebpage;
- (void) visitFacebookPage;
- (void) visitTwitterPage;

@end

@implementation CyclingGroupViewController

@synthesize selectedModel, nameLabel, daysToEventLabel, meetingTimeTitleLabel, meetingTimeValueLabel, departureTimeTitleLabel, departureTimeValueLabel, detailsLabel, picImageView, contributorPicImageView, createdByLabel, updatedAtLabel, twitterButton, facebookButton, websiteButton, detailsView, attributionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"cycling_group_title", nil);
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(UINavigationController*) [[self viewDeckController] centerController] setNavigationBarHidden:NO];
    
    [self resizeContentScrollToFit:self.contentScrollView withIncrement:20];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setImageAsBackground:selectedModel.bigIcon];
    [self loadNavigationBarDefaultStyle];
    [self completeLoadView];
    [[self viewDeckController] setRightController:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) visitWebpage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedModel.websiteUrl]];
}


- (void) visitFacebookPage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedModel.facebookUrl]];
}

- (void) visitTwitterPage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://www.twitter.com/" stringByAppendingString:selectedModel.twitterAccount]]];
}

- (void) completeLoadView
{
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    
    [nameLabel setText:selectedModel.name];
    [nameLabel setFont:[LookAndFeel defaultFontBoldWithSize:17]];
    [nameLabel setTextColor:[LookAndFeel blueColor]];
    
    [daysToEventLabel setText:selectedModel.subtitle];
    [daysToEventLabel setFont:[LookAndFeel defaultFontLightWithSize:14]];
    [daysToEventLabel setTextColor:[LookAndFeel orangeColor]];
    
    [detailsLabel setText:[selectedModel details]];
    [detailsLabel setTextAlignment:NSTextAlignmentJustified];
    [detailsLabel setFont:[LookAndFeel defaultFontLightWithSize:18]];
    [detailsLabel setTextColor:[LookAndFeel blueColor]];
    
    [departureTimeTitleLabel setText:NSLocalizedString(@"leaving_at", nil)];
    [departureTimeTitleLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [departureTimeTitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [meetingTimeTitleLabel setText:NSLocalizedString(@"arriving_at", nil)];
    [meetingTimeTitleLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [meetingTimeTitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [departureTimeValueLabel setText:selectedModel.departingTime];
    [departureTimeValueLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [departureTimeValueLabel setTextColor:[LookAndFeel orangeColor]];
    
    [meetingTimeValueLabel setText:selectedModel.meetingTime];
    [meetingTimeValueLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [meetingTimeValueLabel setTextColor:[LookAndFeel orangeColor]];
    
    if ([selectedModel twitterAccount].length == 0) {
        [twitterButton setTitle:NSLocalizedString(@"not_available", nil) forState:UIControlStateNormal];
    } else {
        [twitterButton setTitle:[@"@" stringByAppendingString:selectedModel.twitterAccount] forState:UIControlStateNormal];
        [twitterButton addTarget:self action:@selector(visitTwitterPage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [twitterButton.titleLabel setFont:[LookAndFeel defaultFontBookWithSize:17]];
    [twitterButton.titleLabel setTextColor:[LookAndFeel blueColor]];

    if ([selectedModel facebookUrl].length == 0) {
        [facebookButton setTitle:NSLocalizedString(@"not_available", nil) forState:UIControlStateNormal];
    } else {
        [facebookButton setTitle:@"Facebook" forState:UIControlStateNormal];
        [facebookButton addTarget:self action:@selector(visitFacebookPage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [facebookButton.titleLabel setFont:[LookAndFeel defaultFontBookWithSize:17]];
    [facebookButton.titleLabel setTextColor:[LookAndFeel blueColor]];
    
    if ([selectedModel websiteUrl].length == 0) {
        [websiteButton setTitle:NSLocalizedString(@"not_available", nil) forState:UIControlStateNormal];
    } else {
        [websiteButton setTitle:@"Web" forState:UIControlStateNormal];
        [websiteButton addTarget:self action:@selector(visitWebpage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [websiteButton.titleLabel setFont:[LookAndFeel defaultFontBookWithSize:17]];
    [websiteButton.titleLabel setTextColor:[LookAndFeel blueColor]];
    
    NSString *updatedAtString = [timeIntervalFormatter stringForTimeInterval:[selectedModel.updatedAt timeIntervalSinceNow]];
    
    [createdByLabel setText:selectedModel.createdBy];
    [createdByLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [createdByLabel setTextColor:[LookAndFeel blueColor]];
    
    [updatedAtLabel setText:[NSLocalizedString(@"updated_at", nil) stringByAppendingString:updatedAtString]];
    [updatedAtLabel setFont:[LookAndFeel defaultFontLightWithSize:11]];
    [updatedAtLabel setTextColor:[LookAndFeel orangeColor]];
    
    if ([(CyclingGroup*) selectedModel picUrl] != nil) {
        
        [UIView animateWithDuration:1.5 delay:1 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut) animations:^{
            [picImageView setAlpha:0.5];
        } completion:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[(CyclingGroup*) selectedModel picUrl]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        [picImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"cycling_group_logo"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [picImageView.layer removeAllAnimations];
            [picImageView setAlpha:1];
            [picImageView setImage:image];
            [picImageView.layer setCornerRadius:10];
            picImageView.layer.masksToBounds = YES;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [picImageView.layer removeAllAnimations];
        }];
    } else {
        [picImageView.layer setCornerRadius:10];
        picImageView.layer.masksToBounds = YES;
    }

    
    if ([selectedModel userPicURL] != nil) {
        [UIView animateWithDuration:1.5 delay:1 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut) animations:^{
            [contributorPicImageView setAlpha:0.5];
        } completion:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[selectedModel userPicURL]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        [contributorPicImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"profile_placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [contributorPicImageView.layer removeAllAnimations];
            [contributorPicImageView setAlpha:1];
            [contributorPicImageView setImage:image];
            [contributorPicImageView.layer setCornerRadius:18];
            contributorPicImageView.layer.masksToBounds = YES;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [contributorPicImageView.layer removeAllAnimations];
        }];
    }
    
    //adjust the label the the new height.
    
    [self stylizeViewContainerBlock:detailsView];
    [self stylizeViewContainerBlock:attributionView];
    [self stylizeViewContainerBlock:twitterButton];
    [self stylizeViewContainerBlock:facebookButton];
    [self stylizeViewContainerBlock:websiteButton];

    [self.view bringSubviewToFront:self.contentScrollView];
}

- (void) stylizeViewContainerBlock:(UIView*)viewBlock
{
    [viewBlock setBackgroundColor:[UIColor whiteColor]];
    [viewBlock setAlpha:0.8];
    [viewBlock.layer setBorderColor:[LookAndFeel lightBlueColor].CGColor];
    [viewBlock.layer setBorderWidth:1];
    [viewBlock.layer setShadowColor:[UIColor grayColor].CGColor];
    [viewBlock.layer setShadowOffset:CGSizeMake(0.2, 0.2)];
    [viewBlock.layer setShadowOpacity:0.1];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [(UINavigationController*) [[self viewDeckController] centerController] setNavigationBarHidden:YES];
}


@end
