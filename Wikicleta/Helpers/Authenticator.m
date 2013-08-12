//
//  Authenticator.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/9/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "Authenticator.h"

@interface Authenticator () {
    int state;
}

@end

@implementation Authenticator

@synthesize delegate;

- (void) authenticate
{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    if ([standard objectForKey:kWikicletaUser] != nil) {
        /*NSString* storedPassword = [SFHFKeychainUtils getPasswordForUsername:[standard objectForKey:kWikicletaUser]
                                                              andServiceName:kServiceName error:nil];*/
        NSString *storedPassword = @"";
        ASIFormDataRequest *formRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[App backendURL]]];
        [formRequest addPostValue:storedPassword forKey:@"password"];
        [formRequest addPostValue:[standard objectForKey:kWikicletaUser] forKey:@"username"];
        [formRequest setRequestMethod:@"POST"];
        [formRequest setDelegate:self];

        [formRequest startAsynchronous];
    } else {
        state = kNonInCache;
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([request responseStatusCode] == 200) {
        NSDictionary *authenticationResponse = [[request responseString] JSONValue];
        [[NSUserDefaults standardUserDefaults] setObject:[authenticationResponse objectForKey:kWikicletaPinLock] forKey:kWikicletaPinLock];
        state = kAuthenticated;
    } else {
        state = kNonAuthenticated;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    state = kNonAuthenticated;
}

@end
