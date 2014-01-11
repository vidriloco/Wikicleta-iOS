//
//  Route.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "Route.h"

@implementation Route

static NSMutableDictionary *routesLoaded;

@synthesize name, safetyIndex, speedIndex, comfortIndex, coordinate, createdAt, updatedAt, likesCount, dislikesCount, distanceInKms, originLatitude, originLongitude, endLatitude, endLongitude, secondCoordinate, details, complementaryMarker, marker, remoteId;

ignore_fields_do(
 ignore_field(complementaryMarker)
 ignore_field(marker)
 ignore_field(coordinate)
 ignore_field(secondCoordinate)
)

+ (NSDictionary*) routesLoaded
{
    return routesLoaded;
}

+ (void) buildFrom:(NSArray*)array
{
    routesLoaded = [NSMutableDictionary dictionary];
    for (NSDictionary* routeData in array) {
        NSNumber *remoteId = [NSNumber numberWithInt:[[routeData objectForKey:@"id"] integerValue]];
        if ([routeData objectForKey:remoteId] == NULL) {
            Route *route = [[Route alloc] initWithDictionary:routeData withId:remoteId];
            [routesLoaded setObject:route forKey:remoteId];
        }
    }
}

- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)identifier
{
    if (self = [super init]) {
        self.remoteId = identifier;
        
        self.name = [dictionary objectForKey:@"name"];
        self.details = [dictionary objectForKey:@"details"];
        self.originLatitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"origin_lat"] doubleValue]];
        self.originLongitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"origin_lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([originLatitude floatValue], [originLongitude floatValue]);
        
        self.endLatitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"end_lat"] doubleValue]];
        self.endLongitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"end_lon"] doubleValue]];
        self.secondCoordinate = CLLocationCoordinate2DMake([endLatitude floatValue], [endLongitude floatValue]);
        
        self.speedIndex = [NSNumber numberWithDouble:[[dictionary objectForKey:@"speed_index"] doubleValue]];
        self.comfortIndex = [NSNumber numberWithDouble:[[dictionary objectForKey:@"comfort_index"] doubleValue]];
        self.safetyIndex = [NSNumber numberWithDouble:[[dictionary objectForKey:@"safety_index"] doubleValue]];
        self.distanceInKms = [NSNumber numberWithDouble:[[dictionary objectForKey:@"kilometers"] doubleValue]];
        
        self.likesCount = [NSNumber numberWithInt:[[dictionary objectForKey:@"likes_count"] integerValue]];
        self.dislikesCount = [NSNumber numberWithInt:[[dictionary objectForKey:@"dislikes_count"] integerValue]];
        
        self.updatedAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
        self.createdAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_created_at"]];

        self.userId = [NSNumber numberWithInt:[[dictionary objectForKey:@"owner"] objectForKey:@"id"]];
        self.userPicURL = [[dictionary objectForKey:@"owner"] objectForKey:@"pic"];
        self.username = [[dictionary objectForKey:@"owner"] objectForKey:@"username"];
        
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.icon = [self markerIcon];
        marker.model = self;
        
        complementaryMarker = [WikiMarker markerWithPosition:self.secondCoordinate];
        complementaryMarker.icon = [self complementaryMarkerIcon];
        complementaryMarker.model = self;
    }
    
    return self;
}

- (NSString*) title
{
    return name;
}

- (NSString*) subtitle
{
    return NSLocalizedString(@"route", nil);
}

- (UIImage*) markerIcon
{
    return [UIImage imageNamed:@"start_route_marker.png"];
}

- (UIImage*) complementaryMarkerIcon
{
    return [UIImage imageNamed:@"end_route_marker.png"];
}

- (UIImage*) bigIcon
{
    return [UIImage imageNamed:@"start_route_icon.png"];
}

- (NSString*) createdBy
{
    return [NSLocalizedString(@"created_by", nil) stringByAppendingString:[self username]];
}

- (NSString*) likes
{
    return [NSString stringWithFormat:@"%d", [likesCount intValue]];
}

- (NSString*) dislikes
{
    return [NSString stringWithFormat:@"%d", [dislikesCount intValue]];
}

- (NSString*) extraAnnotation
{
    return [NSString stringWithFormat:@"%@ KM", [self distanceString]];
}

- (NSString*) distanceString
{
    NSString *distanceString = [NSString stringWithFormat:@"%f", [[self distanceInKms] floatValue]];
    return [[distanceString substringToIndex:3] hasSuffix:@"."] ? [distanceString substringToIndex:2] : [distanceString substringToIndex:3];
}

@end
