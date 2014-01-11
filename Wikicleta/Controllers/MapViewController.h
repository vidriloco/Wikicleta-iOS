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

#import "EditParkingViewController.h"
#import "EditTipViewController.h"
#import "EditWorkshopViewController.h"
#import "EditWorkshopInfoContactViewController.h"

#import "OverlayMapMessageView.h"
#import "CyclePath.h"

#define poiDetailedZoom 17
#define viewportParams  @"viewport[sw]=%@&viewport[ne]=%@"
#define minZoom 2
#define marginUnit 20

typedef enum {Share, Explore, Detail, DetailFixed} MapMode;

@class MapViewCompanionManager;

@interface MapViewController : UIViewController<GMSMapViewDelegate, LayersDelegate, UIGestureRecognizerDelegate, IIViewDeckControllerDelegate, UIAlertViewDelegate> {
    NSString *activeLayer;
    UIButton *rightButton;
    UIButton *leftButton;
    UIButton *saveButton;
    UIButton *returnButton;
    UIButton *shareButton;
    UIImageView * sharePin;
    GMSMapView *mapView;
    GMSPolyline *selectedRoutePath;
    id detailsView;
    BOOL requestOngoing;
    
    OverlayMapMessageView *mapMessageView;
    
    NSArray *itemsOnMap;
}

@property (nonatomic, strong) NSString *activeLayer;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIImageView * sharePin;

@property (nonatomic, strong) NSArray * itemsOnMap;

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSPolyline *selectedRoutePath;

@property (nonatomic, strong) OverlayMapMessageView *mapMessageView;

@property (nonatomic) id detailsView;
@property (nonatomic) BOOL requestOngoing;

@end
