//
//  LightPOI.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/16/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "NSObject+ModelBase.h"
#import "Tip.h"
#import "Parking.h"

@interface LightPOI : NSObject {
    NSString *title;
    NSString *kind;
    NSString *details;
    NSNumber *latitude;
    NSNumber *longitude;
    CLLocationCoordinate2D coordinate;
    NSDate *updatedAt;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *details;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id) initWithDictionary:(NSDictionary*)dictionary;
- (UIImage*) markerIcon;
- (NSString*) titleForLabel;
- (NSString*) kindForLabel;

- (NSNumber*) numberFromString:(NSString*)string;

@end
