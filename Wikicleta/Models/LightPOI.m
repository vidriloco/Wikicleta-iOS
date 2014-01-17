//
//  LightPOI.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/16/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "LightPOI.h"

@implementation LightPOI

@synthesize details, kind, latitude, longitude, coordinate, updatedAt, title;

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.details = [dictionary objectForKey:@"description"];
        self.kind = [dictionary objectForKey:@"kind"];
        self.title = [dictionary objectForKey:@"title"];
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        
        self.updatedAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
    }
    
    return self;
}

- (UIImage*) markerIcon
{
    NSString *imageName;
    
    if ([kind isEqualToString:@"Tip"]) {
        imageName = [NSString stringWithFormat:@"%@_marker.png", [[Tip categories] objectForKey:title]];
    } else if ([kind isEqualToString:@"Parking"]) {
        imageName = [NSString stringWithFormat:@"%@_marker.png", [[Parking categories] objectForKey:title]];
    } else if ([kind isEqualToString:@"Route"]) {
        imageName = @"start_route_marker.png";
    } else if ([kind isEqualToString:@"Workshop"]) {
        imageName = @"workshop_marker.png";
    }
    
    return [UIImage imageNamed:imageName];
}

- (NSString*) titleForLabel
{
    if ([kind isEqualToString:@"Tip"]) {
        return NSLocalizedString(@"tips_title", nil);
    } else if ([kind isEqualToString:@"Parking"]) {
        return NSLocalizedString(@"parkings_title", nil);
    } else if ([kind isEqualToString:@"Route"]) {
        return NSLocalizedString(@"routes_title", nil);
    } else if ([kind isEqualToString:@"Workshop"]) {
        return NSLocalizedString(@"workshop_store_title", nil);
    }
    return nil;
}

- (NSString*) kindForLabel
{
    if ([kind isEqualToString:@"Tip"]) {
        return NSLocalizedString([[Tip categories] objectForKey:title], nil);
    } else if ([kind isEqualToString:@"Parking"]) {
        return NSLocalizedString([[Parking categories] objectForKey:title], nil);
    } else if ([kind isEqualToString:@"Route"] || [kind isEqualToString:@"Workshop"]) {
        return title;
    }
    return nil;
}

- (NSNumber*) numberFromString:(NSString *)string
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterRoundDown];
    return [f numberFromString:string];
}


@end
