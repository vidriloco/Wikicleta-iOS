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
#import "DRNRealTimeBlurView.h"
#import "IIViewDeckController.h"
#import "MainMenuViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "MarkerDetailsView.h"
#import "Parking.h"
#import "MarkerDetailsExtendedViewController.h"
#import "LayersDelegate.h"
#import "MapSettingsViewController.h"

@interface MapViewController : UIViewController<GMSMapViewDelegate, ASIHTTPRequestDelegate, LayersDelegate>

@end
