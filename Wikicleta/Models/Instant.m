//
//  Instant.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/20/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "Instant.h"

@implementation Instant

@synthesize distance, latitude, longitude, createdAt, updatedAt, timing, speed;

+ (float) accumulatedSpeed {
    float speed;
    for (Instant *instant in [Instant allRecords]) {
        speed = [[instant speed] floatValue]+speed;
    }
    return speed/[[Instant allRecords] count];
}

+ (float) accumulatedDistance {
    float distance;
    for (Instant *instant in [Instant allRecords]) {
        distance = [[instant distance] floatValue]+distance;
    }
    return distance;
}

+ (void) uploadStalled
{
    NSArray *instants = [Instant allRecords];
    if ([instants count] >= 10) {
        
        NSMutableArray *dictionaries = [NSMutableArray array];
        for (Instant *instant in instants) {
            [dictionaries addObject:[instant attributes]];
        }
        
        NSDictionary *params = @{@"instants": dictionaries, @"extras": @{@"auth_token": [[User currentUser] token] }};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[App urlForResource:@"instants" withSubresource:@"post"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (Instant *instant in instants) {
                [instant dropRecord];
            }
            NSLog([[Instant allRecords] description]);
        } failure:nil];
    }
}

- (id) initWithInstant:(Instant*)instant withLocation:(CLLocation*)location
{
    self = [Instant newRecord];
    if (self) {

        self.latitude = [[NSDecimalNumber alloc] initWithFloat:[location coordinate].latitude];
        self.longitude = [[NSDecimalNumber alloc] initWithFloat:[location coordinate].longitude];
        
        self.createdAt = [NSDate date];
        self.updatedAt = [NSDate date];
        
        self.timing = 0;
        self.distance = 0;
        self.speed = 0;
        
        if (instant != nil) {
            CLLocationDegrees prevLatitude = (CLLocationDegrees) [[instant latitude] doubleValue];
            CLLocationDegrees prevLongitude = (CLLocationDegrees) [[instant longitude] doubleValue];
            CLLocation *previousLocation = [[CLLocation alloc] initWithLatitude:prevLatitude longitude:prevLongitude];
            // In kilometers
            float distanceToPrev = (float) [previousLocation distanceFromLocation:location]/1000;
            // In seconds
            self.timing = [[NSDecimalNumber alloc] initWithFloat:(float) [createdAt timeIntervalSinceDate:[instant createdAt]]];
            
            self.distance = [[NSDecimalNumber alloc] initWithFloat: (float) distanceToPrev];
            
            float hours = [timing doubleValue]/60/60;
            self.speed = [[NSDecimalNumber alloc] initWithFloat: (float) [self.distance floatValue]/hours];
        }

    }
    return self;
}

- (BOOL) attemptSave
{
    if ([self.speed floatValue] <= 30.0f) {
        return [self save];
    } else {
        return NO;
    }
}

- (NSDictionary*) attributes
{
    return @{@"latitude": latitude,
             @"longitude": longitude,
             @"distance": distance,
             @"elapsed_time": timing,
             @"speed": speed,
             @"created_at": [self.formatter stringFromDate:createdAt]};
}

@end
