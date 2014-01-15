//
//  ExploreViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewCompanionManager.h"
#import "TripsManager.h"

@interface MapViewController () {
    BOOL firstLocationUpdateReceived;
    
    CLLocation *mapLastCenteredAt;
    
    id <ModelHumanizer> currentlySelectedModel;
        
    GMSCameraPosition *lastCamera;
        
    UIViewController *defaultLeftViewController;
    UIViewController *defaultRightViewController;
    MapMode currentMode;

    MapViewCompanionManager *companionObject;
    TripsManager *tripsManager;
}

- (void) addCyclePathMarkersToMap;
- (void) addViewForMarker:(GMSMarker*)marker;
- (void) attachViewToggled:(id)selector;
- (void) hideViewForMarker;
- (void) moveToMarker:(id)selector;

- (void) openLeftDock;
- (void) openRightDock;

- (void) presentMarkerDetailsViewController:(id)sender;
- (void) presentPOIEditViewControllerForCurrentLayer;
- (void) presentCyclingGroupViewController:(id)sender;
- (void) synchronize;
- (void) toggleFavorite:(id)sender;
- (void) toggleShareControls;
- (void) toggleListViewControls;
- (void) triggerControlledFetch:(CLLocationCoordinate2D)coordinate;
- (TripsManager*) tripsManager;

@end

@implementation MapViewController

@synthesize activeLayer, rightButton, leftButton, saveButton, returnButton, shareButton, sharePin, mapView, selectedRoutePath, detailsView, requestOngoing, mapMessageView, itemsOnMap, secondaryView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        lastCamera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                 longitude:151.20
                                                      zoom:minZoom];
        defaultLeftViewController = [[MainMenuViewController alloc] initWithNibName:nil bundle:nil];
        defaultRightViewController = [[LayersChooserViewController alloc] init];
        [(LayersChooserViewController*) defaultRightViewController setDelegate:self];
        
        companionObject = [[MapViewCompanionManager alloc] initWithMapViewController:self];
        [companionObject loadSharePinView];
        [companionObject loadMapMessageView];
        
    }
    return self;
}

- (void) viewDidLoad
{
    self.view = [[UIView alloc] initWithFrame:[App viewBounds]];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:lastCamera];
    mapView.myLocationEnabled = YES;
    [self.view addSubview:mapView];
    [mapView setDelegate:self];
    
    [companionObject loadMapButtons];
    [self transitionMapToMode:Explore];
    [self.viewDeckController setDelegate:self];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [mapView removeObserver:self forKeyPath:@"myLocation"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewDidDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];

    [mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
    
    [self addCyclePathMarkersToMap];
}

#pragma mark - IIViewDeck delegate methods

- (void) viewDeckController:(IIViewDeckController *)viewDeckController didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    [companionObject fetchLayer:activeLayer];
    [self transitionMapToMode:currentMode];
}

#pragma mark - MapView delegate methods

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (currentMode == Detail) {
        [self hideViewForMarker];
        [self transitionMapToMode:Explore];
    }
}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([[(WikiMarker*) marker model] isKindOfClass:[TripPoi class]]) {
        [[self tripsManager] drawViewForTripPoi:(TripPoi*) [(WikiMarker*) marker model]];
    }
    
    if (currentMode != DetailFixed) {
        [self addViewForMarker:marker];
    }
    return YES;
}

- (void) mapView:(GMSMapView *)mapView_ didChangeCameraPosition:(GMSCameraPosition *)position
{
    if (position.zoom < minZoom) {
        GMSCameraPosition *newPosition = [[GMSCameraPosition alloc]
                                          initWithTarget:position.target
                                          zoom:minZoom
                                          bearing:position.bearing
                                          viewingAngle:position.viewingAngle];
        [mapView setCamera:newPosition];
    }
}

- (void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    [self triggerControlledFetch:[position targetAsCoordinate]];
}

- (void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"synchronization_question", nil)
                                                    message:NSLocalizedString(@"synchronization_details", nil)
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"synchronize", nil), nil];
    [alert show];

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdateReceived) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdateReceived = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:minZoom];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        [self synchronize];
    }
}

#pragma mark - Custom implemented methods for this UIViewController

- (void) addCyclePathMarkersToMap
{
    for (CyclePath *cyclePath in [[CyclePath stored] allValues]) {
        [cyclePath loadMarker];
        [cyclePath loadPathFromStore];
        cyclePath.polyline = [companionObject buildPolyline:[cyclePath path] withColor:[LookAndFeel greenColor] withStroke:5.0f];
        [cyclePath.polyline setMap:mapView];
        [cyclePath.marker setMap:mapView];
    }
}

/**
 *  Builds and displays the view overlay for a selected map marker
 */
- (void) addViewForMarker:(GMSMarker*)marker
{
    if (detailsView != nil) {
        [detailsView removeFromSuperview];
        [self hideViewForMarker];
    }
    
    [self transitionMapToMode:Detail];
    
    currentlySelectedModel = ((WikiMarker*) marker).model;
    
    if ([currentlySelectedModel isKindOfClass:[Cyclestation class]]) {
        // Build view from XIB file
        detailsView = [companionObject generateMarkerDetailsOverlayViewForCyclestation:(Cyclestation*)currentlySelectedModel withMarker:marker];
    } else if ([currentlySelectedModel isKindOfClass:[Route class]]) {
        // Build view from XIB file
        detailsView = [companionObject generateMarkerDetailsOverlayViewForRoute:(Route*) currentlySelectedModel];
    } else if ([currentlySelectedModel isKindOfClass:[CyclePath class]]) {
        CyclePath *cyclePath = (CyclePath*)currentlySelectedModel;
        detailsView = [companionObject generateMarkerDetailsOverlayViewForCyclepath:cyclePath withMarker:marker];
        NSString *title = [cyclePath oneWay] ? NSLocalizedString(@"one_way_path", nil) : NSLocalizedString(@"two_ways_path", nil) ;
        [[detailsView extraSubtitleLabel] setText:title];
        [[detailsView rightBottomLabel] setText:cyclePath.createdBy];
//681449F435
    } else if ([currentlySelectedModel isKindOfClass:[CyclingGroup class]]) {
        // Build view from XIB file
        detailsView = [[[NSBundle mainBundle] loadNibNamed:@"CyclingGroupView" owner:self options:nil] objectAtIndex:0];
        
        [[detailsView rightBottomLabel] setText:[currentlySelectedModel createdBy]];
        [[detailsView detailsLabel] setText:[currentlySelectedModel extraAnnotation]];
        [[detailsView moreDetailsButton] addTarget:self action:@selector(presentCyclingGroupViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([(CyclingGroup*) currentlySelectedModel picUrl] != nil) {
            __weak UIImageView *picView = [(CyclingGroupView*) detailsView picImageView];

            [UIView animateWithDuration:1.5 delay:1 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut) animations:^{
                [picView setAlpha:0.5];
            } completion:nil];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[(CyclingGroup*) currentlySelectedModel picUrl]]];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            
            [picView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"cycling_group_logo"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [picView.layer removeAllAnimations];
                [picView setAlpha:1];
                [picView setImage:image];
                [picView.layer setCornerRadius:18];
                picView.layer.masksToBounds = YES;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                [picView.layer removeAllAnimations];
            }];
        }
    } else if ([currentlySelectedModel isKindOfClass:[Trip class]]) {
        // Build view from XIB file
        detailsView = [[[NSBundle mainBundle] loadNibNamed:@"TripView" owner:self options:nil] objectAtIndex:0];
        [[(TripView*) detailsView detailsLabel] setText:[currentlySelectedModel extraAnnotation]];
        
        UIImageView *picView = [(TripView*) detailsView picImageView];
        UIButton *attachButton = [(TripView*) detailsView fixateTogglerButton];
        [[attachButton titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:12]];
        [[attachButton titleLabel] setTextColor:[LookAndFeel orangeColor]];
        [[attachButton titleLabel] setText:NSLocalizedString(@"route_attach_view", nil)];
        [attachButton addTarget:self action:@selector(attachViewToggled:) forControlEvents:UIControlEventTouchUpInside];
        [[(TripView*) detailsView hiddenTitleLabel] setText:currentlySelectedModel.title];

        Trip *trip = (Trip*) currentlySelectedModel;
        
        [picView setImage:[UIImage imageNamed:[trip imageName]]];
        [picView.layer setCornerRadius:10];
        picView.layer.masksToBounds = YES;
        
        NSMutableArray *polylines = [NSMutableArray array];
        for (NSArray *segment in [trip segments]) {
            GMSPolyline *polyline = [companionObject buildPolyline:segment withColor:[UIColor blackColor] withStroke:5.0f withCoordsInversion:YES];
            [polyline setMap:mapView];
            [polylines addObject:polyline];
        }
        [trip setPolylines:polylines];
        
        for (TripPoi* tripPoi in [(Trip*) currentlySelectedModel pois]) {
            [[tripPoi marker] setMap:mapView];
        }
        
    } else {
        // Build view from XIB file
        detailsView = [[[NSBundle mainBundle] loadNibNamed:@"MarkerInfoUIView" owner:self options:nil] objectAtIndex:0];
        [[detailsView rightBottomLabel] setText:[currentlySelectedModel extraAnnotation]];
        
        [[detailsView favoriteButton] addTarget:self action:@selector(toggleFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [[detailsView moreDetailsButton] addTarget:self action:@selector(presentMarkerDetailsViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (![currentlySelectedModel isKindOfClass:[Trip class]]) {
        TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        NSString *updatedAtString = [timeIntervalFormatter stringForTimeInterval:[currentlySelectedModel.updatedAt timeIntervalSinceNow]];
        [[detailsView leftBottomLabel] setText:[NSLocalizedString(@"updated_at", nil) stringByAppendingString:updatedAtString]];
    }
    
    [[detailsView titleLabel] setText:currentlySelectedModel.title];
    [[detailsView subtitleLabel] setText:currentlySelectedModel.subtitle.uppercaseString];
    
    [self.view addSubview:detailsView];
    [detailsView setFrame:CGRectMake(0,
                                     self.view.frame.size.height, [detailsView frame].size.width, [detailsView frame].size.height)];
    [detailsView stylizeView];
    
    [detailsView setHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        [(UIView*) detailsView setTransform:CGAffineTransformMakeTranslation(0, -[detailsView frame].size.height)];
    } completion:nil];
    
    lastCamera = [[mapView camera] copy];
    [mapView setCamera:[[GMSCameraPosition alloc] initWithTarget:marker.position zoom:poiDetailedZoom bearing:mapView.camera.bearing viewingAngle:mapView.camera.viewingAngle]];
}

/*
 *  Brings the mapmode to a DetailFixed state locking the map's predefined behaviour (tap on coordinate to hide marker details view) until unlocked
 */
- (void) attachViewToggled:(id)selector
{
    UIButton *button = (UIButton*) selector;
    UIView *viewC = (UIButton*) detailsView;
    
    if ([currentlySelectedModel isKindOfClass:[Route class]]) {
        if ([selector tag] == 0) {
            [button setTitle:NSLocalizedString(@"route_detach_view", nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"attach_icon.png"] forState:UIControlStateNormal];
            
            [button setAlpha:1];
            [UIView animateWithDuration:0.3 animations:^{
                [viewC setFrame:CGRectMake(viewC.frame.origin.x, viewC.frame.origin.y+viewC.frame.size.height-55, viewC.frame.size.width, viewC.frame.size.height)];
            } completion:nil];
            [button setTag:1];
            [self transitionMapToMode:DetailFixed];
        } else {
            [button setTitle:NSLocalizedString(@"route_attach_view", nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"attach_icon_h.png"] forState:UIControlStateNormal];
            [button setAlpha:0.5];
            [UIView animateWithDuration:0.3 animations:^{
                [viewC setFrame:CGRectMake(viewC.frame.origin.x, viewC.frame.origin.y-viewC.frame.size.height+55, viewC.frame.size.width, viewC.frame.size.height)];
            } completion:nil];
            [button setTag:0];
            [self transitionMapToMode:Detail];
        }
    } else if ([currentlySelectedModel isKindOfClass:[Trip class]]) {
        [[self tripsManager] toggleFixateViewForButton:button];
    }
}

- (MapMode) currentMapMode
{
    return currentMode;
}

/*
 *  Hides the view for the currently selected marker
 */
- (void) hideViewForMarker {
    [companionObject deselectSelectedRoutePath];
    
    if ([currentlySelectedModel isKindOfClass:[Route class]]) {
        [[(Route*) currentlySelectedModel complementaryMarker] setMap:nil];
    } else if([currentlySelectedModel isKindOfClass:[Trip class]]) {
        for (GMSPolyline *polyline in [(Trip*) currentlySelectedModel polylines]) {
            [polyline setMap:nil];
        }
        for (TripPoi* tripPoi in [(Trip*) currentlySelectedModel pois]) {
            [[tripPoi marker] setMap:nil];
        }
        
        [tripsManager hideCurrentTripPoiView];
    }
    
    currentlySelectedModel = nil;
    
    [detailsView removeFromSuperview];
    detailsView = nil;

    [mapView setCamera:lastCamera];
    [self transitionMapToMode:Explore];
}

/*
 *   Moves the mapview camera from route start marker to end route marker or vice-versa
 */
- (void) moveToMarker:(id)selector
{
    if ([currentlySelectedModel isKindOfClass:[Route class]]) {
        Route *route = (Route*) currentlySelectedModel;
        UIButton *button = (UIButton*) selector;
        
        if ([selector tag] == 0) {
            [button setTitle:NSLocalizedString(@"route_to_start", nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"start_route_marker.png"] forState:UIControlStateNormal];
            [mapView setCamera:[[GMSCameraPosition alloc] initWithTarget:[route secondCoordinate]
                                                                    zoom:mapView.camera.zoom
                                                                 bearing:mapView.camera.bearing
                                                            viewingAngle:mapView.camera.viewingAngle]];
            [button setTag:1];
        } else {
            [button setTitle:NSLocalizedString(@"route_to_end", nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"end_route_marker.png"] forState:UIControlStateNormal];
            
            [mapView setCamera:[[GMSCameraPosition alloc] initWithTarget:[route coordinate]
                                                                    zoom:mapView.camera.zoom
                                                                 bearing:mapView.camera.bearing
                                                            viewingAngle:mapView.camera.viewingAngle]];
            [button setTag:0];
        }
    }
}

- (void) synchronize {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // bottom == near
    CLLocationCoordinate2D sw = mapView.projection.visibleRegion.nearLeft;
    NSString *swString = [NSString stringWithFormat:@"%f,%f", sw.latitude, sw.longitude];
    // top == far
    CLLocationCoordinate2D ne = mapView.projection.visibleRegion.farRight;
    NSString *neString = [NSString stringWithFormat:@"%f,%f", ne.latitude, ne.longitude];
    
    NSString *resourceURL = [[App urlForResource:layersBicycleLanes withSubresource:@"get"] stringByAppendingString:viewportParams];
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager setRequestSerializer:requestSerializer];
    [manager GET:[NSString stringWithFormat:resourceURL, swString, neString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            
            // Clear previous cyclepaths from the map
            for (CyclePath *cyclePath in [[CyclePath stored] allValues]) {
                [cyclePath.polyline setMap:nil];
                [cyclePath.marker setMap:nil];
            }
            
            // Insert just fetched cyclepaths (Will replace existant)
            [CyclePath storeFetched:[response objectForKey:@"cycle_paths"]];
            
            // Add them to map
            [self addCyclePathMarkersToMap];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

}

/*
 *  Sets a Left Dock UIViewController if not set, and then opens the leftview
 */
- (void) openLeftDock {
    
    if ([self.viewDeckController leftController] == nil) {
        [self.viewDeckController setLeftController:defaultLeftViewController];
    }
    [self.viewDeckController openLeftViewAnimated:YES];
}

/*
 *  Sets a Right Dock UIViewController if not set, and then opens the rightview
 */
- (void) openRightDock
{
    if ([self.viewDeckController rightController] == nil) {
        [self.viewDeckController setRightController:defaultRightViewController];
    }
    [self.viewDeckController openRightViewAnimated:YES];

}

/*
 *  Presents a view controller with extended details about
 *  a previously selected POI
 */
- (void) presentMarkerDetailsViewController:(id)sender {
    MarkerDetailsViewController *markerDetailsController = [[MarkerDetailsViewController alloc] initWithNibName:@"MarkerDetailsViewController" bundle:nil];
    [markerDetailsController setSelectedModel:currentlySelectedModel];
    
    [(UINavigationController*) [[self viewDeckController] centerController] pushViewController:markerDetailsController animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"map", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
    
    if (!IS_OS_7_OR_LATER) {
        [backButton setTitleTextAttributes:@{ UITextAttributeTextColor: [UIColor whiteColor],
                                              UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                              UITextAttributeFont: [LookAndFeel defaultFontBookWithSize:14],
                                              } forState:UIControlStateNormal];
    }
    
    // For iOS 6 and below
    [backButton setTintColor:[LookAndFeel middleBlueColor]];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void) presentCyclingGroupViewController:(id)sender
{
    CyclingGroupViewController *cyclingGroupViewController = [[CyclingGroupViewController alloc] initWithNibName:@"CyclingGroupViewController" bundle:nil];
    [cyclingGroupViewController setSelectedModel:currentlySelectedModel];
    
    [(UINavigationController*) [[self viewDeckController] centerController] pushViewController:cyclingGroupViewController animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"map", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
    
    if (!IS_OS_7_OR_LATER) {
        [backButton setTitleTextAttributes:@{ UITextAttributeTextColor: [UIColor whiteColor],
                                              UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                              UITextAttributeFont: [LookAndFeel defaultFontBookWithSize:14],
                                              } forState:UIControlStateNormal];
    }
    
    // For iOS 6 and below
    [backButton setTintColor:[LookAndFeel middleBlueColor]];
    self.navigationItem.backBarButtonItem = backButton;
}

/*
 *  Presents the corresponding view controller appropiate for editing
 *  the kind of POIs of the active layer
 */
- (void) presentPOIEditViewControllerForCurrentLayer
{
    UINavigationController *nav = (UINavigationController*) [[self viewDeckController] centerController];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    // Prepare visual marker to aid user on location selection
    CGPoint center = CGPointMake(sharePin.frame.origin.x+(sharePin.frame.size.width)/2, sharePin.frame.origin.y+sharePin.frame.size.height);
    
    NSString *layer = [[activeLayer componentsSeparatedByString:@"_layers"] objectAtIndex:0];
    if ([layer isEqualToString:layersWorkshops]) {
        EditWorkshopViewController *tipController = [[EditWorkshopViewController alloc] initWithNibName:nil bundle:nil];
        [tipController setSelectedCoordinate:[[mapView projection] coordinateForPoint:center]];
        
        [nav
         pushViewController:tipController
         animated:NO];
    } else if ([layer isEqualToString:layersParkings]) {
        EditParkingViewController *parkingController = [[EditParkingViewController alloc] initWithNibName:nil bundle:nil];
        [parkingController setSelectedCoordinate:[[mapView projection] coordinateForPoint:center]];
        [nav
         pushViewController:parkingController
         animated:NO];
    } else if ([layer isEqualToString:layersTips]) {
        EditTipViewController *tipController = [[EditTipViewController alloc] initWithNibName:nil bundle:nil];
        [tipController setSelectedCoordinate:[[mapView projection] coordinateForPoint:center]];
        [nav
         pushViewController:tipController
         animated:NO];
    }
}

/*
 *   Makes sure that the currently selected model becomes a favorite (if it is not yet) of the user, or gets unfavorited (if it was already)
 */
- (void) toggleFavorite:(id)sender {
    NSLog(@"Favorite for");
}

- (void) toggleListViewControls
{
    // Display list controller
}

/*
 *  Helper method for toggling Explore/Share controls
 */
- (void) toggleShareControls
{
    if (currentMode == Explore) {
        [self transitionMapToMode:Share];
    } else {
        [self transitionMapToMode:Explore];
    }
}

/*
 *   Allow for map mode transitioning between states such as: Share, Explore, Detail and DetailFixed
 */
- (void) transitionMapToMode:(MapMode)mode
{
    NSString* layer = [[activeLayer componentsSeparatedByString:@"_"] objectAtIndex:0];
    if (mode == Share) {
        [self.view addSubview:sharePin];
        [leftButton setHidden:YES];
        [rightButton setHidden:YES];
        [shareButton setHidden:YES];
        //[showListButton setHidden:YES];
        [saveButton setHidden:NO];
        [returnButton setHidden:NO];
        [self.viewDeckController setRightController:nil];
        [self.viewDeckController setLeftController:nil];
        
        [mapMessageView loadViewWithTitle:NSLocalizedString(@"select_location_title", nil) andSubtitle:NSLocalizedString(@"select_location_subtitle", nil)];
        [mapView addSubview:mapMessageView];
    } else if (mode == Explore) {
        [sharePin removeFromSuperview];
        [leftButton setHidden:NO];
        [rightButton setHidden:NO];
        
        [saveButton setHidden:YES];
        [returnButton setHidden:YES];
        if ([layer isEqualToString:layersParkings] || [layer isEqualToString:layersWorkshops] || [layer isEqualToString:layersTips]) {
            [shareButton setHidden:![User userLoggedIn]];
        } else if ([layer isEqualToString:layersTrips]) {
            //[showListButton setHidden:NO];
        } else {
            [shareButton setHidden:YES];
            //[showListButton setHidden:YES];
        }
        [self.viewDeckController setRightController:defaultRightViewController];
        [self.viewDeckController setLeftController:defaultLeftViewController];
        [mapMessageView removeFromSuperview];
    } else if (mode == Detail) {
        [sharePin removeFromSuperview];
        [leftButton setHidden:YES];
        [rightButton setHidden:YES];
        [shareButton setHidden:YES];
        //[showListButton setHidden:YES];
        
        [saveButton setHidden:YES];
        [returnButton setHidden:YES];
        [self.viewDeckController setRightController:nil];
        [self.viewDeckController setLeftController:nil];
    }
    
    currentMode = mode;
}

/**
 *  Triggers a controlled fetch only if the map camera has moved more than x meters from the last position
 */
- (void) triggerControlledFetch:(CLLocationCoordinate2D)coordinate
{
    CLLocation *newCoord = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    if (mapLastCenteredAt != nil) {
        //CLLocationDistance dist = [mapLastCenteredAt distanceFromLocation:newCoord];
        //if (dist > 200 && !requestOngoing) {
            [companionObject fetchLayer:activeLayer];
        //} else {
        //}
    }
    mapLastCenteredAt = newCoord;
}

- (TripsManager*) tripsManager
{
    if (tripsManager == nil) {
        tripsManager = [[TripsManager alloc] initWithMapViewController:self];
    }
    
    return tripsManager;
}

@end
