//
//  Trip.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/12/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelHumanizer.h"
#import "WikiMarker.h"
#import "TripPoi.h"

@interface Trip : NSObject <ModelHumanizer>

@property (nonatomic, strong) NSString *remoteId;
@property (nonatomic, strong) WikiMarker* marker;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSNumber *daysToEvent;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) TripPoi *startPoi;
@property (nonatomic, strong) TripPoi *endPoi;

@property (nonatomic, strong) NSArray *pois;

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) NSArray *polylines;

@property (nonatomic, strong) NSDate *updatedAt;

+ (NSDictionary*) tripsLoaded;
- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)identifier;
- (NSString*) imageName;
@end
