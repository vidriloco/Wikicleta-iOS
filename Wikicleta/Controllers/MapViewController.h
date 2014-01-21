//
//  MapViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "App.h"
#import <QuartzCore/QuartzCore.h>
#import "LayersChooserViewController.h"
#import "IIViewDeckController.h"
#import "MainMenuViewController.h"
#import "SBJson.h"
#import "LayersDelegate.h"
#import "GlobalSettings.h"
#import "MarkerInfoUIView.h"
#import "MarkerDetailsViewController.h"
#import "ModelHumanizer.h"
#import <FormatterKit/TTTLocationFormatter.h>
#import "Parking.h"
#import "Tip.h"
#import "Workshop.h"
#import "Cyclestation.h"
#import "CyclestationUIView.h"
#import "Route.h"
#import "RouteUIView.h"

#import "CyclingGroupView.h"
#import "EditParkingViewController.h"
#import "EditTipViewController.h"
#import "EditWorkshopViewController.h"
#import "EditWorkshopInfoContactViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "CyclingGroupViewController.h"
#import "OverlayMapMessageView.h"
#import "CyclePath.h"
#import "TripView.h"
#import "TripPoiView.h"
#import "LightPOI.h"
#import "FavoritesManagerDelegate.h"
#import "LocationManagerDelegate.h"
#import "LocationManager.h"

#define viewportParams  @"viewport[sw]=%@&viewport[ne]=%@"
#define minZoom 2
#define mediumZoom 14
#define poiDetailedZoom 17
#define marginUnit 20

typedef enum {Share, Explore, Detail, DetailFixed, EditShare} MapMode;
typedef enum {Zoom, UnZoom} MapZoom;
@class MapViewCompanionManager;
@class TripsManager;
@class POISManager;
@class FavoritesManager;
@class LocationManager;

@interface MapViewController : UIViewController<GMSMapViewDelegate, LayersDelegate, UIGestureRecognizerDelegate, IIViewDeckControllerDelegate, UIAlertViewDelegate, FavoritesManagerDelegate, CLLocationManagerDelegate, LocationManagerDelegate> {
    NSString *activeLayer;
    UIButton *rightButton;
    UIButton *leftButton;
    UIButton *saveButton;
    UIButton *returnButton;
    UIButton *shareButton;
    UIButton *locationButton;
    
    UIImageView * sharePin;
    UIImageView * editSharePin;
    
    GMSMapView *mapView;
    GMSPolyline *selectedRoutePath;
    id detailsView;
    BOOL requestOngoing;
        
    OverlayMapMessageView *mapMessageView;
    id <ModelHumanizer> currentlySelectedModel;

    NSArray *itemsOnMap;
}

@property (nonatomic, strong) NSString *activeLayer;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UIImageView * editSharePin;

@property (nonatomic, strong) UIImageView * sharePin;

@property (nonatomic, strong) NSArray * itemsOnMap;

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSPolyline *selectedRoutePath;

@property (nonatomic, strong) OverlayMapMessageView *mapMessageView;

@property (nonatomic) id detailsView;
@property (nonatomic) id secondaryView;
@property (nonatomic) BOOL requestOngoing;
@property (nonatomic) id <ModelHumanizer> currentlySelectedModel;

- (MapMode) currentMapMode;
- (void) hideViewForMarker;
- (MapViewCompanionManager*) mapManager;
- (POISManager*) poisManager;
- (FavoritesManager*) favoritesManager;

- (void) toggleShareControls;
- (void) transitionMapToMode:(MapMode)mode;
- (TripsManager*) tripsManager;
- (void) displayMapOnPOILocation:(CLLocationCoordinate2D)coordinate;
- (void) centerOnLightPOI:(LightPOI*)lightPOI;
- (void) showMyLocationOnMap;

@end
