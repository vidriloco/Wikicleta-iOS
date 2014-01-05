//
//  ProfileViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz on 1/1/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize usernameLabel, userPictureImage, userBioLabel, activityButton, favoriteButton, leftborderView, leftButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadUserInfo];
    [leftborderView setBackgroundColor:[LookAndFeel orangeColor]];
    [leftButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchDragOutside];
    [leftButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchUpInside];
    
    [activityButton stylizeViewWithString:@"profile_your_activity"];
    [favoriteButton stylizeViewWithString:@"profile_your_favorites"];

    NSString *url = [App urlForResource:@"profiles" withSubresource:@"get" andReplacementSymbol:@":id" withReplacementValue:[NSString stringWithFormat:@"%d", [[User currentUser].identifier intValue]]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            [User buildOrUpdateUserFromDictionary:[response objectForKey:@"user"]];
            [self loadPictureImage];
            [self loadUserInfo];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self loadPictureImage];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) loadUserInfo
{
    [usernameLabel setText:[User currentUser].username];
    [userBioLabel setText:[User currentUser].bio];
    [LookAndFeel decorateUILabelAsMainViewTitle:usernameLabel withLocalizedString:nil];
    [LookAndFeel decorateUILabelAsMainViewSubtitle:userBioLabel withLocalizedString:nil];
    [usernameLabel setFont:[LookAndFeel defaultFontBoldWithSize:25]];
    [userBioLabel setFont:[LookAndFeel defaultFontLightWithSize:14]];

}

- (void) loadPictureImage
{
    NSURL *picURL = [NSURL URLWithString:[User currentUser].picURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:picURL];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [userPictureImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"profile_placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [userPictureImage.layer removeAllAnimations];
        [userPictureImage setAlpha:1];
        [userPictureImage setImage:image];
        [userPictureImage.layer setCornerRadius:45];
        userPictureImage.layer.masksToBounds = YES;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self.navigationController viewDeckController] setDelegate:self];
    [[self.navigationController viewDeckController] setRightController:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *  Sets a Left Dock UIViewController if not set, and then opens the leftview
 */
- (void) openLeftDock {
    
    if ([self.viewDeckController leftController] == nil) {
        [self.viewDeckController setLeftController:[[MainMenuViewController alloc] initWithNibName:nil bundle:nil]];
    }
    [self.viewDeckController openLeftViewAnimated:YES];
}



@end
