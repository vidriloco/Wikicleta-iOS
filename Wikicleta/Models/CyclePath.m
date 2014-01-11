//
//  CyclePath.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/7/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "CyclePath.h"

@implementation CyclePath

@synthesize originLatitude, originLongitude, remoteId, name, details, path, oneWay, userId, username, userPicURL, coordinate, marker, storedPath, lengthInKms, polyline;

ignore_fields_do(
    ignore_field(path)
    ignore_field(marker)
    ignore_field(coordinate)
    ignore_field(polyline)
)

validation_do(
    validate_uniqueness_of(remoteId)
)

static NSMutableDictionary *cyclePaths;

+ (NSDictionary*) stored
{
    if (cyclePaths == NULL || [cyclePaths count] == 0) {
        cyclePaths = [NSMutableDictionary dictionary];
        for (CyclePath *path in [[CyclePath lazyFetcher] fetchRecords]) {
            [cyclePaths setObject:path forKey:path.remoteId];
        }
    }
    
    return cyclePaths;
}

+ (void) storeFetched:(NSArray*)pathList
{
    cyclePaths = [NSMutableDictionary dictionary];
    for (NSDictionary *cyclePath in pathList) {
        CyclePath *path  = [[CyclePath alloc] initWithDictionary:cyclePath];
        [cyclePaths setObject:path forKey: path.remoteId];
        
        NSArray* existentPaths = [[CyclePath lazyFetcher] whereField:@"remoteId" equalToValue:path.remoteId].fetchRecords;
        if ([existentPaths count] > 0) {
            [[existentPaths objectAtIndex:0] dropRecord];
        }
        
        [path beforeSave];
        [path save];
    }
}

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [CyclePath newRecord];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.details = [dictionary objectForKey:@"details"];
        
        if ([[dictionary objectForKey:@"one_way"] boolValue]) {
            self.oneWay = [NSNumber numberWithInt:1];
        } else {
            self.oneWay = [NSNumber numberWithInt:0];
        }
        
        self.remoteId = [NSNumber numberWithDouble:[[dictionary objectForKey:@"id"] integerValue]];
        self.lengthInKms = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"kilometers"] floatValue]];
        self.originLongitude = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"origin_lon"] floatValue]];
        self.originLatitude = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"origin_lat"] floatValue]];
        
        self.updatedAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_updated_at"]];
        self.createdAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_created_at"]];
        
        self.userId = [NSNumber numberWithInt:[[dictionary objectForKey:@"owner"] objectForKey:@"id"]];
        self.userPicURL = [[dictionary objectForKey:@"owner"] objectForKey:@"pic"];
        self.username = [[dictionary objectForKey:@"owner"] objectForKey:@"username"];
        self.path = [dictionary objectForKey:@"path_vector"];
        
        if (cyclePaths == NULL) {
            cyclePaths = [NSMutableDictionary dictionary];
        }
        
        [cyclePaths setObject:self forKey:self.remoteId];
        
    }
    return self;
}

- (void) loadPathFromStore
{
    self.path = [NSKeyedUnarchiver unarchiveObjectWithData:storedPath];
}

- (void) loadMarker
{
    self.coordinate = CLLocationCoordinate2DMake([originLatitude floatValue], [originLongitude floatValue]);
    marker = [WikiMarker markerWithPosition:self.coordinate];
    marker.icon = [self markerIcon];
    marker.model = self;
}

- (UIImage*) markerIcon
{
    return [UIImage imageNamed:@"cycle_path_marker.png"];
}

- (NSString*) extraAnnotation
{
    return @"";
}

- (NSString*) title
{
    return name;
}

- (NSString*) subtitle
{
    return [[NSString stringWithFormat:@"%.2f ", [self.lengthInKms floatValue]] stringByAppendingString:NSLocalizedString(@"km_s", nil)];
}

- (UIImage*) bigIcon
{
    return [UIImage imageNamed:@"cycle_path_icon.png"];
}

- (NSString*) createdBy
{
    return [NSLocalizedString(@"created_by", nil) stringByAppendingString:[self username]];
}

- (void) beforeSave
{
    self.storedPath = [NSKeyedArchiver archivedDataWithRootObject:path];
}

- (BOOL) isOneWay
{
    return [oneWay intValue] == 1;
}

@end
