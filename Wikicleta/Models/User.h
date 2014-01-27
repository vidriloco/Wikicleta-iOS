//
//  User.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/2/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SBJson.h"

#define kName                 @"name"
#define kUsername             @"username"
#define kToken                @"auth_token"
#define kBio                  @"bio"
#define kEmail                @"email"
#define kIdentifier           @"identifier"
#define kUser                 @"user"
#define kUserPic              @"user_pic"
#define kSpeed                @"speed"
#define kDistance             @"distance"

@interface User : NSObject

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * bio;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSString * picURL;
@property (nonatomic, strong) NSDecimalNumber * speed;
@property (nonatomic, strong) NSDecimalNumber * distance;

+ (void) save;
+ (User*) buildOrUpdateUserFromDictionary:(NSDictionary*)dictionary;

+ (BOOL) userLoggedIn;
+ (User*) currentUser;
- (NSDictionary*) dictionary;
+ (NSString*) userAuthToken;
+ (BOOL) isOwnerOf:(id) object;
- (NSString*) stringifiedId;

@end
