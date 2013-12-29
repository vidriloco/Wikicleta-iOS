//
//  Parking.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "Parking.h"

@interface Parking(){
}

- (void) setCategories;

@end

@implementation Parking

static NSMutableDictionary* parkingsLoaded;

@synthesize longitude,latitude,anyoneCanEdit,createdAt,details,hasRoof,username, likesCount, dislikesCount,updatedAt,userId,userPicURL, coordinate;

ignore_fields_do(
    ignore_field(username);
    ignore_field(userPicURL);
    ignore_field(likesCount);
    ignore_field(userId);
    ignore_field(coordinate);
    ignore_field(dislikesCount);
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
        self.dislikesCount = [NSNumber numberWithInt:[[dictionary objectForKey:@"dislikes_count"] integerValue]];

        self.anyoneCanEdit = [[dictionary objectForKey:@"others_can_edit"] boolValue];
        
        [self loadDateFormatter];
        self.createdAt = [dateFormatter dateFromString:[dictionary objectForKey:@"str_created_at"]];
        self.updatedAt = [dateFormatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
        
        self.userId = [NSNumber numberWithInt:[[dictionary objectForKey:@"owner"] objectForKey:@"id"]];
        self.userPicURL = [[dictionary objectForKey:@"owner"] objectForKey:@"pic"];
        self.username = [[dictionary objectForKey:@"owner"] objectForKey:@"username"];
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.title = self.localizedKindString;
        marker.icon = [self markerIcon];
        marker.model = self;
    }
    
    return self;
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

- (NSString*) details
{
    return details;
}

- (UIImage*) markerIcon
{
    return [UIImage imageNamed:[self.kindString stringByAppendingString:@"_marker.png"]];
}

- (UIImage*) bigIcon
{
    return [UIImage imageNamed:[self.kindString stringByAppendingString:@"_icon.png"]];
}

- (NSString*) likes
{
    return [NSString stringWithFormat:@"%d", [likesCount intValue]];
}

- (NSString*) dislikes
{
    return [NSString stringWithFormat:@"%d", [dislikesCount intValue]];
}

- (NSDate*) updatedAt
{
    return updatedAt;
}

- (NSString*) createdBy
{
    return [NSLocalizedString(@"created_by", nil) stringByAppendingString:[self username]];
}

- (NSString*) extraAnnotation
{
    return [self hasRoof] ? NSLocalizedString(@"has_roof", nil) : NSLocalizedString(@"lacks_roof", nil);
}

- (NSString*) userPicURL
{
    return userPicURL;
}

@end
