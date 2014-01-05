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

@synthesize usernameLabel, userPictureImage, userBioLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [usernameLabel setText:[User currentUser].username];
    [userBioLabel setText:[User currentUser].bio];
    
    NSString *url = [App urlForResource:@"profiles" withSubresource:@"get" andReplacementSymbol:@":id" withReplacementValue:[NSString stringWithFormat:@"%d", [[User currentUser].identifier intValue]]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            [User buildOrUpdateUserFromDictionary:[response objectForKey:@"user"]];
            [self loadPictureImage];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self loadPictureImage];
    }];
    
    // Do any additional setup after loading the view from its nib.
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

@end
