//
//  SocialAccountConnector.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 2/28/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "SocialAccountConnector.h"

@interface SocialAccountConnector() {
    NSArray *twitterAccounts;
    TWAPIManager *twitterAPIManager;
    NSArray *fbAccounts;
    NSString *currentAttemptWithAccountType;
}

@end

@implementation SocialAccountConnector

- (id) initWithConnectorDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        twitterAPIManager = [[TWAPIManager alloc] init];
    }
    return self;
}

- (void) connectWithTwitter
{
    currentAttemptWithAccountType = ACAccountTypeIdentifierTwitter;
    [self.delegate onAuthenticationStarted];
    
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:currentAttemptWithAccountType];
    [store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            twitterAccounts = [store accountsWithAccountType:twitterType];
            
            // If there are no accounts, we need to pop up an alert
            if(twitterAccounts != nil && [twitterAccounts count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"twitter_accounts_not_found", nil)
                                                                message:NSLocalizedString(@"twitter_accounts_not_found_message", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"close", nil)
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                [self.delegate onAccountSelectionPhaseWithAccounts:twitterAccounts];
            }
        }
        
        [self.delegate onAuthenticationFinished];
    }];

}

- (void) connectWithFacebook
{
    currentAttemptWithAccountType = ACAccountTypeIdentifierFacebook;
    [self.delegate onAuthenticationStarted];
    
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *fbType = [store accountTypeWithAccountTypeIdentifier:currentAttemptWithAccountType];
    [store requestAccessToAccountsWithType:fbType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            fbAccounts = [store accountsWithAccountType:fbType];
            
            // If there are no accounts, we need to pop up an alert
            if(fbAccounts != nil && [fbAccounts count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"facebook_accounts_not_found", nil)
                                                                message:NSLocalizedString(@"facebook_accounts_not_found_message", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"close", nil)
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                [self.delegate onAccountSelectionPhaseWithAccounts:fbAccounts];
            }
        }
        
        [self.delegate onAuthenticationFinished];
    }];
}

- (void) attemptFetchingUserAuthenticationDataForAccountAtIndex:(NSInteger)number
{
    if (currentAttemptWithAccountType == ACAccountTypeIdentifierTwitter) {
        [twitterAPIManager performReverseAuthForAccount:[twitterAccounts objectAtIndex:number] withHandler:^(NSData *responseData, NSError *error) {
            if (responseData) {
                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                
                NSString *oauthToken = [[[parts objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
                NSString *oauthTokenSecret = [[[parts objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
                NSString *userId = [[[parts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1];
                NSString *screenName = [[[parts objectAtIndex:3] componentsSeparatedByString:@"="] objectAtIndex:1];
                
                [self.delegate onAuthenticationFinishedWith:@{@"provider" : @"twitter",
                                                              @"token" : oauthToken,
                                                              @"secret" : oauthTokenSecret,
                                                              @"user_id" : userId,
                                                              @"screen_name" : screenName}];
                /*
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                 requestMethod:SLRequestMethodGET
                 URL:[NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"]
                 parameters:@{screenName: @"screen_name"}];
                 
                 [request setAccount:[twitterAccounts objectAtIndex:number]];
                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                 if (responseData) {
                 
                 
                 NSDictionary *user =
                 
                 [NSJSONSerialization JSONObjectWithData:responseData
                 
                 options:NSJSONReadingAllowFragments
                 
                 error:NULL];
                 
                 NSLog([user description]);
                 
                 NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
                 NSLog(profileImageUrl);
                 }
                 }];
                 */
            }
            else {
            }
        }];
    }
    
}

@end
