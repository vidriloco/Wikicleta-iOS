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

@interface BaseModel : ActiveRecord {
    WikiMarker* marker;
    NSDictionary *categories;
}

@property (nonatomic, strong) WikiMarker* marker;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSNumber *kind;

+ (void) buildFrom:(NSArray*)array;
- (NSString*) localizedKindString;
- (NSString*) kindString;
- (NSString*) title;
- (NSString*) subtitle;
- (UIImage*) image;
- (int) identifier;

@end
