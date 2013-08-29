//
//  WikiMarker.h
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@class BaseModel;

@interface WikiMarker : GMSMarker {
    BaseModel *model;
}

@property (nonatomic, strong) BaseModel *model;

@end
