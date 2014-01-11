//
//  Tip.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/26/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "Tip.h"

@interface Tip() {
    
}

- (void) setCategories;

@end

@implementation Tip

static NSMutableDictionary* tipsLoaded;

@synthesize latitude, longitude, details, likesCount, dislikesCount, username, userPicURL, kind, marker, categories, coordinate;

ignore_fields_do(
    ignore_field(categories)
    ignore_field(marker)
    ignore_field(coordinate)
)

+ (NSDictionary*) tipsLoaded
{
    return tipsLoaded;
}

+ (void) buildFrom:(NSArray*)array
{
    tipsLoaded = [NSMutableDictionary dictionary];
    for (NSDictionary* tipData in array) {
        NSNumber *remoteId = [NSNumber numberWithInt:[[tipData objectForKey:@"id"] integerValue]];
        if ([tipData objectForKey:remoteId] == NULL) {
            Tip *tip = [[Tip alloc] initWithDictionary:tipData withId:remoteId];
            [tipsLoaded setObject:tip forKey:remoteId];
        }
    }
}


- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)identifier
{
    if (self = [super init]) {
        [self setCategories];
        self.remoteId = identifier;
        self.details = [dictionary objectForKey:@"content"];
        self.kind = [NSNumber numberWithInt:[[dictionary objectForKey:@"category"] integerValue]];
        self.latitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lat"] doubleValue]];
        self.longitude = [NSNumber numberWithDouble:[[dictionary objectForKey:@"lon"] doubleValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
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

- (void) setCategories
{
    if (categories == NULL) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"danger" forKey:[NSNumber numberWithInt:1]];
        [dict setObject:@"alert" forKey:[NSNumber numberWithInt:2]];
        [dict setObject:@"sightseeing" forKey:[NSNumber numberWithInt:3]];
        
        categories = [NSDictionary dictionaryWithDictionary:dict];
    }
}

- (UIImage*) markerIcon
{
    return [UIImage imageNamed:[self.kindString stringByAppendingString:@"_marker.png"]];
}

- (NSString*) title
{
    return NSLocalizedString([self kindString], nil);
}

- (NSString*) subtitle
{
    return NSLocalizedString(@"tips_title", nil);
}

- (NSString*) details
{
    return details;
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

- (NSString*) createdBy
{
    return [NSLocalizedString(@"created_by", nil) stringByAppendingString:[self username]];
}

- (NSString*) extraAnnotation
{
    return @"";
}

- (NSString*) userPicURL
{
    return userPicURL;
}

- (NSString*) kindString
{
    return [categories objectForKey:kind];
}


@end
