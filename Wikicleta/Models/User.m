//
//  User.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/2/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "User.h"

@interface User () {
}

@end

@implementation User

static User *user;

@synthesize username, email, token, bio, identifier, picURL;

+ (void) save
{
    [[NSUserDefaults standardUserDefaults] setObject:[[User currentUser] dictionary] forKey:kUser];
}

+ (User*) buildOrUpdateUserFromDictionary:(NSDictionary*)dictionary
{
    user = [self currentUser];

    if ([dictionary objectForKey:kUsername]) {
        [user setUsername:[dictionary objectForKey:kUsername]];
    }
    
    if ([dictionary objectForKey:kEmail]) {
        [user setEmail:[dictionary objectForKey:kEmail]];
    }
    
    if ([dictionary objectForKey:kToken]) {
        [user setToken:[dictionary objectForKey:kToken]];
    }
    
    if ([dictionary objectForKey:kBio] && [dictionary objectForKey:kBio] != [NSNull null]) {
        [user setBio:[dictionary objectForKey:kBio]];
    }
    
    if ([dictionary objectForKey:kIdentifier]) {
        [user setIdentifier:[dictionary objectForKey:kIdentifier]];
    }
    
    if ([dictionary objectForKey:kUserPic] && [dictionary objectForKey:kUserPic] != [NSNull null]) {
        [user setPicURL:[dictionary objectForKey:kUserPic]];
    }

    [self save];
    return user;
}

+ (User*) currentUser
{
    if (user == NULL) {
        NSDictionary* userData = [[NSUserDefaults standardUserDefaults] objectForKey:kUser];
        user = [[User alloc] init];
        
        if (userData) {
            [self buildOrUpdateUserFromDictionary:userData];
        }
    }
    return user;
}

+ (BOOL) userLoggedIn
{
    return [[self currentUser] identifier] != NULL;
}

+ (NSString*) userAuthToken
{
    return [[User currentUser] token];
}

+ (BOOL) isOwnerOf:(id)object
{
    return [[[User currentUser] identifier] intValue] == [object intValue];
}

- (NSDictionary*) dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.username forKey:kUsername];
    [dict setObject:self.email forKey:kEmail];
    [dict setObject:self.token forKey:kToken];
    [dict setObject:self.identifier forKey:kIdentifier];
    
    if (self.bio != NULL) {
        [dict setObject:self.bio forKey:kBio];
    }
    
    if (self.picURL != NULL) {
        [dict setObject:self.picURL forKey:kUserPic];
    }
    
    return dict;
}

@end
