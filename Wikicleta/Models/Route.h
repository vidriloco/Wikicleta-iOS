//
//  Route.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "ModelHumanizer.h"

@interface Route : BaseModel <ModelHumanizer>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSNumber *distanceInKms;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *originLatitude;
@property (nonatomic, strong) NSNumber *originLongitude;

@property (nonatomic, strong) NSNumber *endLatitude;
@property (nonatomic, strong) NSNumber *endLongitude;

@property CLLocationCoordinate2D secondCoordinate;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) NSNumber *likesCount;
@property (nonatomic, strong) NSNumber *dislikesCount;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userPicURL;

@property (nonatomic, strong) NSNumber *comfortIndex;
@property (nonatomic, strong) NSNumber *safetyIndex;
@property (nonatomic, strong) NSNumber *speedIndex;

@property (nonatomic, strong) WikiMarker *complementaryMarker;

- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)remoteId_;
+ (NSDictionary*) routesLoaded;
- (NSString*) distanceString;

@end
