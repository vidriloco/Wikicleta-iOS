//
//  MapViewCompanionManager.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"
#import "MapViewController.h"
#import "Route.h"

#define marginUnit 20


@interface MapViewCompanionManager : NSObject

- (id) initWithMapViewController:(MapViewController*)mapViewController;

- (void) loadSharePinView;
- (void) loadMapButtons;

- (UIView*) generateMarkerDetailsOverlayViewForRoute:(Route*)route;
- (UIView*) generateMarkerDetailsOverlayViewForCyclestation:(Cyclestation *)cycleStation withMarker:(GMSMarker*)marker;

- (void) drawPolyline:(NSArray*) polyline;
- (void) clearPolyline;

- (void) fetchLayer:(NSString *)displayLayer;


@end
