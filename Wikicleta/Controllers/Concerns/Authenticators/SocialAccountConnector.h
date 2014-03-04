//
//  SocialAccountConnector.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 2/28/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialAccountConnectorDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "TWAPIManager.h"

@interface SocialAccountConnector : NSObject

@property (nonatomic, assign) id<SocialAccountConnectorDelegate> delegate;

- (id) initWithConnectorDelegate:(id)delegate;

- (void) connectWithTwitter;
- (void) connectWithFacebook;
- (void) attemptFetchingUserAuthenticationDataForAccountAtIndex:(NSInteger)number;

@end
