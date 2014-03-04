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

- (void) fetchFBUserData;

@end

@implementation SocialAccountConnector

- (id) initWithConnectorDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        twitterAPIManager = [[TWAPIManager alloc] init];
        _store = [[ACAccountStore alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanged) name:ACAccountStoreDidChangeNotification object:nil];
    }
    return self;
}

- (void) connectWithTwitter
{
    currentAttemptWithAccountType = ACAccountTypeIdentifierTwitter;
    [self.delegate onAuthenticationStarted];
    
    ACAccountType *twitterType = [_store accountTypeWithAccountTypeIdentifier:currentAttemptWithAccountType];
    [_store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            twitterAccounts = [_store accountsWithAccountType:twitterType];
            
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
    
    ACAccountType *fbType = [_store accountTypeWithAccountTypeIdentifier:currentAttemptWithAccountType];
    
    NSDictionary *fbOpts = @{ACFacebookAppIdKey: @"261609860582235",
                             ACFacebookPermissionsKey : @[@"email", @"publish_actions"],
                             ACFacebookAudienceKey:ACFacebookAudienceEveryone};
    

    void (^errorResponse) (void) = ^ {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"facebook_accounts_not_found", nil)
                                                        message:NSLocalizedString(@"facebook_accounts_not_found_message", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"close", nil)
                                              otherButtonTitles:nil];
        [alert show];
        [_delegate onAuthenticationFinished];
    };
    
    [_store requestAccessToAccountsWithType:fbType options:fbOpts completion:^(BOOL granted, NSError *error) {
        if (granted) {
            fbAccounts = [_store accountsWithAccountType:fbType];
            // If there are no accounts, we need to pop up an alert
            if(fbAccounts != nil && [fbAccounts count] == 0) {
                errorResponse();
            } else {
                [self fetchFBUserData];
            }
        } else {
            errorResponse();
        }
        [_delegate onAuthenticationFinished];
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
    } else if (currentAttemptWithAccountType == ACAccountTypeIdentifierFacebook) {
        [self fetchFBUserData];
    }
    
}

- (void) fetchFBUserData
{
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:nil];
    request.account = [fbAccounts lastObject];
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error) {

        if(!error){
            NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:&error];
            //NSLog(@"Dictionary contains: %@", list);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_delegate onAuthenticationFinishedWith:@{@"provider" : @"facebook",
                                                          @"token" : [request.account credential].oauthToken,
                                                          @"secret" : @"",
                                                          @"user_id" : [list objectForKey:@"id"],
                                                          @"screen_name" : [list objectForKey:@"username"],
                                                          @"email" : [list objectForKey:@"email"]}];
            });

        }
        else{
            // Check for error 2005
            // [self attemptRenewCredentials];
        }
        
    }];
}

-(void)attemptRenewCredentials{
    [_store renewCredentialsForAccount:(ACAccount *) [fbAccounts lastObject] completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
        if(!error)
        {
            switch (renewResult) {
                case ACAccountCredentialRenewResultRenewed:
                    NSLog(@"Good to go");
                    [self fetchFBUserData];
                    break;
                    
                case ACAccountCredentialRenewResultRejected:
                    
                    NSLog(@"User declined permission");
                    
                    break;
                    
                case ACAccountCredentialRenewResultFailed:
                    
                    NSLog(@"non-user-initiated cancel, you may attempt to retry");
                    
                    break;
                    
                default:
                    break;
                    
            }
        }
        
        else{
            NSLog(@"error from renew credentials%@",error);
        }
        
    }];
}

@end
