//
//  BaseModel.h
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "ActiveRecord.h"
#import "WikiMarker.h"
#import "App.h"

@interface BaseModel : NSObject {
    WikiMarker* marker;
    NSDictionary *categories;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, strong) NSString *remoteId;
@property (nonatomic, strong) WikiMarker* marker;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSNumber *kind;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


+ (void) buildFrom:(NSArray*)array;
- (NSString*) localizedKindString;
- (NSString*) kindString;
- (NSObject*) identifier;
- (void) loadDateFormatter;

@end
