//
//  TripPoi.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/12/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "TripPoi.h"

@implementation TripPoi

static NSDictionary *categories;

@synthesize name, details, category, coordinate, marker, markerImage, remoteId, latitude, longitude, iconName;

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        if (categories == NULL) {
            categories = @{[NSNumber numberWithInt:1]: @"service_station",
                           [NSNumber numberWithInt:2]: @"ambulance",
                           [NSNumber numberWithInt:3]: @"paramedic",
                           [NSNumber numberWithInt:4]: @"bike_lending",
                           [NSNumber numberWithInt:5]: @"direction_mark",
                           [NSNumber numberWithInt:6]: @"km_mark",
                           [NSNumber numberWithInt:7]: @"transport_connection",
                           [NSNumber numberWithInt:8]: @"sightseeing",
                           [NSNumber numberWithInt:9]: @"start_flag",
                           [NSNumber numberWithInt:10]: @"finish_flag",
                           [NSNumber numberWithInt:11]: @"grouped_services",
                           [NSNumber numberWithInt:12]: @"cycling_learning",
                           [NSNumber numberWithInt:13]: @"free_grouped_services"};
        }

        self.remoteId = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
        self.details = [dictionary objectForKey:@"details"];
        self.category = [dictionary objectForKey:@"category"];
        
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        
        self.iconName = [dictionary objectForKey:@"icon_name"];
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.icon = [self markerIcon];
        marker.model = self;
        
    }
    return self;
}

- (NSString*) title
{
    return NSLocalizedString([categories objectForKey:category], nil);
}

- (NSString*) subtitle
{
    return name;
}

- (NSString*) extraAnnotation
{
    if (details == (id)[NSNull null]) {
        return nil;
    }
    details = [details stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    details = [details stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    details = [details stringByReplacingOccurrencesOfString:@"<li>" withString:@"-"];
    details = [details stringByReplacingOccurrencesOfString:@"</li>" withString:@"\n"];
    details = [details stringByReplacingOccurrencesOfString:@"<ul>" withString:@"\n\n"];
    details = [details stringByReplacingOccurrencesOfString:@"</ul>" withString:@""];
    
    return details;
}

- (UIImage*) markerIcon
{
    if ([category intValue] == 7) {
        return [UIImage imageNamed:iconName];
    } else {
        return [UIImage imageNamed:[[categories objectForKey:category] stringByAppendingString:@"_marker.png"]];
    }
}


@end
