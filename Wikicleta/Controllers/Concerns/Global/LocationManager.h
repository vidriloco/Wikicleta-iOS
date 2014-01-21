//
//  LocationManager.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 1/19/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManagerDelegate.h"
#import "MapViewController.h"
#import "MBProgressHUD.h"
#import "Instant.h"

@interface LocationManager : NSObject<CLLocationManagerDelegate> {
    __weak id<LocationManagerDelegate> delegate;
    CLLocationManager *locationManager;
    CLLocation* location;
    BOOL active;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) id<LocationManagerDelegate> delegate;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic) BOOL active;

+ (LocationManager*) sharedInstance;
- (void) setLocationDelegate:(id<LocationManagerDelegate>)locationDelegate;
- (void) activateUpdating;
- (void) deactivateUpdating;

- (void) displayDialog;
- (void) executeTaskWhenLocationUpdated;
@end
