//
//  MapViewCompanionManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "MapViewCompanionManager.h"

@interface MapViewCompanionManager () {
    MapViewController *controller;
}

@end


@implementation MapViewCompanionManager

- (id) initWithMapViewController:(MapViewController*)mapViewController
{
    if (self = [super init]) {
        controller = mapViewController;
    }
    return self;
}

- (void) loadSharePinView
{
    controller.sharePin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wikicleta_pin.png"]];
    [controller.sharePin setFrame:CGRectMake([App viewBounds].size.width/2-controller.sharePin.frame.size.width/2,
                                  [App viewBounds].size.height/2-controller.sharePin.frame.size.height/2,
                                  controller.sharePin.frame.size.width, controller.sharePin.frame.size.height)];
}

- (void) loadMapButtons
{
    // Left menu button
    UIImage *menuImage = [UIImage imageNamed:@"menu_button.png"];
    controller.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [App viewBounds].size.height-menuImage.size.height-marginUnit*2.5,
                                                            menuImage.size.width, menuImage.size.height)];
    [controller.leftButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [controller.view addSubview:controller.leftButton];
    [controller.leftButton addTarget:controller action:@selector(openLeftDock) forControlEvents:UIControlEventTouchDragOutside];
    [controller.leftButton addTarget:controller action:@selector(openLeftDock) forControlEvents:UIControlEventTouchUpInside];
    
    // Right layers button
    UIImage *layerImage  = [UIImage imageNamed:@"layer_button.png"];
    controller.rightButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-layerImage.size.width+5, [App viewBounds].size.height-layerImage.size.height-marginUnit*2.5, layerImage.size.width, layerImage.size.height)];
    [controller.view addSubview:controller.rightButton];
    
    [controller.rightButton addTarget:controller action:@selector(openRightDock) forControlEvents:UIControlEventTouchDragOutside];
    [controller.rightButton addTarget:controller action:@selector(openRightDock) forControlEvents:UIControlEventTouchUpInside];
    
    [controller.rightButton setBackgroundImage:layerImage forState:UIControlStateNormal];
    [controller.view addSubview:controller.rightButton];
    
    // Share button (disabled now)
    UIImage *shareImage = [UIImage imageNamed:@"share_button.png"];
    controller.shareButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-shareImage.size.width-marginUnit*2,
                                                             [App viewBounds].size.height-shareImage.size.height-marginUnit*2.5,
                                                             shareImage.size.width, shareImage.size.height)];
    [controller.shareButton setBackgroundImage:shareImage forState:UIControlStateNormal];
    [controller.shareButton addTarget:controller action:@selector(toggleShareControls) forControlEvents:UIControlEventTouchUpInside];
    
    [controller.view addSubview:controller.shareButton];
    
    UIImage *saveImage = [UIImage imageNamed:@"save_button.png"];
    controller.saveButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-saveImage.size.width-10,
                                                            [App viewBounds].size.height-saveImage.size.height-marginUnit*2.5,
                                                            saveImage.size.width, saveImage.size.height)];
    [controller.saveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [controller.saveButton addTarget:controller action:@selector(presentPOIEditViewControllerForCurrentLayer) forControlEvents:UIControlEventTouchUpInside];
    [controller.saveButton setHidden:YES];
    [controller.view addSubview:controller.saveButton];
    
    UIImage *returnImage = [UIImage imageNamed:@"return_button.png"];
    controller.returnButton = [[UIButton alloc] initWithFrame:CGRectMake(controller.saveButton.frame.origin.x-returnImage.size.width-10,
                                                              [App viewBounds].size.height-returnImage.size.height-marginUnit*2.5,
                                                              returnImage.size.width, returnImage.size.height)];
    [controller.returnButton setBackgroundImage:returnImage forState:UIControlStateNormal];
    [controller.returnButton addTarget:controller action:@selector(toggleShareControls) forControlEvents:UIControlEventTouchUpInside];
    [controller.returnButton setHidden:YES];
    [controller.view addSubview:controller.returnButton];
}

- (UIView*) generateMarkerDetailsOverlayViewForCyclestation:(Cyclestation *)cycleStation withMarker:(GMSMarker*)marker
{
    CyclestationUIView* cyview = [[[NSBundle mainBundle] loadNibNamed:@"CyclestationUIView" owner:controller options:nil] objectAtIndex:0];
    
    TTTLocationFormatter *locationFormatter = [[TTTLocationFormatter alloc] init];
    
    CLLocation *markerLocation = [[CLLocation alloc]
                                  initWithLatitude:marker.position.latitude
                                  longitude:marker.position.longitude];
    
    NSString *distance = [locationFormatter stringFromDistanceAndBearingFromLocation:controller.mapView.myLocation toLocation:markerLocation];
    [[cyview rightBottomLabel] setText:[NSLocalizedString(@"distance_at", nil) stringByAppendingString:distance]];
    [[cyview availableBikesNumberLabel] setText:[NSString stringWithFormat:@"%d", [cycleStation.availableBikes intValue]]];
    [[cyview availableBikesTextLabel] setText:NSLocalizedString(@"bikes_available", nil)];
    [[cyview availableSlotsNumberLabel] setText:[NSString stringWithFormat:@"%d", [cycleStation.availableSlots intValue]]];
    [[cyview availableSlotsTextLabel] setText:NSLocalizedString(@"slots_available", nil)];
    
    return cyview;
}

- (UIView*) generateMarkerDetailsOverlayViewForRoute:(Route*)route
{
    RouteUIView *routeView = [[[NSBundle mainBundle] loadNibNamed:@"RouteUIView" owner:controller options:nil] objectAtIndex:0];
    
    [[routeView titleLabel] setText:[route title]];
    [[routeView subtitleLabel] setText:[route subtitle]];
    
    [[routeView distanceNumberLabel] setText:[route distanceString]];
    [[routeView distanceWordsLabel] setText:@"KM"];
    
    [[[routeView goToButton] titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:12]];
    [[[routeView goToButton] titleLabel] setTextColor:[LookAndFeel orangeColor]];
    [[[routeView goToButton] titleLabel] setText:NSLocalizedString(@"route_to_start", nil)];
    [[routeView goToButton] addTarget:controller action:@selector(moveToMarker:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[routeView attachButton] titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:12]];
    [[[routeView attachButton] titleLabel] setTextColor:[LookAndFeel orangeColor]];
    [[[routeView attachButton] titleLabel] setText:NSLocalizedString(@"route_attach_view", nil)];
    [[routeView attachButton] addTarget:controller action:@selector(attachViewToggled:) forControlEvents:UIControlEventTouchUpInside];
    
    [[routeView moreDetailsButton] addTarget:controller action:@selector(presentMarkerDetailsViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *remoteRouteId = [NSString stringWithFormat:@"%d", [(NSNumber*)[route remoteId] intValue]];
    NSString *resourceURL = [[App urlForResource:layersRoutes withSubresource:@"show"] stringByReplacingOccurrencesOfString:@":id" withString:remoteRouteId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:resourceURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            NSArray *path = [[response objectForKey:@"route"] objectForKey:@"path"];
            [self drawPolyline:path];
            [[route complementaryMarker] setMap:controller.mapView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return routeView;
}

- (void) drawPolyline:(NSArray*) polyline
{
    GMSMutablePath *path = [GMSMutablePath path];
    for (NSArray *pair in polyline) {
        double lat = [[pair objectAtIndex:0] doubleValue];
        double lon = [[pair objectAtIndex:1] doubleValue];
        [path addCoordinate:CLLocationCoordinate2DMake(lon, lat)];
    }
    
    GMSPolyline *newRoutePath = [GMSPolyline polylineWithPath:path];
    newRoutePath.strokeColor = [LookAndFeel blueColor];
    newRoutePath.strokeWidth = 7.f;
    newRoutePath.geodesic = YES;
    
    [self clearPolyline];
    controller.selectedRoutePath = newRoutePath;
    dispatch_async(dispatch_get_main_queue(), ^{
        controller.selectedRoutePath.map = controller.mapView;
    });
}

- (void) clearPolyline
{
    if (controller.selectedRoutePath != nil) {
        controller.selectedRoutePath.map = nil;
        controller.selectedRoutePath = nil;
    }
}

- (void) fetchLayer:(NSString *)displayLayer
{
    if (displayLayer == nil || controller.detailsView != nil) {
        return;
    }
    controller.requestOngoing = YES;
    
    // bottom == near
    CLLocationCoordinate2D sw = controller.mapView.projection.visibleRegion.nearLeft;
    NSString *swString = [NSString stringWithFormat:@"%f,%f", sw.latitude, sw.longitude];
    // top == far
    CLLocationCoordinate2D ne = controller.mapView.projection.visibleRegion.farRight;
    NSString *neString = [NSString stringWithFormat:@"%f,%f", ne.latitude, ne.longitude];
    
    NSString *layer = [[displayLayer componentsSeparatedByString:@"_layers"] objectAtIndex:0];
    
    NSString *resourceURL = NULL;
    if ([layersParkings isEqualToString:layer]) {
        resourceURL = [[App urlForResource:layersParkings withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([layersTips isEqualToString:layer]) {
        resourceURL = [[App urlForResource:layersTips withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([layersWorkshops isEqualToString:layer]) {
        resourceURL = [[App urlForResource:layersWorkshops withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([layersBicycleSharings isEqualToString:layer]) {
        resourceURL = [[App urlForResource:layersBicycleSharings withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([layersRoutes isEqualToString:layer]) {
        resourceURL = [[App urlForResource:layersRoutes withSubresource:@"get"] stringByAppendingString:viewportParams];
    }
    
    // Block which redraws items on the map
    void (^drawItemsOnMap)(NSArray*) = ^(NSArray* items) {
        [controller.mapView clear];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (BaseModel *model in items) {
                if ([controller.mapView.projection containsCoordinate:model.coordinate]) {
                    if (model.marker.map == nil) {
                        model.marker.map = controller.mapView;
                    }
                } else {
                    model.marker.map = nil;
                }
            }
        });
    };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager setRequestSerializer:requestSerializer];
    [manager GET:[NSString stringWithFormat:resourceURL, swString, neString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            // Parkings
            if ([layer isEqualToString:layersParkings]) {
                NSArray *jsonObjects = [response objectForKey:layersParkings];
                [Parking buildFrom:jsonObjects];
                drawItemsOnMap([[Parking parkingsLoaded] allValues]);
                // Tips
            } else if([layer isEqualToString:layersTips ]) {
                NSArray *jsonObjects = [response objectForKey:layersTips];
                [Tip buildFrom:jsonObjects];
                drawItemsOnMap([[Tip tipsLoaded] allValues]);
            }
            // Workshops
            else if ([layer isEqualToString:layersWorkshops]) {
                NSArray *jsonObjects = [response objectForKey:layersWorkshops];
                [Workshop buildFrom:jsonObjects];
                drawItemsOnMap([[Workshop workshopsLoaded] allValues]);
            }
            // Cyclestations
            else if ([layer isEqualToString:layersBicycleSharings]) {
                NSArray *jsonObjects = [response objectForKey:layersBicycleSharings];
                [Cyclestation buildFrom:jsonObjects];
                drawItemsOnMap([[Cyclestation cyclestationsLoaded] allValues]);
            }
            // Routes
            else if ([layer isEqualToString:layersRoutes]) {
                NSArray *jsonObjects = [response objectForKey:layersRoutes];
                [Route buildFrom:jsonObjects];
                drawItemsOnMap([[Route routesLoaded] allValues]);
            }
        }
        
        controller.requestOngoing = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        controller.requestOngoing = NO;
    }];
}

/*- (void) presentShareSelectorView
 {
 poiView = [[[NSBundle mainBundle] loadNibNamed:@"POIChooserOverlayView" owner:self options:nil] objectAtIndex:0];
 [self.view addSubview:poiView];
 [poiView stylizeUI];
 [poiView setUserInteractionEnabled:YES];
 
 [[poiView workshopButton] addTarget:self action:@selector(presentControllerForPOI:) forControlEvents:UIControlEventTouchUpInside];
 [[poiView parkingButton] addTarget:self action:@selector(presentControllerForPOI:) forControlEvents:UIControlEventTouchUpInside];
 [[poiView tipButton] addTarget:self action:@selector(presentControllerForPOI:) forControlEvents:UIControlEventTouchUpInside];
 
 [[poiView closeButton] addTarget:self action:@selector(hideChooserMenu) forControlEvents:UIControlEventTouchUpInside];
 
 [saveButton setHidden:YES];
 [returnButton setHidden:YES];
 
 UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideChooserMenu)];
 [recognizer setNumberOfTapsRequired:1];
 [poiView addGestureRecognizer:recognizer];
 }
 
 - (void) hideChooserMenu
 {
 [poiView removeFromSuperview];
 }*/



@end
