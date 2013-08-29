//
//  Parking.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "Parking.h"

@interface Parking(){
    NSDateFormatter *dateFormatter;
}

- (void) setCategories;

@end

@implementation Parking

static NSMutableDictionary* parkingsLoaded;

@synthesize longitude,latitude,anyoneCanEdit,createdAt,details,hasRoof,username,remoteId,likesCount,updatedAt,userId,userPicURL, coordinate;

ignore_fields_do(
    ignore_field(username);
    ignore_field(userPicURL);
    ignore_field(likesCount);
    ignore_field(userId);
    ignore_field(coordinate);
)

+ (NSDictionary*) parkingsLoaded
{
    return parkingsLoaded;
}

+ (void) buildFrom:(NSArray*)array
{
    parkingsLoaded = [NSMutableDictionary dictionary];
    for (NSDictionary* parkingData in array) {
        NSNumber *remoteId = [NSNumber numberWithInt:[[parkingData objectForKey:@"id"] integerValue]];
        if ([parkingData objectForKey:remoteId] == NULL) {
            Parking *parking = [[Parking alloc] initWithDictionary:parkingData withId:remoteId];
            [parkingsLoaded setObject:parking forKey:remoteId];
        }
    }
}


- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)remoteId_
{
    if (self = [super init]) {
        [self setCategories];
        self.remoteId = remoteId_;
        self.details = [dictionary objectForKey:@"details"];
        self.hasRoof = [[dictionary objectForKey:@"has_roof"] boolValue];
        self.kind = [NSNumber numberWithInt:[[dictionary objectForKey:@"kind"] integerValue]];
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        self.likesCount = [NSNumber numberWithInt:[[dictionary objectForKey:@"likes_count"] integerValue]];
        self.anyoneCanEdit = [[dictionary objectForKey:@"others_can_edit"] boolValue];
        
        [self loadDateFormatter];
        self.createdAt = [dateFormatter dateFromString:[dictionary objectForKey:@"str_created_at"]];
        self.updatedAt = [dateFormatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
        
        self.userId = [NSNumber numberWithInt:[[dictionary objectForKey:@"owner"] objectForKey:@"id"]];
        self.userPicURL = [[dictionary objectForKey:@"owner"] objectForKey:@"pic"];
        self.username = [[dictionary objectForKey:@"owner"] objectForKey:@"username"];
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.title = self.localizedKindString;
        marker.icon = [self image];
        marker.model = self;
    }
    
    return self;
}

- (void) loadDateFormatter
{
    if (dateFormatter == NULL) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}

- (void) setCategories
{
    if (categories == NULL) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"government_provided" forKey:[NSNumber numberWithInt:1]];
        [dict setObject:@"urban_mobiliary" forKey:[NSNumber numberWithInt:2]];
        [dict setObject:@"venue_provided" forKey:[NSNumber numberWithInt:3]];

        categories = [NSDictionary dictionaryWithDictionary:dict];
    }
}

- (NSString*) title
{
    return NSLocalizedString(@"parkings_title", nil);
}

- (NSString*) subtitle
{
    return NSLocalizedString([self kindString], nil);
}

- (UIImage*) image
{
    return [UIImage imageNamed:[self.kindString stringByAppendingString:@"_marker.png"]];
}

- (int) identifier
{
    return self.remoteId;
}

@end
