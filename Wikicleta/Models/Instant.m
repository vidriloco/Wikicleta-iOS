//
//  Instant.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/20/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "Instant.h"

@implementation Instant

static NSArray *remoteInstants;

@synthesize distance, latitude, longitude, createdAt, updatedAt, timing, speed, marker;

ignore_fields_do(
 ignore_field(coordinate)
 ignore_field(marker)
)

+ (float) accumulatedSpeed {
    float speed = 0.0f;
    for (Instant *instant in [Instant allRecords]) {
        speed = [[instant speed] floatValue]+speed;
    }
    return speed/[[Instant allRecords] count];
}

+ (float) accumulatedDistance {
    float distance = 0.0f;
    for (Instant *instant in [Instant allRecords]) {
        distance = [[instant distance] floatValue]+distance;
    }
    return distance;
}

+ (NSArray*) remoteInstants
{
    return remoteInstants;
}

+ (void) buildFrom:(NSArray *)array
{
    NSMutableArray *arrayOfInstants = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        Instant *instant = [[Instant alloc] initWithDictionary:dict];
        [arrayOfInstants addObject:instant];
    }
    remoteInstants = arrayOfInstants;
}

+ (void)  uploadStalled:(SimpleAnonymousBlock)block
{
    NSArray *instants = [Instant allRecords];
    
    NSMutableArray *dictionaries = [NSMutableArray array];
    for (Instant *instant in instants) {
        [dictionaries addObject:[instant attributes]];
    }
    
    NSDictionary *params = @{@"instants": dictionaries, @"extras": @{@"auth_token": [[User currentUser] token] }};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[App urlForResource:@"instants" withSubresource:@"post"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (Instant *instant in instants) {
            [instant dropRecord];
        }
        if (block != nil) {
            block();
        }
        //NSLog([[Instant allRecords] description]);
    } failure:nil];
}

- (id) initWithInstant:(Instant*)instant withLocation:(CLLocation*)location
{
    self = [Instant newRecord];
    if (self) {

        self.latitude = [[NSDecimalNumber alloc] initWithFloat:[location coordinate].latitude];
        self.longitude = [[NSDecimalNumber alloc] initWithFloat:[location coordinate].longitude];
        
        self.createdAt = [NSDate date];
        self.updatedAt = [NSDate date];
        
        self.timing = 0;
        self.distance = 0;
        self.speed = 0;
        
        if (instant != nil) {
            CLLocationDegrees prevLatitude = (CLLocationDegrees) [[instant latitude] doubleValue];
            CLLocationDegrees prevLongitude = (CLLocationDegrees) [[instant longitude] doubleValue];
            CLLocation *previousLocation = [[CLLocation alloc] initWithLatitude:prevLatitude longitude:prevLongitude];
            // In kilometers
            float distanceToPrev = (float) [previousLocation distanceFromLocation:location]/1000;
            // In seconds
            self.timing = [[NSDecimalNumber alloc] initWithFloat:(float) [createdAt timeIntervalSinceDate:[instant createdAt]]];
            
            self.distance = [[NSDecimalNumber alloc] initWithFloat: (float) distanceToPrev];
            
            float hours = [timing doubleValue]/60/60;
            self.speed = [[NSDecimalNumber alloc] initWithFloat: (float) [self.distance floatValue]/hours];
        }

    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.latitude = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"lat"] floatValue]];
        self.longitude = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"lon"] floatValue]];
        self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);

        if ([dictionary objectForKey:@"speed_at"] && [dictionary objectForKey:@"speed_at"] != [NSNull null]) {
            self.speed = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"speed_at"] floatValue]];
        }
        
        if ([dictionary objectForKey:@"distance_at"] && [dictionary objectForKey:@"distance_at"] != [NSNull null]) {
            self.distance = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"distance_at"] floatValue]];
        }
        
        if ([dictionary objectForKey:@"elapsed_time"] && [dictionary objectForKey:@"elapsed_time"] != [NSNull null]) {
            self.timing = [[NSDecimalNumber alloc] initWithFloat:[[dictionary objectForKey:@"elapsed_time"] floatValue]];
        }
        self.createdAt = [self.formatter dateFromString:[dictionary objectForKey:@"str_created_at"]];
        
        marker = [WikiMarker markerWithPosition:self.coordinate];
        marker.title = self.localizedKindString;
        marker.icon = [self markerIcon];
        marker.model = self;
    }
    return self;
}

- (BOOL) attemptSave
{
    if ([self.speed floatValue] <= 30.0f) {
        return [self save];
    } else {
        return NO;
    }
}

- (NSDictionary*) attributes
{
    return @{@"latitude": latitude,
             @"longitude": longitude,
             @"distance": distance,
             @"elapsed_time": timing,
             @"speed": speed,
             @"created_at": [self.formatter stringFromDate:createdAt]};
}

- (UIImage*) markerIcon {
    return [UIImage imageNamed:@"timing-marker.png"];
}

- (NSString*) title {
    return NSLocalizedString(@"instant_instance", nil);
}

- (NSString*) subtitle {
    return [self.formatter stringFromDate:self.createdAt];
}

@end
