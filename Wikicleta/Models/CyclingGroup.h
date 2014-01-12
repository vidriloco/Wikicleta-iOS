//
//  CyclingGroup.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/11/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelHumanizer.h"
#import "WikiMarker.h"
#import "App.h"
#import "NSObject+ModelBase.h"

@interface CyclingGroup : NSObject <ModelHumanizer>

@property (nonatomic, strong) NSString *remoteId;
@property (nonatomic, strong) WikiMarker* marker;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSNumber *daysToEvent;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *departingTime;
@property (nonatomic, strong) NSString *meetingTime;
@property (nonatomic, strong) NSString *websiteUrl;

@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSString *facebookUrl;
@property (nonatomic, strong) NSString *twitterAccount;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userPicURL;
@property (nonatomic, strong) NSNumber *userId;

- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)identifier;
+ (NSDictionary*) cyclingGroupsLoaded;

@end
