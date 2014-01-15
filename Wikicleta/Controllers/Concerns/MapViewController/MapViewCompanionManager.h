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
#import "CyclePathView.h"
#import "CyclingGroup.h"
#import "Trip.h"
#define marginUnit 20


@interface MapViewCompanionManager : NSObject

- (id) initWithMapViewController:(MapViewController*)mapViewController;

- (void) loadSharePinView;
- (void) loadMapButtons;
- (void) loadMapMessageView;

- (UIView*) generateMarkerDetailsOverlayViewForRoute:(Route*)route;
- (UIView*) generateMarkerDetailsOverlayViewForCyclestation:(Cyclestation *)cycleStation withMarker:(GMSMarker*)marker;
- (UIView*) generateMarkerDetailsOverlayViewForCyclepath:(CyclePath *)cyclePath withMarker:(GMSMarker*)marker;

- (GMSPolyline*) buildPolyline:(NSArray*) polyline withColor:(UIColor*)color withStroke:(float)stroke withCoordsInversion:(BOOL)coordsInversion;
- (GMSPolyline*) buildPolyline:(NSArray*) polyline withColor:(UIColor*)color withStroke:(float)stroke;
- (void) deselectSelectedRoutePath;

- (void) fetchLayer:(NSString *)displayLayer;
- (void) clearItemsOnMap;
//- (void) showSynchronizationView;

@end
