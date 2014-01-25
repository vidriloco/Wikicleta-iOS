//
//  CycleprintsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/23/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "CycleprintsViewController.h"

@interface CycleprintsViewController () {
    GMSCameraPosition *lastCamera;
    GMSMapView *mapView;
    MBProgressHUD *hud;
    GMSPolyline *linePath;
    NSMutableArray *markers;
    
    MapZoom nextMapZoom;
}

- (void) openLeftDock;
- (void) attemptToSynchronize;
- (void) drawInstants;
@end

@implementation CycleprintsViewController

@synthesize distanceTextLabel, distanceValueLabel, speedTextLabel, speedValueLabel, noteSubtitleLabel, noteTitleLabel, displayLeftMenuButton, statsContainerView, messagesContainerView, locationButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lastCamera = [GMSCameraPosition cameraWithLatitude:19.343 longitude:-99.112 zoom:mediumZoom];
        UIImage *locationImage = [UIImage imageNamed:@"compass_disabled_button.png"];
        locationButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-locationImage.size.width-10, [App viewBounds].size.height-locationImage.size.height-marginUnit*2.5, locationImage.size.width, locationImage.size.height)];
        [locationButton setBackgroundImage:locationImage forState:UIControlStateNormal];
        [locationButton addTarget:self action:@selector(showMyLocationOnMap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:locationButton];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocationManager sharedInstance] setDelegate:self];

    [[self.navigationController viewDeckController] setDelegate:self];
    [[self.navigationController viewDeckController] setRightController:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attemptToSynchronize)];
    [gestureRecognizer setNumberOfTapsRequired:1];
    [[self messagesContainerView] addGestureRecognizer:gestureRecognizer];

    if (![[LocationManager sharedInstance] active] && ![Settings settingHoldsTrue:kDisablePedalPowerMessage]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"suggestion_message", nil)
                                                        message:NSLocalizedString(@"get_the_best_from_cycleprints", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"dont_show_again", nil) otherButtonTitles:NSLocalizedString(@"accept", nil), nil];
        [alert show];
    }
    
    if ([[Instant allRecords] count] > 10) {
        [[self messagesContainerView] setHidden:YES];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [distanceValueLabel setFont:[LookAndFeel defaultFontBoldWithSize:35]];
    [speedValueLabel setFont:[LookAndFeel defaultFontBoldWithSize:35]];
    [distanceValueLabel setTextColor:[LookAndFeel blueColor]];
    [speedValueLabel setTextColor:[LookAndFeel blueColor]];
    
    [distanceTextLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [speedTextLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [distanceTextLabel setTextColor:[LookAndFeel orangeColor]];
    [speedTextLabel setTextColor:[LookAndFeel orangeColor]];
    
    [noteTitleLabel setFont:[LookAndFeel defaultFontBookWithSize:18]];
    [noteTitleLabel setTextColor:[UIColor whiteColor]];
    
    [noteSubtitleLabel setFont:[LookAndFeel defaultFontLightWithSize:15]];
    [noteSubtitleLabel setTextColor:[UIColor whiteColor]];
    
    UIImage *menuImage = [UIImage imageNamed:@"menu_button.png"];
    displayLeftMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [App viewBounds].size.height-menuImage.size.height-20*2.5,
                                                                       menuImage.size.width, menuImage.size.height)];
    [displayLeftMenuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [self.view addSubview:displayLeftMenuButton];
    [displayLeftMenuButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchDragOutside];
    [displayLeftMenuButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchUpInside];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:lastCamera];
    mapView.myLocationEnabled = YES;
    [mapView setDelegate:self];
    [self.view addSubview:mapView];
    [self.view bringSubviewToFront:statsContainerView];
    [self.view bringSubviewToFront:messagesContainerView];
    [self.view bringSubviewToFront:displayLeftMenuButton];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    [hud setHidden:NO];
    
    [self fetchCycleprints];
}

/*
 *  Sets a Left Dock UIViewController if not set, and then opens the leftview
 */
- (void) openLeftDock {
    [self.viewDeckController openLeftViewAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [Settings updateSetting:kDisablePedalPowerMessage withObject:@"True"];
    }
}

- (void) attemptToSynchronize
{
    hud.labelText = NSLocalizedString(@"syncing_cycleprints", nil);
    [hud setHidden:NO];
    [Instant uploadStalled:^{
        [hud setHidden:YES];
        [messagesContainerView setHidden:YES];
    }];
}

- (void) fetchCycleprints
{
    hud.labelText = NSLocalizedString(@"fetching_cycleprints", nil);

    NSString *url = [App urlForResource:@"instants" withSubresource:@"get" andReplacementSymbol:@":user_id" withReplacementValue:[NSString stringWithFormat:@"%d", [[User currentUser].identifier intValue]]];
    url = [url stringByReplacingOccurrencesOfString:@":range" withString:@"today"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            [Instant buildFrom:[response objectForKey:@"instants"]];
            
            float speed = [[[response objectForKey:@"stats"] objectForKey:@"speed"] floatValue];
            float distance = [[[response objectForKey:@"stats"] objectForKey:@"distance"] floatValue];
            
            [speedValueLabel setText:[NSString stringWithFormat:@"%0.2f", speed]];
            [distanceValueLabel setText:[NSString stringWithFormat:@"%0.2f", distance]];

            [self drawInstants];
        }
        [hud setHidden:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud setHidden:YES];
    }];
}


- (void) drawInstants
{
    if (linePath != nil) {
        [linePath setMap:nil];
    }
    
    if (markers != NULL) {
        for (GMSMarker *marker in markers) {
            [marker setMap:nil];
        }
    }
    markers = [NSMutableArray array];
    
    GMSMutablePath *path = [GMSMutablePath path];
    for (Instant *instant in [Instant remoteInstants]) {
        float lat = [instant.latitude floatValue];
        float lon = [instant.longitude floatValue];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);

        [path addCoordinate:position];
        
        WikiMarker *marker = [[WikiMarker alloc] init];
        marker.model = instant;
        marker.map = mapView;
        marker.icon = [instant markerIcon];
        [markers addObject:marker];
    }
    
    linePath = [GMSPolyline polylineWithPath:path];
    linePath.strokeColor = [LookAndFeel greenColor];
    linePath.strokeWidth = 3;
    linePath.geodesic = YES;
    [linePath setMap:mapView];
}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([[(WikiMarker*) marker model] isKindOfClass:[Instant class]]) {
        WikiMarker *markerNew = (WikiMarker*) marker;
        Instant *instant = (Instant*) markerNew.model;
        NSLog([instant createdBy]);
        
    }
    return YES;
}

- (void) showMyLocationOnMap
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.125;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [locationButton.layer addAnimation:anim forKey:nil];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnim.removedOnCompletion = YES;
    
    if (nextMapZoom == UnZoom) {
        lastCamera = [GMSCameraPosition cameraWithLatitude:lastCamera.target.latitude longitude:lastCamera.target.longitude zoom:mediumZoom];
        
        nextMapZoom = Zoom;
        [locationButton setImage:[UIImage imageNamed:@"compass_disabled_button.png"] forState:UIControlStateNormal];
        mapView.myLocationEnabled = NO;
    } else {
        lastCamera = [GMSCameraPosition cameraWithLatitude:lastCamera.target.latitude longitude:lastCamera.target.longitude zoom:poiDetailedZoom];
        
        nextMapZoom = UnZoom;
        [locationButton setImage:[UIImage imageNamed:@"compass_button.png"] forState:UIControlStateNormal];
        mapView.myLocationEnabled = YES;
    }
    [mapView setCamera:lastCamera];
    
}

- (void) locationUpdated:(CLLocation *)location
{
    lastCamera = [GMSCameraPosition cameraWithLatitude:[location coordinate].latitude
                                             longitude:[location coordinate].longitude
                                                  zoom:poiDetailedZoom];
    
    if (nextMapZoom == UnZoom) {
        [mapView setCamera:lastCamera];
    }
    NSLog(@"Retrieved location");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
