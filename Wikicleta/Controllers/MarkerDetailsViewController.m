//
//  MarkerDetailsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/26/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MarkerDetailsViewController.h"

@interface MarkerDetailsViewController () {
    
}

- (void) completeLoadView;
- (void) stylizeViewContainerBlock:(UIView*)viewBlock;
@end

@implementation MarkerDetailsViewController

@synthesize selectedModel, titleLabel, subtitleLabel, communityOpinionsView, detailsLabel, detailsView, attributionView, createdBy, updatedAt, communityTitleLabel, dislikesLabel, likesLabel, likesButton, dislikesButton, contributorPic, extraAnnotationLabel, contactTitleLabel, contactView, phoneLabel, cellphoneLabel, twitterAccountLabel, websiteLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"poi_details_title", nil);
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(UINavigationController*) [[self viewDeckController] centerController] setNavigationBarHidden:NO];
    
    if ([selectedModel isKindOfClass:[Workshop class]]) {
        [self resizeContentScrollToFit:self.contentScrollView];
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setImageAsBackground:selectedModel.bigIcon];
    [self loadNavigationBarDefaultStyle];
    [self completeLoadView];
    [[self viewDeckController] setRightController:nil];
    [self reflectFavoritedStatusForItemWithId:[selectedModel identifier] andType:NSStringFromClass([selectedModel class])];
    // Do any additional setup after loading the view from its nib.
}

- (void) attemptEdit
{
    if ([selectedModel isKindOfClass:[Workshop class]]) {
        EditWorkshopViewController *tipController = [[EditWorkshopViewController alloc] initWithNibName:nil bundle:nil];
        
        [[self navigationController]
         pushViewController:tipController
         animated:NO];
    }
}

- (void) completeLoadView
{
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    
    [titleLabel setText:selectedModel.title];
    [subtitleLabel setText:selectedModel.subtitle.uppercaseString];
    [titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:17]];
    [subtitleLabel setFont:[LookAndFeel defaultFontLightWithSize:14]];
    [titleLabel setTextColor:[LookAndFeel blueColor]];
    [subtitleLabel setTextColor:[LookAndFeel orangeColor]];
    
    [detailsLabel setText:[selectedModel details]];
    [detailsLabel setTextAlignment:NSTextAlignmentJustified];
    [detailsLabel setFont:[LookAndFeel defaultFontLightWithSize:18]];
    [detailsLabel setTextColor:[LookAndFeel blueColor]];
    
    NSString *updatedAtString = [timeIntervalFormatter stringForTimeInterval:[selectedModel.updatedAt timeIntervalSinceNow]];
    
    [createdBy setText:[selectedModel createdBy]];
    [createdBy setFont:[LookAndFeel defaultFontBoldWithSize:14]];
    [createdBy setTextColor:[LookAndFeel blueColor]];

    [updatedAt setText:[NSLocalizedString(@"updated_at", nil) stringByAppendingString:updatedAtString]];
    [updatedAt setFont:[LookAndFeel defaultFontLightWithSize:11]];
    [updatedAt setTextColor:[LookAndFeel orangeColor]];
    
    [communityTitleLabel setText:NSLocalizedString(@"community_title_label", nil).uppercaseString];
    [communityTitleLabel setFont:[LookAndFeel defaultFontBookWithSize:12]];
    [communityTitleLabel setTextColor:[LookAndFeel orangeColor]];
    [communityTitleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [likesLabel setTextColor:[LookAndFeel orangeColor]];
    [likesLabel setFont:[LookAndFeel defaultFontBoldWithSize:18]];
    [likesLabel setText:selectedModel.likes];
    [dislikesLabel setTextColor:[LookAndFeel blueColor]];
    [dislikesLabel setFont:[LookAndFeel defaultFontBoldWithSize:18]];
    [dislikesLabel setText:selectedModel.dislikes];
    
    [extraAnnotationLabel setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [extraAnnotationLabel setTextColor:[LookAndFeel orangeColor]];
    [extraAnnotationLabel setText:selectedModel.extraAnnotation];

    if ([selectedModel isKindOfClass:[Workshop class]]) {
        Workshop *workshop = (Workshop*) selectedModel;
        
        if ([workshop.twitter length] == 0 && [workshop.webPage length] == 0 && [workshop.phone intValue] == 0 && [workshop.cellPhone intValue] == 0) {
            [contactView setHidden:YES];
        } else {
            [contactTitleLabel setText:NSLocalizedString(@"contact_title_label", nil).uppercaseString];
            [contactTitleLabel setFont:[LookAndFeel defaultFontBookWithSize:12]];
            [contactTitleLabel setTextColor:[LookAndFeel orangeColor]];
            [contactTitleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [twitterAccountLabel setTextColor:[LookAndFeel orangeColor]];
            [twitterAccountLabel setFont:[LookAndFeel defaultFontBoldWithSize:18]];
            
            if ([workshop.twitter length] == 0) {
                [twitterAccountLabel setText:@"---"];
            } else {
                [twitterAccountLabel setText:workshop.twitter];
            }
            
            [websiteLabel setTextColor:[LookAndFeel orangeColor]];
            [websiteLabel setFont:[LookAndFeel defaultFontBoldWithSize:18]];
            
            if ([workshop.webPage length] == 0) {
                [websiteLabel setText:@"---"];
            } else {
                [websiteLabel setText:workshop.webPage];
            }
            
            [cellphoneLabel setTextColor:[LookAndFeel blueColor]];
            [cellphoneLabel setFont:[LookAndFeel defaultFontBoldWithSize:18]];
            
            if ([workshop.cellPhone intValue] == 0) {
                [cellphoneLabel setText:@"---"];
            } else {
                [cellphoneLabel setText:[NSString stringWithFormat:@"%d", [workshop.cellPhone intValue]]];
            }
            
            [phoneLabel setTextColor:[LookAndFeel orangeColor]];
            [phoneLabel setFont:[LookAndFeel defaultFontBoldWithSize:18]];
            
            if ([workshop.phone intValue] == 0) {
                [phoneLabel setText:@"---"];
            } else {
                [phoneLabel setText:[NSString stringWithFormat:@"%d", [workshop.phone intValue]]];
            }
            
            [self stylizeViewContainerBlock:contactView];
            
        }
        
    } else {
        [contactView setHidden:YES];
    }
    
    if ([selectedModel userPicURL] != nil) {
        [UIView animateWithDuration:1.5 delay:1 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut) animations:^{
            [contributorPic setAlpha:0.5];
        } completion:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[selectedModel userPicURL]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        [contributorPic setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"profile_placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [contributorPic.layer removeAllAnimations];
            [contributorPic setAlpha:1];
            [contributorPic setImage:image];
            [contributorPic.layer setCornerRadius:18];
            contributorPic.layer.masksToBounds = YES;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [contributorPic.layer removeAllAnimations];
        }];
    }
    
    //adjust the label the the new height.
    
    [self stylizeViewContainerBlock:detailsView];
    [self stylizeViewContainerBlock:communityOpinionsView];
    [self stylizeViewContainerBlock:attributionView];
    
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

- (void) reflectFavoritedStatusForItemWithId:(NSNumber *)itemId andType:(NSString *)type
{
    NSString *url = [[[[App urlForResource:@"favorites" withSubresource:@"get_status"]
                       stringByReplacingOccurrencesOfString:@":object_id"
                       withString: [NSString stringWithFormat:@"%d", [itemId intValue]]] stringByReplacingOccurrencesOfString:@":object_type" withString:type]
                     stringByReplacingOccurrencesOfString:@":user_id" withString:[NSString stringWithFormat:@"%d", [[[User currentUser] identifier] intValue]]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            if ([[response objectForKey:@"is_favorite"] boolValue]) {
                [self.favoriteButton setImage:[UIImage imageNamed:@"favorited_icon"] forState:UIControlStateNormal];
            } else {
                [self.favoriteButton setImage:[UIImage imageNamed:@"non_favorited_icon"] forState:UIControlStateNormal];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [(UINavigationController*) [[self viewDeckController] centerController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
