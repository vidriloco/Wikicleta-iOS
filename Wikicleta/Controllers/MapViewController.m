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
    UIView *layersMenu;
    NSString *selectedLayer;
    NSDictionary *layersMenuList;
    BOOL firstLocationUpdateReceived;
    BOOL drawerOpenning;
}

- (void) selectedLayer:(id)layer;
- (void) showLayersMenu;
- (void) showMainMenu;
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
    
    [layersButton addTarget:self action:@selector(showLayersMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchDragOutside];
    [menuButton addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchUpInside];
    
    layersMenu = [[UIView alloc] initWithFrame:CGRectMake(20, 40, [App viewBounds].size.width-40, 250)];
    [layersMenu setBackgroundColor:[UIColor whiteColor]];
    [layersMenu.layer setCornerRadius:5];
    [layersMenu.layer setBorderColor:[UIColor colorWithHexString:@"d5e6f3"].CGColor];
    [layersMenu.layer setBorderWidth:0.5];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, layersMenu.frame.size.width-20, 30)];
    [title setFont:[UIFont fontWithName:@"Gotham Rounded" size:18]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor colorWithHexString:@"1f3a50"]];
    [title setText:NSLocalizedString(@"layers_menu_title", nil)];
    [layersMenu addSubview:title];
    
    NSArray *layers = [NSArray arrayWithObjects:@"parkings", @"bike_sharings", @"tips", @"workshops", @"routes", nil];
    
    int j = 0;
    int i = 0;
    
    NSMutableDictionary *layersDict = [[NSMutableDictionary alloc] init];
    for (NSString *layer in layers) {
        if (i * 95 > layersMenu.frame.size.width) {
            i = 0;
            j += 1;
        }
        
        CGFloat xOrigin = i * 95;
        CGFloat yOrigin = j * 100;

        
        UIButtonWithLabel *buttonLabel = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(xOrigin+20, yOrigin+60, 50, 50)
                                                                   withName:[layer stringByAppendingString:@"_layers"]
                                                               withTextSeparation:50];
        [layersMenu addSubview:buttonLabel];
        [buttonLabel setSelected:NO];

        [buttonLabel.button addTarget:self action:@selector(selectedLayer:) forControlEvents:UIControlEventTouchUpInside];
        [layersDict setValue:buttonLabel forKey:buttonLabel.name];
        
        i += 1;
    }
    layersMenuList = [NSDictionary dictionaryWithDictionary:layersDict];

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
    [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationCurveLinear animations:^{
        [self showLayersMenu];
    } completion:nil];
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
    if ([layersMenu isHidden]) {
        [layersMenu setAlpha:0];
        [layersMenu setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [layersMenu setAlpha:1];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [layersMenu setAlpha:0];
        } completion:^(BOOL finished) {
            [layersMenu setHidden:YES];
        }];
    }
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (![layersMenu isHidden]) {
        [layersMenu setHidden:YES];
    }
}

- (void) mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (![layersMenu isHidden]) {
        [layersMenu setHidden:YES];
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

@end
