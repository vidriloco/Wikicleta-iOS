//
//  ExploreViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "MapViewController.h"
#define marginUnit 20

@interface MapViewController () {
    BOOL firstLocationUpdateReceived;
    BOOL leftDrawerOpenning;
    BOOL rightDrawerOpenning;
    BOOL requestOngoing;
    
    BOOL mapControlsVisible;
    BOOL viewAttached;
    
    CLLocation *mapLastCenteredAt;
    id detailsView;
    id <ModelHumanizer> currentlySelectedModel;
    GMSPolyline *selectedRoutePath;
    
    NSString *activeLayer;
    UIButton *rightButton;
    UIButton *leftButton;
    
    UIButton *saveButton;
    UIButton *returnButton;
    UIButton *shareButton;
        
    GMSCameraPosition *lastCamera;
    
    MapMode currentMode;
    UIImageView * sharePin;
    POIChooserOverlayView *poiView;
}

- (void) openLeftDock;
- (void) openRightDock;

- (void) fetchLayer:(NSString *)displayLayer;
- (void) triggerControlledFetch:(CLLocationCoordinate2D)coordinate;
- (void) updateMapWithItems:(NSArray*)items;
- (void) addViewForMarker:(GMSMarker*)marker;

- (void) hideViewForMarker;
- (void) toggleMapControls;

- (void) toggleFavorite:(id)sender;
- (void) showDetails:(id)sender;
- (void) loadMapButtons;

- (void) drawPolyline:(NSArray*) polyline;
- (void) clearPolyline;
- (void) moveToMarker:(id)selector;
- (void) toggleAttachView:(id)selector;

- (void) toggleShareControls;
- (void) presentShareSelectorView;
- (void) hideChooserMenu;
- (void) presentControllerForPOI:(id)selector;
@end

@implementation MapViewController

@synthesize rightHelperController;

GMSMapView *mapView;

- (void) loadView
{
    
    self.view = [[UIView alloc] initWithFrame:[App viewBounds]];
    lastCamera = [GMSCameraPosition cameraWithLatitude:-33.86
                                             longitude:151.20
                                                  zoom:minZoom];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:lastCamera];
    mapView.myLocationEnabled = YES;
    [self.view addSubview:mapView];
    
    [mapView setDelegate:self];
    
    mapControlsVisible = NO;
    viewAttached = NO;
    [self loadMapButtons];
    [self toggleMapControls];
    currentMode = Find;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [mapView removeObserver:self forKeyPath:@"myLocation"];
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMapButtons
{
    // Left menu button
    UIImage *menuImage = [UIImage imageNamed:@"menu_button.png"];
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [App viewBounds].size.height-menuImage.size.height-marginUnit*2.5,
                                                                      menuImage.size.width, menuImage.size.height)];
    [leftButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    [leftButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchDragOutside];
    [leftButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchUpInside];
    
    // Right layers button
    UIImage *layerImage  = [UIImage imageNamed:@"layer_button.png"];
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-layerImage.size.width+5, [App viewBounds].size.height-layerImage.size.height-marginUnit*2.5, layerImage.size.width, layerImage.size.height)];
    [self.view addSubview:rightButton];
    
    [rightButton addTarget:self action:@selector(openRightDock) forControlEvents:UIControlEventTouchDragOutside];
    [rightButton addTarget:self action:@selector(openRightDock) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:layerImage forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    // Share button (disabled now)
    UIImage *shareImage = [UIImage imageNamed:@"share_button.png"];
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-shareImage.size.width-marginUnit*2,
                                                                       [App viewBounds].size.height-shareImage.size.height-marginUnit*2.5,
                                                                       shareImage.size.width, shareImage.size.height)];
    [shareButton setBackgroundImage:shareImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(toggleShareControls) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:shareButton];
    
    UIImage *saveImage = [UIImage imageNamed:@"save_button.png"];
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-saveImage.size.width-10,
                                                             [App viewBounds].size.height-saveImage.size.height-marginUnit*2.5,
                                                             saveImage.size.width, saveImage.size.height)];
    [saveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(presentShareSelectorView) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setHidden:YES];
    [self.view addSubview:saveButton];
    
    UIImage *returnImage = [UIImage imageNamed:@"return_button.png"];
    returnButton = [[UIButton alloc] initWithFrame:CGRectMake(saveButton.frame.origin.x-returnImage.size.width-10,
                                                            [App viewBounds].size.height-returnImage.size.height-marginUnit*2.5,
                                                            returnImage.size.width, returnImage.size.height)];
    [returnButton setBackgroundImage:returnImage forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(toggleShareControls) forControlEvents:UIControlEventTouchUpInside];
    [returnButton setHidden:YES];
    [self.view addSubview:returnButton];
}

- (void) openLeftDock {
    
    if ([self.viewDeckController leftController] == nil) {
        [self.viewDeckController setLeftController:[[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil]];
    }

    if (!leftDrawerOpenning) {
        leftDrawerOpenning = YES;
        [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            leftDrawerOpenning = NO;
        }];
    }
}

- (void) openRightDock
{

    if ([self.viewDeckController rightController] == nil) {
        LayersChooserViewController *layersViewController = [[LayersChooserViewController alloc] init];
        layersViewController.delegate = self;
        [self.viewDeckController setRightController:layersViewController];
    }
    
    if (!rightDrawerOpenning) {
        rightDrawerOpenning = YES;
        [self.viewDeckController toggleRightViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            rightDrawerOpenning = NO;
        }];
    }
}

- (void) toggleMapControls
{
    if (mapControlsVisible) {
        [leftButton setHidden:YES];
        [rightButton setHidden:YES];
        mapControlsVisible = NO;
    } else {
        [leftButton setHidden:NO];
        [rightButton setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [leftButton setAlpha:1];
            [rightButton setAlpha:1];
        } completion:^(BOOL finished) {
            mapControlsVisible = YES;
        }];
    }
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

- (void) fetchLayer:(NSString *)displayLayer
{
    if (displayLayer == nil || detailsView != nil) {
        return;
    }

    requestOngoing = YES;

    // bottom == near
    CLLocationCoordinate2D sw = mapView.projection.visibleRegion.nearLeft;
    NSString *swString = [NSString stringWithFormat:@"%f,%f", sw.latitude, sw.longitude];
    // top == far
    CLLocationCoordinate2D ne = mapView.projection.visibleRegion.farRight;
    NSString *neString = [NSString stringWithFormat:@"%f,%f", ne.latitude, ne.longitude];

    NSString *resourceURL = NULL;
    if ([[layersParkings stringByAppendingString:@"_layers"] isEqualToString:displayLayer]) {
        resourceURL = [[App urlForResource:layersParkings withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([[layersTips stringByAppendingString:@"_layers"] isEqualToString:displayLayer]) {
        resourceURL = [[App urlForResource:layersTips withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([[layersWorkshops stringByAppendingString:@"_layers"] isEqualToString:displayLayer]) {
        resourceURL = [[App urlForResource:layersWorkshops withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([[layersBicycleSharings stringByAppendingString:@"_layers"] isEqualToString:displayLayer]) {
        resourceURL = [[App urlForResource:layersBicycleSharings withSubresource:@"get"] stringByAppendingString:viewportParams];
    } else if ([[layersRoutes stringByAppendingString:@"_layers"] isEqualToString:displayLayer]) {
        resourceURL = [[App urlForResource:layersRoutes withSubresource:@"get"] stringByAppendingString:viewportParams];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:resourceURL, swString, neString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            // Parkings
            if ([displayLayer isEqualToString:[layersParkings stringByAppendingString:@"_layers"]]) {
                NSArray *jsonObjects = [response objectForKey:layersParkings];
                [Parking buildFrom:jsonObjects];
                [self updateMapWithItems:[[Parking parkingsLoaded] allValues]];
            // Tips
            } else if([displayLayer isEqualToString:[layersTips stringByAppendingString:@"_layers"]]) {
                NSArray *jsonObjects = [response objectForKey:layersTips];
                [Tip buildFrom:jsonObjects];
                [self updateMapWithItems:[[Tip tipsLoaded] allValues]];
            }
            // Workshops
            else if ([displayLayer isEqualToString:[layersWorkshops stringByAppendingString:@"_layers"]]) {
                NSArray *jsonObjects = [response objectForKey:layersWorkshops];
                [Workshop buildFrom:jsonObjects];
                [self updateMapWithItems:[[Workshop workshopsLoaded] allValues]];
            }
            // Cyclestations
            else if ([displayLayer isEqualToString:[layersBicycleSharings stringByAppendingString:@"_layers"]]) {
                NSArray *jsonObjects = [response objectForKey:layersBicycleSharings];
                [Cyclestation buildFrom:jsonObjects];
                [self updateMapWithItems:[[Cyclestation cyclestationsLoaded] allValues]];
            }
            // Routes
            else if ([displayLayer isEqualToString:[layersRoutes stringByAppendingString:@"_layers"]]) {
                NSArray *jsonObjects = [response objectForKey:layersRoutes];
                [Route buildFrom:jsonObjects];
                [self updateMapWithItems:[[Route routesLoaded] allValues]];
            }
        }
            
        requestOngoing = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        requestOngoing = NO;
    }];
}

- (void) updateMapWithItems:(NSArray*)items {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (BaseModel *model in items) {
            if ([mapView.projection containsCoordinate:model.coordinate]) {
                if (model.marker.map == nil) {
                    model.marker.map = mapView;
                }
            } else {
                model.marker.map = nil;
            }
        }
    });
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (currentlySelectedModel != nil && !viewAttached) {
        [self hideViewForMarker];
        [self toggleMapControls];
    }
}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if (!viewAttached) {
        [self addViewForMarker:marker];
    }
    return YES;
}

- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
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
    selectedRoutePath = newRoutePath;
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedRoutePath.map = mapView;
    });
}

- (void) clearPolyline
{
    if (selectedRoutePath != nil) {
        selectedRoutePath.map = nil;
        selectedRoutePath = nil;
    }
}

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

- (void) toggleAttachView:(id)selector
{
    if ([currentlySelectedModel isKindOfClass:[Route class]]) {
        UIButton *button = (UIButton*) selector;
        UIView *viewC = (UIButton*) detailsView;
        
        
        if ([selector tag] == 0) {
            [button setTitle:NSLocalizedString(@"route_detach_view", nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"attach_icon.png"] forState:UIControlStateNormal];

            [button setAlpha:1];
            [UIView animateWithDuration:0.3 animations:^{
                [viewC setFrame:CGRectMake(viewC.frame.origin.x, viewC.frame.origin.y+viewC.frame.size.height-55, viewC.frame.size.width, viewC.frame.size.height)];
            } completion:nil];
            [button setTag:1];
            viewAttached = YES;
        } else {
            [button setTitle:NSLocalizedString(@"route_attach_view", nil) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"attach_icon_h.png"] forState:UIControlStateNormal];
            [button setAlpha:0.5];
            [UIView animateWithDuration:0.3 animations:^{
                [viewC setFrame:CGRectMake(viewC.frame.origin.x, viewC.frame.origin.y-viewC.frame.size.height+55, viewC.frame.size.width, viewC.frame.size.height)];
            } completion:nil];
            [button setTag:0];
            viewAttached = NO;
        }
    }
}

- (void) hideViewForMarker {
    [self clearPolyline];
    
    if ([currentlySelectedModel isKindOfClass:[Route class]]) {
        [[(Route*) currentlySelectedModel complementaryMarker] setMap:nil];
    }
    
    currentlySelectedModel = nil;

    [UIView animateWithDuration:0.3 animations:^{
        [(UIView*) detailsView setTransform:CGAffineTransformMakeTranslation(0, [detailsView frame].size.height)];
    } completion:^(BOOL finished) {
        [detailsView removeFromSuperview];
        detailsView = nil;
    }];
    [mapView setCamera:lastCamera];
    [self toggleMapControls];
    
    [[self viewDeckController] setRightController:rightHelperController];
}

- (void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    [self triggerControlledFetch:[position targetAsCoordinate]];
}

- (void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self toggleShareControls];
}

/**
 *  Builds the view for a selected map marker
 */
- (void) addViewForMarker:(GMSMarker*)marker
{
    if (detailsView != nil) {
        [detailsView removeFromSuperview];
        detailsView = nil;
    }
    
    if (currentlySelectedModel == nil) {
        [self toggleMapControls];
    }
    
    currentlySelectedModel = (id <ModelHumanizer>) ((WikiMarker*) marker).model;
    
    if ([currentlySelectedModel isKindOfClass:[Cyclestation class]]) {
        // Build view from XIB file
        detailsView = [[[NSBundle mainBundle] loadNibNamed:@"CyclestationUIView" owner:self options:nil] objectAtIndex:0];
        
        TTTLocationFormatter *locationFormatter = [[TTTLocationFormatter alloc] init];
        
        CLLocation *markerLocation = [[CLLocation alloc]
                              initWithLatitude:marker.position.latitude
                              longitude:marker.position.longitude];
        
        Cyclestation *cycleStation = (Cyclestation*) currentlySelectedModel;

        NSString *distance = [locationFormatter stringFromDistanceAndBearingFromLocation:mapView.myLocation toLocation:markerLocation];
        [[detailsView rightBottomLabel] setText:[NSLocalizedString(@"distance_at", nil) stringByAppendingString:distance]];
        [[(CyclestationUIView*) detailsView availableBikesNumberLabel] setText:[NSString stringWithFormat:@"%d", [cycleStation.availableBikes intValue]]];
        [[(CyclestationUIView*) detailsView availableBikesTextLabel] setText:NSLocalizedString(@"bikes_available", nil)];
        [[(CyclestationUIView*) detailsView availableSlotsNumberLabel] setText:[NSString stringWithFormat:@"%d", [cycleStation.availableSlots intValue]]];
        [[(CyclestationUIView*) detailsView availableSlotsTextLabel] setText:NSLocalizedString(@"slots_available", nil)];

    } else if ([currentlySelectedModel isKindOfClass:[Route class]]) {
        // Build view from XIB file
        detailsView = [[[NSBundle mainBundle] loadNibNamed:@"RouteUIView" owner:self options:nil] objectAtIndex:0];
        
        Route *route = (Route*) currentlySelectedModel;
        
        [[(RouteUIView*) detailsView titleLabel] setText:[route title]];
        [[(RouteUIView*) detailsView subtitleLabel] setText:[route subtitle]];
        
        [[(RouteUIView*) detailsView distanceNumberLabel] setText:[route distanceString]];
        [[(RouteUIView*) detailsView distanceWordsLabel] setText:@"KM"];
        
        [[[(RouteUIView*) detailsView goToButton] titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:12]];
        [[[(RouteUIView*) detailsView goToButton] titleLabel] setTextColor:[LookAndFeel orangeColor]];
        [[[(RouteUIView*) detailsView goToButton] titleLabel] setText:NSLocalizedString(@"route_to_start", nil)];
        [[(RouteUIView*) detailsView goToButton] addTarget:self action:@selector(moveToMarker:) forControlEvents:UIControlEventTouchUpInside];
        
        [[[(RouteUIView*) detailsView attachButton] titleLabel] setFont:[LookAndFeel defaultFontBookWithSize:12]];
        [[[(RouteUIView*) detailsView attachButton] titleLabel] setTextColor:[LookAndFeel orangeColor]];
        [[[(RouteUIView*) detailsView attachButton] titleLabel] setText:NSLocalizedString(@"route_attach_view", nil)];
        [[(RouteUIView*) detailsView attachButton] addTarget:self action:@selector(toggleAttachView:) forControlEvents:UIControlEventTouchUpInside];
        
        [[(RouteUIView*) detailsView moreDetailsButton] addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];

        
        NSString *remoteRouteId = [NSString stringWithFormat:@"%d", [(NSNumber*)[route remoteId] intValue]];
        NSString *resourceURL = [[App urlForResource:layersRoutes withSubresource:@"show"] stringByReplacingOccurrencesOfString:@":id" withString:remoteRouteId];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:resourceURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
            if ([[response objectForKey:@"success"] boolValue]) {
                NSArray *path = [[response objectForKey:@"route"] objectForKey:@"path"];
                [self drawPolyline:path];
                [[route complementaryMarker] setMap:mapView];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } else {
        // Build view from XIB file
        detailsView = [[[NSBundle mainBundle] loadNibNamed:@"MarkerInfoUIView" owner:self options:nil] objectAtIndex:0];
        [[detailsView rightBottomLabel] setText:[currentlySelectedModel extraAnnotation]];

        [[detailsView favoriteButton] addTarget:self action:@selector(toggleFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [[detailsView moreDetailsButton] addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSString *updatedAtString = [timeIntervalFormatter stringForTimeInterval:[currentlySelectedModel.updatedAt timeIntervalSinceNow]];
    [[detailsView leftBottomLabel] setText:[NSLocalizedString(@"updated_at", nil) stringByAppendingString:updatedAtString]];

    [[detailsView titleLabel] setText:currentlySelectedModel.title];
    [[detailsView subtitleLabel] setText:currentlySelectedModel.subtitle.uppercaseString];
    
    [self.view addSubview:detailsView];
    [detailsView setFrame:CGRectMake(0,
                                     self.view.frame.size.height, [detailsView frame].size.width, [detailsView frame].size.height)];
    [detailsView setHidden:YES];
    [detailsView stylizeView];

    [detailsView setHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        [(UIView*) detailsView setTransform:CGAffineTransformMakeTranslation(0, -[detailsView frame].size.height)];
    } completion:nil];
    
    lastCamera = [[mapView camera] copy];
    [mapView setCamera:[[GMSCameraPosition alloc] initWithTarget:marker.position zoom:poiDetailedZoom bearing:mapView.camera.bearing viewingAngle:mapView.camera.viewingAngle]];
    
    // Deactivate right controller
    
    self.rightHelperController = [[self viewDeckController] rightController];
    [[self viewDeckController] setRightController:nil];
}

- (void) toggleFavorite:(id)sender {
    NSLog(@"Favorite for");

}

- (void) toggleShareControls
{
    if (sharePin == nil) {
        sharePin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wikicleta_pin.png"]];
        [sharePin setFrame:CGRectMake([App viewBounds].size.width/2-sharePin.frame.size.width/2,
                                 [App viewBounds].size.height/2-sharePin.frame.size.height/2,
                                 sharePin.frame.size.width, sharePin.frame.size.height)];
    }
    if (currentMode == Find) {
        currentMode = Share;
        [self.view addSubview:sharePin];
        [saveButton setHidden:NO];
        [returnButton setHidden:NO];
        [shareButton setHidden:YES];
        [self toggleMapControls];
    } else {
        currentMode = Find;
        [sharePin removeFromSuperview];
        [saveButton setHidden:YES];
        [returnButton setHidden:YES];
        [shareButton setHidden:NO];
        [self toggleMapControls];
    }
}

- (void) showDetails:(id)sender {
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

- (void) presentShareSelectorView
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
    [saveButton setHidden:NO];
    [returnButton setHidden:NO];
    [poiView removeFromSuperview];
}

- (void) presentControllerForPOI:(id)selector
{
    if ([selector tag] == 0) {
        NSLog(@"Workshops");
    } else if ([selector tag] == 1) {
        NSLog(@"Parkings");
    } else if ([selector tag] == 2) {
        NSLog(@"Tips");
    }
}

/**
 *  Triggers a controlled fetch only if the map camera has moved more than x meters from the last position
 */
- (void) triggerControlledFetch:(CLLocationCoordinate2D)coordinate
{
    CLLocation *newCoord = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    if (mapLastCenteredAt != nil) {
        CLLocationDistance dist = [mapLastCenteredAt distanceFromLocation:newCoord];
        if (dist > 200 && !requestOngoing) {
            [self fetchLayer:activeLayer];
        } else {
        }
    }
    mapLastCenteredAt = newCoord;
}

- (void) updateMapWithLayersSelected:(NSString*)layerSelected {
    [mapView clear];
    activeLayer = layerSelected;
    [self fetchLayer:activeLayer];
}

@end
