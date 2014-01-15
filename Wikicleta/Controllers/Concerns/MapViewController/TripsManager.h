//
//  TripsManager.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/14/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripPoi.h"
#import "TripPoiView.h"
#import "MapViewController.h"
#import "TripView.h"

@interface TripsManager : NSObject {
    TripPoiView* tripPoiView;
    MapViewController *controller;
}

@property (nonatomic, strong) TripPoiView* tripPoiView;
@property (nonatomic, strong) MapViewController* controller;

- (id) initWithMapViewController:(MapViewController*)mapViewController;
- (void) drawViewForTripPoi:(TripPoi*)poi;
- (void) hideCurrentTripPoiView;

- (void) toggleFixateViewForButton:(UIButton*)button;

@end
