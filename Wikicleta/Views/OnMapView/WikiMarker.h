//
//  WikiMarker.h
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "ModelHumanizer.h"

@interface WikiMarker : GMSMarker {
    id<ModelHumanizer> model;
}

@property (nonatomic, strong) id<ModelHumanizer> model;

@end
