//
//  SocialConnectorEnabledViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 2/28/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "SocialConnectorEnabledViewController.h"

@interface SocialConnectorEnabledViewController () {
    MBProgressHUD *authActivityIndicator;
    
}

@end

@implementation SocialConnectorEnabledViewController

@synthesize socialConnector;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setSocialConnector:[[SocialAccountConnector alloc] initWithConnectorDelegate:self]];
    }
    return self;
}


- (void) onAuthenticationStarted
{
    authActivityIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) onAuthenticationFinished
{
    [authActivityIndicator hide:YES];
}

- (void) onAuthenticationFinishedWith:(NSDictionary *)dictionary
{
    NSLog([dictionary objectForKey:@"token"]);
    NSLog([dictionary objectForKey:@"secret"]);

    NSLog([dictionary objectForKey:@"user_id"]);
    NSLog([dictionary objectForKey:@"screen_name"]);

}

- (void) onAccountSelectionPhaseWithAccounts:(NSArray *)accountsList
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_an_account", nil)
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    for (ACAccount *acct in accountsList) {
        [sheet addButtonWithTitle:acct.username];
    }
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:NSLocalizedString(@"cancel", nil)];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [socialConnector attemptFetchingUserAuthenticationDataForAccountAtIndex:buttonIndex];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
