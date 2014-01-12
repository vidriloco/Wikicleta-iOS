//
//  CyclingGroup.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/11/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "CyclingGroup.h"

@implementation CyclingGroup

@synthesize coordinate, latitude, longitude, remoteId, name, departingTime, createdAt, updatedAt, username, userPicURL, picUrl, facebookUrl, details, daysToEvent, meetingTime, twitterAccount, websiteUrl, marker, userId;

static NSMutableDictionary* cyclingGroupsLoaded;

+ (void) buildFrom:(NSArray*)array
{
    cyclingGroupsLoaded = [NSMutableDictionary dictionary];
    for (NSDictionary* cyclingGroupData in array) {
        NSNumber *remoteId = [NSNumber numberWithInt:[[cyclingGroupData objectForKey:@"id"] integerValue]];
        if ([cyclingGroupData objectForKey:remoteId] == NULL) {
            CyclingGroup *cyclingGroup = [[CyclingGroup alloc] initWithDictionary:cyclingGroupData withId:remoteId];
            [cyclingGroupsLoaded setObject:cyclingGroup forKey:remoteId];
        }
    }
}

+ (NSDictionary*) cyclingGroupsLoaded
{
    return cyclingGroupsLoaded;
}

- (id) initWithDictionary:(NSDictionary *)dictionary withId:(NSNumber *)identifier
{
    if (self = [super init]) {
        self.remoteId = [dictionary objectForKey:@"id"];

        self.name = [dictionary objectForKey:@"name"];
        self.details = [dictionary objectForKey:@"details"];
        if ([dictionary objectForKey:@"pic"] != [NSNull null]) {
            self.picUrl = [dictionary objectForKey:@"pic"];
        }
        self.departingTime = [dictionary objectForKey:@"departing_time"];
        self.meetingTime = [dictionary objectForKey:@"meeting_time"];
        
        if ([dictionary objectForKey:@"facebook_url"] != [NSNull null]) {
            self.facebookUrl = [dictionary objectForKey:@"facebook_url"];
        }
        
        if ([dictionary objectForKey:@"twitter_account"] != [NSNull null]) {
            self.twitterAccount = [dictionary objectForKey:@"twitter_account"];
        }
        
        if ([dictionary objectForKey:@"website_url"] != [NSNull null]) {
            self.websiteUrl = [dictionary objectForKey:@"website_url"];
        }
        
        self.daysToEvent = [dictionary objectForKey:@"calculated_days_to_event"];
        
        self.userId = [NSNumber numberWithInt:[[dictionary objectForKey:@"owner"] objectForKey:@"id"]];
        
        self.updatedAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
        
        if ([[dictionary objectForKey:@"owner"] objectForKey:@"pic"] != [NSNull null]) {
            self.userPicURL = [[dictionary objectForKey:@"owner"] objectForKey:@"pic"];
        }
        
        self.username = [[dictionary objectForKey:@"owner"] objectForKey:@"username"];
        
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.icon = [self markerIcon];
        marker.model = self;
    }
    return self;
}

- (NSString*) title
{
    return name;
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

- (UIImage*) markerIcon
{
    return [UIImage imageNamed:@"cycling_group_marker.png"];
}

- (UIImage*) bigIcon
{
    return [UIImage imageNamed:@"cycling_group_icon.png"];
}

- (NSString*) createdBy
{
    return [NSLocalizedString(@"created_by", nil) stringByAppendingString:[self username]];
}

- (NSString*) extraAnnotation
{
    return [NSLocalizedString(@"leaving_at", nil) stringByAppendingString:[self departingTime]];
}

@end
