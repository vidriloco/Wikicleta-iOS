//
//  CyclePath.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/7/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveRecord.h"
#import "ModelHumanizer.h"
#import "WikiMarker.h"
#import "App.h"
#import "NSObject+ModelBase.h"

@interface CyclePath : ActiveRecord <ModelHumanizer> {
    
}

@property (nonatomic, strong) NSNumber *remoteId;


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSDecimalNumber *lengthInKms;
@property (nonatomic, strong) NSNumber *oneWay;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSDecimalNumber *originLatitude;
@property (nonatomic, strong) NSDecimalNumber *originLongitude;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userPicURL;
@property (nonatomic, strong) NSData *storedPath;

@property (nonatomic, strong) WikiMarker* marker;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSArray *path;


+ (void) storeFetched:(NSArray*)pathList;
+ (NSDictionary*) stored;

- (id) initWithDictionary:(NSDictionary*)dictionary;

- (void) loadMarker;
- (void) loadPathFromStore;
- (void) beforeSave;
- (BOOL) isOneWay;

@end
