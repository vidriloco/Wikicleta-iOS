//
//  Authenticator.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/9/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "SBJson.h"
#import "AuthenticatorDelegate.h"

#import "App.h"

#define kWikicletaUser      @"wikicletaUsername"
#define kWikicletaPinLock   @"accessPin"
#define kServiceName        @"wikicleta"

#define kNonInCache         0
#define kAuthenticated      1
#define kNonAuthenticated   2

@interface Authenticator : NSObject<ASIHTTPRequestDelegate> {
    id<AuthenticatorDelegate> delegate;
}

@property (nonatomic, strong) id<AuthenticatorDelegate> delegate;

- (void) authenticate;

@end
