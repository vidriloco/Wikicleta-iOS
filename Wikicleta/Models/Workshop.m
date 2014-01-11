//
//  Workshop.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "Workshop.h"

@implementation Workshop

@synthesize latitude, longitude, userPicURL, username, name, details, likesCount, dislikesCount, isStore, marker, remoteId, coordinate;

static NSMutableDictionary *workshopsLoaded;

ignore_fields_do(
 ignore_field(isStore)
 ignore_field(marker)
 ignore_field(coordinate)
)

+ (NSDictionary*) workshopsLoaded
{
    return workshopsLoaded;
}

+ (void) buildFrom:(NSArray*)array
{
    workshopsLoaded = [NSMutableDictionary dictionary];
    for (NSDictionary* workshopData in array) {
        NSNumber *remoteId = [NSNumber numberWithInt:[[workshopData objectForKey:@"id"] integerValue]];
        if ([workshopData objectForKey:remoteId] == NULL) {
            Workshop *workshop = [[Workshop alloc] initWithDictionary:workshopData withId:remoteId];
            [workshopsLoaded setObject:workshop forKey:remoteId];
        }
    }
}


- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)identifier
{
    if (self = [super init]) {
        self.remoteId = identifier;
        
        self.name = [dictionary objectForKey:@"name"];
        self.details = [dictionary objectForKey:@"details"];
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        
        if ([dictionary objectForKey:@"cell_phone"] != [NSNull null]) {
            self.cellPhone = [NSNumber numberWithInt:[[dictionary objectForKey:@"cell_phone"] integerValue]];
        }
        
        if ([dictionary objectForKey:@"phone"] != [NSNull null]) {
            self.phone = [NSNumber numberWithInt:[[dictionary objectForKey:@"phone"] integerValue]];
        }
        
        if ([dictionary objectForKey:@"webpage"] == [NSNull null]) {
            self.webPage = @"";
        } else {
            self.webPage = [dictionary objectForKey:@"webpage"];
        }
        
        if ([dictionary objectForKey:@"twitter"] == [NSNull null]) {
            self.twitter = @"";
        } else {
            self.twitter = [dictionary objectForKey:@"twitter"];
        }
        
        if ([dictionary objectForKey:@"horary"] == [NSNull null]) {
            self.horary = @"";
        } else {
            self.horary = [dictionary objectForKey:@"horary"];
        }
        
        if ([dictionary objectForKey:@"store"] == [NSNull null]) {
            self.isStore = @"";
        } else {
            self.isStore = [[dictionary objectForKey:@"store"] boolValue];
        }

        self.likesCount = [NSNumber numberWithInt:[[dictionary objectForKey:@"likes_count"] integerValue]];
        self.dislikesCount = [NSNumber numberWithInt:[[dictionary objectForKey:@"dislikes_count"] integerValue]];
        
        self.createdAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_created_at"]];
        self.updatedAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
        
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

- (UIImage*) markerIcon
{
    return [UIImage imageNamed:@"workshop_marker.png"];
}

- (NSString*) title
{
    return name;
}

- (NSString*) subtitle
{
    return isStore ? NSLocalizedString(@"workshop_and_store_title", nil) : NSLocalizedString(@"workshop_title", nil);
}

- (NSString*) details
{
    return details;
}

- (UIImage*) bigIcon
{
    return [UIImage imageNamed:@"workshop_icon.png"];
}

- (NSString*) likes
{
    return [NSString stringWithFormat:@"%d", [likesCount intValue]];
}

- (NSString*) dislikes
{
    return [NSString stringWithFormat:@"%d", [dislikesCount intValue]];
}

- (NSString*) createdBy
{
    return [NSLocalizedString(@"created_by", nil) stringByAppendingString:[self username]];
}

- (NSString*) extraAnnotation
{
    if([self.phone intValue] != 0) {
        return [NSString stringWithFormat:@"%d", [self.phone intValue]];
    } else if ([self.cellPhone intValue] > 0) {
        return [NSString stringWithFormat:@"%d", [self.cellPhone intValue]];
    } else if ([self.twitter length] > 0) {
        return [@"@" stringByAppendingString:self.twitter];
    } else {
        return @"";
    }
}

- (NSString*) userPicURL
{
    return userPicURL;
}


@end
