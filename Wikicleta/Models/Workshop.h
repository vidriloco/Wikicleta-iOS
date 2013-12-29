//
//  Workshop.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "ModelHumanizer.h"

@interface Workshop : BaseModel <ModelHumanizer>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, assign) BOOL isStore;
@property (nonatomic, strong) NSNumber *phone;
@property (nonatomic, strong) NSNumber *cellPhone;
@property (nonatomic, strong) NSString *webPage;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *horary;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;


@property (nonatomic, strong) NSNumber *likesCount;
@property (nonatomic, strong) NSNumber *dislikesCount;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userPicURL;

- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)remoteId_;
+ (NSDictionary*) workshopsLoaded;

@end
