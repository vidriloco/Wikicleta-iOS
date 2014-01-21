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
    return distance/[[Instant allRecords] count];
}

- (id) initWithInstant:(Instant*)instant withLocation:(CLLocation*)location
{
    self = [Instant newRecord];
    if (self) {

        self.latitude = [[NSDecimalNumber alloc] initWithFloat:[location coordinate].latitude];
        self.longitude = [[NSDecimalNumber alloc] initWithFloat:[location coordinate].longitude];
        
        CLLocationDegrees prevLatitude = (CLLocationDegrees) [[instant latitude] doubleValue];
        CLLocationDegrees prevLongitude = (CLLocationDegrees) [[instant latitude] doubleValue];
        CLLocationDistance distanceToPrev = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:prevLatitude longitude:prevLongitude]];

        self.createdAt = [NSDate date];
        self.updatedAt = [NSDate date];
        
        self.timing = 0;
        self.distance = 0;
        self.speed = 0;
        
        if (instant != nil) {
            self.timing = [[NSDecimalNumber alloc] initWithFloat:(float) [createdAt timeIntervalSince1970]-[[instant createdAt] timeIntervalSince1970]];
            self.distance = [[NSDecimalNumber alloc] initWithFloat: (float) distanceToPrev*0.001];
            
            float hours   = (([timing doubleValue] / (1000*60*60)));
            self.speed = [[NSDecimalNumber alloc] initWithFloat: (float) [self.distance floatValue]/hours];
        }

    }
    return self;
}

@end
