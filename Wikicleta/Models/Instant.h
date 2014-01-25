//
//  Instant.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/20/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveRecord.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NSObject+ModelBase.h"
#import "App.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"
#import "ModelHumanizer.h"
#import "WikiMarker.h"

typedef void (^SimpleAnonymousBlock)(void);

@interface Instant : ActiveRecord<ModelHumanizer> {
}

@property (nonatomic, strong) NSDecimalNumber *latitude;
@property (nonatomic, strong) NSDecimalNumber *longitude;
@property (nonatomic, strong) NSDecimalNumber *distance;
@property (nonatomic, strong) NSDecimalNumber *timing;
@property (nonatomic, strong) NSDecimalNumber *speed;
@property (nonatomic, strong) WikiMarker* marker;
@property (nonatomic) CLLocationCoordinate2D coordinate;

+ (float) accumulatedSpeed;
+ (float) accumulatedDistance;
+ (void)  uploadStalled:(SimpleAnonymousBlock)block;
+ (void) buildFrom:(NSArray *)array;
+ (NSArray*) remoteInstants;

- (id) initWithInstant:(Instant*)instant withLocation:(CLLocation*)location;
- (id) initWithDictionary:(NSDictionary *)dictionary;

- (BOOL) attemptSave;
- (NSDictionary*) attributes;

@end
