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
#define kToken                @"token"
#define kEmail                @"email"

@interface User : NSObject

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * bio;
@property (nonatomic, strong) NSString * token;


+ (id) saveUserWithToken:(NSString*)token withUsername:(NSString*)username withFullName:(NSString*)fullname withEmail:(NSString*)email andBio:(NSString*)bio;
+ (void) saveUserFromDictionary:(NSDictionary*)dictionary;
+ (BOOL) userLoggedIn;
@end
