//
//  ExploreViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "ExploreViewController.h"

#define marginUnit 20

@interface ExploreViewController () {
    BOOL drawerOpenning;
    MenuViewController *menu;
}

-(void) showMenu;

@end

@implementation ExploreViewController

GMSMapView *mapView;

- (id)init
{
    self = [super init];
    if (self) {
        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    }
    return self;
}

- (void) loadView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;

    // Load buttons
    UIImage *image = [UIImage imageNamed:@"menu_button.png"];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, [App viewBounds].size.height-image.size.height-marginUnit*2, image.size.width, image.size.height)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button.png"] forState:UIControlStateNormal];
    [self.view addSubview:menuButton];
    
    UIImage *shareImage = [UIImage imageNamed:@"share_button.png"];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-shareImage.size.width-marginUnit, [App viewBounds].size.height-image.size.height-marginUnit*2, shareImage.size.width, shareImage.size.height)];
    [shareButton setBackgroundImage:shareImage forState:UIControlStateNormal];
    [self.view addSubview:shareButton];
    
    UIImage *nearbyImage = [UIImage imageNamed:@"nearby_button.png"];

    UIButton *nearbyButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-nearbyImage.size.width-marginUnit-shareButton.frame.size.width-10, [App viewBounds].size.height-nearbyImage.size.height-marginUnit*2, nearbyImage.size.width, nearbyImage.size.height)];
    [nearbyButton setBackgroundImage:nearbyImage forState:UIControlStateNormal];
    [self.view addSubview:nearbyButton];

    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchDragOutside];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) showMenu {
    if ([self.viewDeckController leftController] == nil) {
        [self.viewDeckController setLeftController:[[MenuViewController alloc] init]];
    }
    if (!drawerOpenning) {
        drawerOpenning = YES;
        [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            drawerOpenning = NO;
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
