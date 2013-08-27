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
    
    CLLocation *mapLastCenteredAt;
}

- (void) selectedLayer:(id)layer;
- (void) showMainMenu;

- (void) toggleLayersMenu;
- (void) hideLayersMenu;
- (void) showLayersMenu;
- (void) fetchAndDisplayLayer:(NSString *)displayLayer;

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
    
    layersMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(-2, [App viewBounds].size.height, [App viewBounds].size.width+2, 100)];
    [layersMenu setBackgroundColor:[UIColor whiteColor]];
    [layersMenu.layer setCornerRadius:5];
    [layersMenu.layer setBorderColor:[UIColor colorWithHexString:@"d5e6f3"].CGColor];
    [layersMenu.layer setBorderWidth:0.5];
    
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
    //[layersMenu setPagingEnabled:YES];
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

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (![layersMenu isHidden]) {
        [self hideLayersMenu];
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
                                                         zoom:14];
    }
}

- (void) fetchAndDisplayLayer:(NSString *)displayLayer
{
    if ([[layersParkings stringByAppendingString:@"_layers"] isEqualToString:displayLayer]) {
        NSString *parkingsURL = [App urlForResource:@"parkings" withSubresource:@"get"];

        NSURL *url = [NSURL URLWithString:parkingsURL];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request setTag:1];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    // Parkings
    if ([request tag] == 1) {
        
    } else if([request tag] == 2) {
        
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
}

- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    CLLocation *newCoord = [[CLLocation alloc] initWithLatitude:[position targetAsCoordinate].latitude longitude:[position targetAsCoordinate].longitude];

    if (mapLastCenteredAt != NULL) {
        CLLocationDistance dist = [mapLastCenteredAt distanceFromLocation:newCoord];
        if (dist > 200) {
            [self fetchAndDisplayLayer:selectedLayer];
            NSLog(@"Fetching");
        } else {
            NSLog(@"Not fetching");
        }
    }
    mapLastCenteredAt = newCoord;
}

@end
