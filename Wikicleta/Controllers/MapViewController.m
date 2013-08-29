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
    UIScrollView *layersMenu;
    NSString *selectedLayer;
    NSDictionary *layersMenuList;
    BOOL firstLocationUpdateReceived;
    BOOL drawerOpenning;
    BOOL requestOngoing;
    CLLocation *mapLastCenteredAt;
    MarkerDetailsView *detailsView;
    
    BaseModel *currentlySelectedModel;
}

- (void) selectedLayer:(id)layer;
- (void) showMainMenu;

- (void) toggleLayersMenu;
- (void) hideLayersMenu;
- (void) showLayersMenu;
- (void) fetchAndDisplayLayer:(NSString *)displayLayer;
- (void) triggerControlledFetch:(CLLocationCoordinate2D)coordinate;
- (void) updateMapWithItems:(NSArray*)items;
- (void) buildViewForMarker:(GMSMarker*)marker;

- (void) showMoreInfo;
- (void) hideViewForMarker;
@end

@implementation MapViewController

GMSMapView *mapView;

- (void) loadView
{
    
    self.view = [[UIView alloc] initWithFrame:[App viewBounds]];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    mapView.myLocationEnabled = YES;
    [self.view addSubview:mapView];
    
    [mapView setDelegate:self];
    
    
    UIImage *menuImage = [UIImage imageNamed:@"menu_button.png"];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, [App viewBounds].size.height-menuImage.size.height-marginUnit*2,
                                                                      menuImage.size.width, menuImage.size.height)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button.png"] forState:UIControlStateNormal];
    [self.view addSubview:menuButton];
    
    UIImage *shareImage = [UIImage imageNamed:@"share_button.png"];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-shareImage.size.width-marginUnit,
                                                                       [App viewBounds].size.height-shareImage.size.height-marginUnit*2,
                                                                       shareImage.size.width, shareImage.size.height)];
    [shareButton setBackgroundImage:shareImage forState:UIControlStateNormal];
    [self.view addSubview:shareButton];
    
    UIImage *nearbyImage = [UIImage imageNamed:@"layer_button.png"];
    
    UIButton *layersButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-nearbyImage.size.width-marginUnit-shareButton.frame.size.width-10, [App viewBounds].size.height-nearbyImage.size.height-marginUnit*2, nearbyImage.size.width, nearbyImage.size.height)];
    [layersButton setBackgroundImage:nearbyImage forState:UIControlStateNormal];
    [self.view addSubview:layersButton];
    
    [layersButton addTarget:self action:@selector(toggleLayersMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchDragOutside];
    [menuButton addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchUpInside];
    
    detailsView = [[[NSBundle mainBundle] loadNibNamed:@"MarkerDetailsView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:detailsView];
    [detailsView setFrame:CGRectMake(detailsView.frame.origin.x,
                                     self.view.frame.size.height, detailsView.frame.size.width, detailsView.frame.size.height)];
    [detailsView setHidden:YES];
    
    [detailsView.moreInfoButton addTarget:self
                                   action:@selector(showMoreInfo)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [detailsView.hideButton addTarget:self
                               action:@selector(hideViewForMarker)
                     forControlEvents:UIControlEventTouchUpInside];
    
    layersMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(-2, [App viewBounds].size.height, [App viewBounds].size.width+2, 100)];
    [layersMenu setBackgroundColor:[UIColor whiteColor]];
    
    /*UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, layersMenu.frame.size.width-20, 30)];
    [title setFont:[UIFont fontWithName:@"Gotham Rounded" size:18]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor colorWithHexString:@"1f3a50"]];
    [title setText:NSLocalizedString(@"layers_menu_title", nil)];
    [layersMenu addSubview:title];*/
    
    NSArray *layers = [NSArray arrayWithObjects:layersParkings, layersRoutes, layersBicycleLanes, layersWorkshops, layersBicycleSharings, layersTips, nil];
    
    int i = 0;
    NSMutableDictionary *layersDict = [[NSMutableDictionary alloc] init];
    for (NSString *layer in layers) {
        
        UIButtonWithLabel *buttonLabel = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(i*100, 8, 100, 50)
                                                                   withName:[layer stringByAppendingString:@"_layers"]
                                                               withTextSeparation:50];
        [layersMenu addSubview:buttonLabel];
        [buttonLabel setSelected:NO];

        [buttonLabel.button addTarget:self action:@selector(selectedLayer:) forControlEvents:UIControlEventTouchUpInside];
        [layersDict setValue:buttonLabel forKey:buttonLabel.name];
        i += 1;
    }
    
    layersMenuList = [NSDictionary dictionaryWithDictionary:layersDict];
    layersMenu.contentSize = CGSizeMake(100 * layers.count, layersMenu.frame.size.height);
    [layersMenu setContentInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [layersMenu setContentOffset:CGPointMake(-10, 0)];
    [self.view addSubview:layersMenu];
    [layersMenu setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void) selectedLayer:(id)layer
{
    UIButtonWithLabel *buttonSelected = ((UIButtonWithLabel*) [layer superview]);
    UIButtonWithLabel *previouslySelected = [layersMenuList objectForKey:selectedLayer];

    [previouslySelected setSelected:!(previouslySelected != NULL)];
    [buttonSelected setSelected:YES];
    selectedLayer = buttonSelected.name;

    dispatch_after(1, dispatch_get_main_queue(), ^{
        [self hideLayersMenu];
    });
    
    [self fetchAndDisplayLayer:selectedLayer];
}

- (void) showMainMenu {
    
    if ([self.viewDeckController leftController] == nil) {
        [self.viewDeckController setLeftController:[[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil]];
    }

    if (!drawerOpenning) {
        drawerOpenning = YES;
        [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            drawerOpenning = NO;
        }];
    }
}

- (void) showLayersMenu
{
    [layersMenu setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [layersMenu setTransform:CGAffineTransformMakeTranslation(0, -100)];
    }];

}

- (void) toggleLayersMenu
{
    if ([layersMenu isHidden]) {
        [self showLayersMenu];
    } else {
        [self hideLayersMenu];
    }
}

- (void) hideLayersMenu
{
    [UIView animateWithDuration:0.3 animations:^{
        [layersMenu setTransform:CGAffineTransformMakeTranslation(0, 100)];
    } completion:^(BOOL finished) {
        [layersMenu setHidden:YES];
    }];
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
                                                         zoom:14];
    }
}

- (void) fetchAndDisplayLayer:(NSString *)displayLayer
{
    // bottom == near
    CLLocationCoordinate2D sw = mapView.projection.visibleRegion.nearLeft;
    NSString *swString = [NSString stringWithFormat:@"%f,%f", sw.latitude, sw.longitude];
    // top == far
    CLLocationCoordinate2D ne = mapView.projection.visibleRegion.farRight;
    NSString *neString = [NSString stringWithFormat:@"%f,%f", ne.latitude, ne.longitude];

    if ([[layersParkings stringByAppendingString:@"_layers"] isEqualToString:displayLayer]) {
        NSString *parkingsURL = [App urlForResource:layersParkings withSubresource:@"get"];
        parkingsURL = [parkingsURL stringByAppendingString:@"viewport[sw]=%@&viewport[ne]=%@"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:parkingsURL, swString, neString]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request setTag:1];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    requestOngoing = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *responseObject = [jsonParser objectWithString:[request responseString] error:nil];
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            NSArray *jsonObjects = [responseObject objectForKey:layersParkings];
            // Parkings
            if ([request tag] == 1) {
                [Parking buildFrom:jsonObjects];
                [self updateMapWithItems:[[Parking parkingsLoaded] allValues]];
            } else if([request tag] == 2) {
                
            }
        }

    });

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void) updateMapWithItems:(NSArray*)items {
    for (BaseModel *model in items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([mapView.projection containsCoordinate:model.coordinate]) {
                if (model.marker.map == nil) {
                    model.marker.map = mapView;
                }
            } else {
                model.marker.map = nil;
            }
        });

    }
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (![layersMenu isHidden]) {
        [self hideLayersMenu];
    }
}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [self buildViewForMarker:marker];
    return YES;
}

- (void) showMoreInfo {
    [self presentModalViewController:[[MarkerDetailsExtendedViewController alloc]
                                      initWithNibName:@"MarkerDetailsExtendedViewController"
                                      bundle:nil] animated:YES];
}

- (void) hideViewForMarker {
    currentlySelectedModel = NULL;
    [UIView animateWithDuration:0.3 animations:^{
        [detailsView setTransform:CGAffineTransformMakeTranslation(0, detailsView.frame.size.height)];
    } completion:^(BOOL finished) {
        [detailsView setHidden:YES];
    }];
    [mapView animateToZoom:11];
}

- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [self triggerControlledFetch:[position targetAsCoordinate]];
}

/**
 *  Builds the view for a selected map marker
 */
- (void) buildViewForMarker:(GMSMarker*)marker
{
    BaseModel *newModel = ((WikiMarker*) marker).model;
    
    // Update is the model is different from the current one
    if (currentlySelectedModel == NULL || [newModel identifier] != [currentlySelectedModel identifier]) {
        currentlySelectedModel = newModel;

        [detailsView.title setText:newModel.title];
        [detailsView.subtitle setText:[newModel.subtitle uppercaseString]];
        [detailsView.iconLabel setImage:[newModel image]];
        
        [detailsView loadDefaults];
        [mapView animateToLocation:newModel.coordinate];
        [mapView animateToZoom:16];
        
        [detailsView setHidden:NO];
        [self.view bringSubviewToFront:detailsView];
        [UIView animateWithDuration:0.5 animations:^{
            [detailsView setTransform:CGAffineTransformMakeTranslation(0, -detailsView.frame.size.height)];
        }];
    }
    
}


/**
 *  Triggers a controlled fetch only if the map camera has moved more than x meters from the last position
 */
- (void) triggerControlledFetch:(CLLocationCoordinate2D)coordinate
{
    CLLocation *newCoord = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    if (mapLastCenteredAt != NULL) {
        CLLocationDistance dist = [mapLastCenteredAt distanceFromLocation:newCoord];
        if (dist > 200 && !requestOngoing) {
            requestOngoing = YES;
            [self fetchAndDisplayLayer:selectedLayer];
        } else {
        }
    }
    mapLastCenteredAt = newCoord;
}

@end
