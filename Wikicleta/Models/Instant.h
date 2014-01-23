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

@interface Instant : ActiveRecord {
}

@property (nonatomic, strong) NSDecimalNumber *latitude;
@property (nonatomic, strong) NSDecimalNumber *longitude;
@property (nonatomic, strong) NSDecimalNumber *distance;
@property (nonatomic, strong) NSDecimalNumber *timing;
@property (nonatomic, strong) NSDecimalNumber *speed;

+ (float) accumulatedSpeed;
+ (float) accumulatedDistance;
+ (void)  uploadStalled;

- (id) initWithInstant:(Instant*)instant withLocation:(CLLocation*)location;
- (BOOL) attemptSave;
- (NSDictionary*) attributes;

@end
