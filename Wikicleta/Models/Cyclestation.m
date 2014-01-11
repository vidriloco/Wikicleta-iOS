//
//  Cyclestation.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "Cyclestation.h"

@interface Cyclestation () {
    
}

- (int) stationCapacity;

@end

@implementation Cyclestation

@synthesize name, latitude, longitude, agency, availableBikes, availableSlots, updatedAt, coordinate, marker;

static NSMutableDictionary *cyclestationsLoaded;

+ (NSDictionary*) cyclestationsLoaded
{
    return cyclestationsLoaded;
}

+ (void) buildFrom:(NSArray*)array
{
    cyclestationsLoaded = [NSMutableDictionary dictionary];
    for (NSDictionary* cyclestationData in array) {
        NSString *remoteId = [NSString stringWithFormat:@"%f-%f", [[cyclestationData objectForKey:@"lat"] floatValue], [[cyclestationData objectForKey:@"lon"] floatValue]];
        if ([cyclestationData objectForKey:remoteId] == NULL) {
            Cyclestation *cyclestation = [[Cyclestation alloc] initWithDictionary:cyclestationData withId:remoteId];
            [cyclestationsLoaded setObject:cyclestation forKey:remoteId];
        }
    }
}

- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSString*)identifier
{
    if (self = [super init]) {
        self.remoteId = identifier;
        
        self.name = [dictionary objectForKey:@"name"];
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        self.agency = [dictionary objectForKey:@"agency"];
        self.availableBikes = [NSNumber numberWithInt:[[dictionary objectForKey:@"bikes_available"] integerValue]];
        self.availableSlots = [NSNumber numberWithInt:[[dictionary objectForKey:@"free_slots"] integerValue]];
        
        self.updatedAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.title = self.localizedKindString;
        marker.icon = [self markerIcon];
        marker.model = self;
    }
    
    return self;
}

- (int) stationCapacity
{
    return [availableSlots intValue]+[availableBikes intValue];
}

- (NSString*) title
{
    return agency;
}

- (NSString*) subtitle
{
    return name;
}

- (NSDate*) updatedAt
{
    return updatedAt;
}

- (UIImage*) markerIcon
{
    if ([availableSlots intValue] == 0 && [availableBikes intValue] == 0) {
        return [UIImage imageNamed:@"bike_sharing_red_marker.png"];
    } else if (([availableSlots intValue]*100)/[self stationCapacity] < 30 || ([availableBikes intValue]*100)/[self stationCapacity] < 30) {
        return [UIImage imageNamed:@"bike_sharing_yellow_marker.png"];
    }
    return [UIImage imageNamed:@"bike_sharing_green_marker.png"];
}

@end
