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

@synthesize username, email, token, bio;

+ (id) saveUserWithToken:(NSString*)token withUsername:(NSString*)username withFullName:(NSString*)fullname withEmail:(NSString*)email andBio:(NSString*)bio
{
    User *user = [[User alloc] init];
    [user setUsername:username];
    [user setEmail:email];
    [user setToken:token];
    [user setBio:bio];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kToken];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUsername];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kEmail];

    return user;
}

+ (void) saveUserFromDictionary:(NSDictionary*)dictionary
{
    [User saveUserWithToken:[dictionary objectForKey:@"auth_token"]
               withUsername:[dictionary objectForKey:kUsername]
               withFullName:@""
                  withEmail:[dictionary objectForKey:kEmail]
                     andBio:@""];
}

+ (BOOL) userLoggedIn
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kToken] length] > 0;
}


@end
