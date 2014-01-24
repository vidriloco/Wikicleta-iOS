//
//  MapViewCompanionManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "MapViewCompanionManager.h"
#import "MapViewController.h"

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

- (void) loadMapMessageView
{
    controller.mapMessageView = [[[NSBundle mainBundle] loadNibNamed:@"OverlayMapMessageView" owner:controller options:nil] objectAtIndex:0];
    [controller.mapMessageView setFrame:CGRectMake(0, 30, controller.mapMessageView.frame.size.width, controller.mapMessageView.frame.size.height)];
}

- (void) loadSharePinView
{
    controller.sharePin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wikicleta_pin.png"]];
    [controller.sharePin setFrame:CGRectMake([App viewBounds].size.width/2-controller.sharePin.frame.size.width/2,
                                  [App viewBounds].size.height/2-controller.sharePin.frame.size.height/2,
                                  controller.sharePin.frame.size.width, controller.sharePin.frame.size.height)];
    controller.editSharePin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sightseeing_marker.png"]];
    [controller.editSharePin setFrame:CGRectMake([App viewBounds].size.width/2-controller.editSharePin.frame.size.width/2,
                                             [App viewBounds].size.height/2-controller.editSharePin.frame.size.height,
                                             controller.editSharePin.frame.size.width, controller.editSharePin.frame.size.height)];
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
    
    // ShowList button (disabled now)
    /*UIImage *listImage = [UIImage imageNamed:@"list_button.png"];
    controller.showListButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-listImage.size.width-marginUnit*2,
                                                                        [App viewBounds].size.height-listImage.size.height-marginUnit*2.5,
                                                                        listImage.size.width, listImage.size.height)];
    [controller.showListButton setBackgroundImage:listImage forState:UIControlStateNormal];
    [controller.showListButton addTarget:controller action:@selector(toggleListViewControls) forControlEvents:UIControlEventTouchUpInside];
    
    [controller.view addSubview:controller.showListButton];*/
    
    UIImage *locationImage = [UIImage imageNamed:@"compass_disabled_button.png"];
    controller.locationButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-locationImage.size.width-10, 120, locationImage.size.width, locationImage.size.height)];
    [controller.locationButton setBackgroundImage:locationImage forState:UIControlStateNormal];
    [controller.locationButton addTarget:controller action:@selector(showMyLocationOnMap) forControlEvents:UIControlEventTouchUpInside];
    [controller.view addSubview:controller.locationButton];

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
    [controller.returnButton addTarget:self action:@selector(restoreMapToPreviousState) forControlEvents:UIControlEventTouchUpInside];
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

- (UIView*) generateMarkerDetailsOverlayViewForCyclepath:(CyclePath *)cyclePath withMarker:(GMSMarker*)marker
{
    CyclePathView* phview = [[[NSBundle mainBundle] loadNibNamed:@"CyclePathView" owner:controller options:nil] objectAtIndex:0];
    [[phview detailsLabel] setText:cyclePath.details];
    
    return phview;
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
            GMSPolyline *polyline = [self buildPolyline:path withColor:[LookAndFeel blueColor] withStroke:7.0f];
            [self deselectSelectedRoutePath];
            controller.selectedRoutePath = polyline;
            dispatch_async(dispatch_get_main_queue(), ^{
                controller.selectedRoutePath.map = controller.mapView;
            });
            [[route complementaryMarker] setMap:controller.mapView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return routeView;
}

// Momentary fix for trips service returning inverted coordinates components
- (GMSPolyline*) buildPolyline:(NSArray*) polyline withColor:(UIColor*)color withStroke:(float)stroke withCoordsInversion:(BOOL)coordsInversion
{
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (NSArray *pair in polyline) {
        double lon = [[pair objectAtIndex:0] doubleValue];
        double lat = [[pair objectAtIndex:1] doubleValue];
        if (coordsInversion) {
            [path addCoordinate:CLLocationCoordinate2DMake(lon, lat)];
        } else {
            [path addCoordinate:CLLocationCoordinate2DMake(lat, lon)];
        }
    }
    
    GMSPolyline *newRoutePath = [GMSPolyline polylineWithPath:path];
    newRoutePath.strokeColor = color;
    newRoutePath.strokeWidth = stroke;
    newRoutePath.geodesic = YES;
    return newRoutePath;
}

- (GMSPolyline*) buildPolyline:(NSArray*) polyline withColor:(UIColor *)color withStroke:(float)stroke
{
    return [self buildPolyline:polyline withColor:color withStroke:stroke withCoordsInversion:NO];
}

- (void) deselectSelectedRoutePath
{
    if (controller.selectedRoutePath != nil) {
        controller.selectedRoutePath.map = nil;
        controller.selectedRoutePath = nil;
    }
}

- (void) clearItemsOnMap
{
    for (BaseModel *model in controller.itemsOnMap) {
        [model.marker setMap:nil];
    }
}

- (void) fetchLayer:(NSString *)displayLayer
{
    if (displayLayer == nil || controller.detailsView != nil) {
        if (displayLayer == nil) {
            [self clearItemsOnMap];
        }
        return;
    }
    controller.requestOngoing = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // bottom == near
    CLLocationCoordinate2D sw = controller.mapView.projection.visibleRegion.nearLeft;
    NSString *swString = [NSString stringWithFormat:@"%f,%f", sw.latitude, sw.longitude];
    // top == far
    CLLocationCoordinate2D ne = controller.mapView.projection.visibleRegion.farRight;
    NSString *neString = [NSString stringWithFormat:@"%f,%f", ne.latitude, ne.longitude];
    
    NSString *layer = [[displayLayer componentsSeparatedByString:@"_layers"] objectAtIndex:0];
    NSString *resourceURL = [[App urlForResource:layer withSubresource:@"get"] stringByAppendingString:viewportParams];

    
    if ([layer isEqualToString:layersCyclingGroups] || [layer isEqualToString:layersTrips]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        resourceURL = [[resourceURL stringByAppendingString:@"&extras[date]="]
                       stringByAppendingString:[dateFormatter stringFromDate:[NSDate date]]];
    }
    
    // Block which redraws items on the map
    void (^drawItemsOnMap)(NSArray*) = ^(NSArray* items) {
        [self clearItemsOnMap];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *newItems = [NSMutableArray array];
            for (BaseModel *model in items) {
                if ([controller.mapView.projection containsCoordinate:model.coordinate]) {
                    if (model.marker.map == nil) {
                        model.marker.map = controller.mapView;
                        [newItems addObject:model];
                    }
                } else {
                    model.marker.map = nil;
                }
            }
            controller.itemsOnMap = newItems;
        });
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    NSString *url = [NSString stringWithFormat:resourceURL, swString, neString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            // Cycling Groups
            else if ([layer isEqualToString:layersCyclingGroups]) {
                NSArray *jsonObjects = [response objectForKey:layersCyclingGroups];
                [CyclingGroup buildFrom:jsonObjects];
                drawItemsOnMap([[CyclingGroup cyclingGroupsLoaded] allValues]);
            } else if ([layer isEqualToString:layersTrips]) {
                NSArray *jsonObjects = [response objectForKey:layersTrips];
                [Trip buildFrom:jsonObjects];
                drawItemsOnMap([[Trip tripsLoaded] allValues]);
            }
        }
        
        controller.requestOngoing = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        controller.requestOngoing = NO;
    }];
}

- (void) restoreMapToPreviousState
{
    if ([controller currentMapMode] == EditShare) {
        [controller.poisManager restoreMapOnCancelPOIEditing];
    } else {
        [controller toggleShareControls];
	}
}

- (void) unmountSelectedModelMarkerFromMap {
    [[controller.currentlySelectedModel marker] setIcon:[UIImage imageNamed:@"guess_marker.png"]];
}

- (void) mountSelectedModelMarkerFromMap {
    [[controller.currentlySelectedModel marker] setIcon:[controller.currentlySelectedModel markerIcon]];
}

- (void) displaySavedChangesNotification
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"saved_success", nil);
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save_icon.png"]];
    [hud hide:YES afterDelay:1];
}

- (void) displayOnEditModeNotification
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"editing_on", nil);
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"editing_mode_icon.png"]];
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    [hud hide:YES afterDelay:1];
}

- (void) displayDeletedNotification
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"deleted_success", nil);
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save_icon.png"]];
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    [hud hide:YES afterDelay:1];
}

/*- (void) showSynchronizationView
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
