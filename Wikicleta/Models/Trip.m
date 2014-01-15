//
//  Trip.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/12/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "Trip.h"

@implementation Trip

@synthesize name, daysToEvent, details, coordinate, latitude, longitude, marker, picUrl, pois, segments, startPoi, endPoi, polylines;

static NSMutableDictionary* tripsLoaded;

- (id) initWithDictionary:(NSDictionary *)dictionary withId:(NSNumber *)identifier
{
    if (self = [super init]) {
        self.remoteId = [dictionary objectForKey:@"id"];
        
        self.name = [dictionary objectForKey:@"name"];
        self.details = [dictionary objectForKey:@"details"];
        if ([dictionary objectForKey:@"pic"] != [NSNull null]) {
            self.picUrl = [dictionary objectForKey:@"pic"];
        }
        
        self.daysToEvent = [dictionary objectForKey:@"calculated_days_to_event"];
        
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        
        NSMutableArray *segmentsTmp = [NSMutableArray array];
        for (NSDictionary *segment in [dictionary objectForKey:@"paths"]) {
            [segmentsTmp addObject:[segment objectForKey:@"points"]];
        }
        
        NSMutableArray *poisList = [NSMutableArray array];
        for (NSDictionary *poi in [dictionary objectForKey:@"pois"]) {
            
            TripPoi *builtPoi = [[TripPoi alloc] initWithDictionary:poi];
            
            [poisList addObject:builtPoi];
        }
        
        self.pois = poisList;
        
        self.segments = segmentsTmp;
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.icon = [self markerIcon];
        marker.model = self;

    }
    
    return self;
}

+ (void) buildFrom:(NSArray*)array
{
    tripsLoaded = [NSMutableDictionary dictionary];
    for (NSDictionary* cyclingGroupData in array) {
        NSNumber *remoteId = [NSNumber numberWithInt:[[cyclingGroupData objectForKey:@"id"] integerValue]];
        if ([cyclingGroupData objectForKey:remoteId] == NULL) {
            Trip *tripLoaded = [[Trip alloc] initWithDictionary:cyclingGroupData withId:remoteId];
            [tripsLoaded setObject:tripLoaded forKey:remoteId];
        }
    }
}

+ (NSDictionary*) tripsLoaded
{
    return tripsLoaded;
}

- (NSString*) title
{
    return name;
}

- (NSString*) imageName
{
    if ([self.name isEqualToString:@"Paseo dominical"]) {
        return @"paseo_dominical.jpg";
    } else {
        return @"cicloton.jpg";
    }
}

- (NSString*) subtitle
{
    if ([daysToEvent intValue] == 1) {
        return NSLocalizedString(@"days_to_event_tomorrow", nil);
    } else if ([daysToEvent intValue] == 0) {
        return NSLocalizedString(@"days_to_event_today", nil);
    } else if ([daysToEvent intValue] == 1000) {
        return NSLocalizedString(@"days_to_event_unknown", nil);
    } else {
        return [[NSString stringWithFormat:@"%d", [daysToEvent intValue]] stringByAppendingString:NSLocalizedString(@"days_to_event_plural", nil)];
    }
}

- (NSString*) extraAnnotation
{
    return details;
}

- (UIImage*) markerIcon
{
    return [UIImage imageNamed:@"trip_marker.png"];
}


@end
