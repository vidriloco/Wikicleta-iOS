//
//  LocationManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz on 1/19/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager() {
    Instant *lastInstant;
}

@end


@implementation LocationManager

@synthesize locationManager, delegate, location, active;

static LocationManager* manager = nil;

+ (LocationManager*) sharedInstance {
    if (manager == nil) {
        manager = [[LocationManager alloc] init];
    }
    return manager;
}

- (id) init
{
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(self.locationManager.distanceFilter < 400.0f) {
        [self adjustAccuracyThreshold];
    }
    [delegate locationUpdated:[locations objectAtIndex:0]];
    location = [locations objectAtIndex:0];
    [self executeTaskWhenLocationUpdated];
}

- (void) setLocationDelegate:(id<LocationManagerDelegate>)locationDelegate
{
    [self setDelegate:locationDelegate];
    [self adjustAccuracyThreshold];
    
    if ([locationDelegate isKindOfClass:[UIViewController class]]) {
        if (active) {
            [self displayDialog];
        } else {
            [self displayDialog];
        }
    }
}

- (void) executeTaskWhenLocationUpdated
{
    lastInstant = [[Instant alloc] initWithInstant:lastInstant withLocation:location];
    [lastInstant save];
    
    NSArray *instants = [Instant allRecords];
    if ([instants count] % 5 == 0) {
        [Instant uploadStalled:nil];
    }
}

- (void) activateUpdating
{
    [[self locationManager] startUpdatingLocation];
    active = YES;
}

- (void) deactivateUpdating
{
    [[self locationManager] stopUpdatingLocation];
    active = NO;
}

- (void) displayDialog
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[(UIViewController*) self.delegate view] animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps_tracking_icon.png"]];

    if (active) {
        hud.labelText = NSLocalizedString(@"tracking_off", nil);
        [(UIImageView*) hud.customView setAlpha:1];
    } else {
        hud.labelText = NSLocalizedString(@"tracking_on", nil);
        [(UIImageView*) hud.customView setAlpha:0.3];
    }
    
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    [hud hide:YES afterDelay:1];
}

- (void) adjustAccuracyThreshold
{
    if ([self.delegate isKindOfClass:[MapViewController class]]) {
        self.locationManager.distanceFilter = 400.0f;
    } else {
        // kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 800.0f;
    }
}

@end
