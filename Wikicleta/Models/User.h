//
//  User.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/2/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "UserEntity.h"
#import "SBJson.h"

#define kName                 @"name"
#define kUsername             @"username"
#define kPassword             @"password"
#define kPasswordConfirmation @"password_confirmation"
#define kEmail                @"email"

@interface User : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * token;

@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * passwordConfirmation;


+ (id) initWithName:(NSString*)name withEmail:(NSString*)email withPassword:(NSString*)password andPasswordConfirmation:(NSString*)confirmation;

- (BOOL) save;
- (BOOL) isValidForSave;
- (NSString*) toJSON;
- (NSString*) errorMsj;

@end
