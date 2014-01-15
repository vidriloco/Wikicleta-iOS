//
//  TripPoi.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/12/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WikiMarker.h"
#import "ModelHumanizer.h"

@interface TripPoi : NSObject<ModelHumanizer> {
    NSString *remoteId;
    WikiMarker* marker;
    CLLocationCoordinate2D coordinate;
    NSString *name;
    NSString *details;
    NSString *markerImage;
    NSNumber *category;
    NSNumber *latitude;
    NSNumber *longitude;
    NSString *iconName;
}

@property (nonatomic, strong) NSString *remoteId;
@property (nonatomic, strong) WikiMarker* marker;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *markerImage;
@property (nonatomic) NSNumber *category;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) NSString *iconName;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
