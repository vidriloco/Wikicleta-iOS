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

#import "POIChooserOverlayView.h"

#define poiDetailedZoom 17
#define viewportParams  @"viewport[sw]=%@&viewport[ne]=%@"
#define minZoom 14

typedef enum {Share, Find, Select} MapMode;

@interface MapViewController : UIViewController<GMSMapViewDelegate, LayersDelegate, UIGestureRecognizerDelegate> {
    UIViewController *rightHelperController;
}

@property (nonatomic, strong) UIViewController *rightHelperController;

@end
