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
    
    UIView *messagesContainerView;
    UILabel *messageTitleLabel;
    UILabel *messageSubtitleLabel;
    InstantDetailsView *detailsView;
}

- (void) openLeftDock;
- (void) attemptToSynchronize;
- (void) drawInstants;
- (void) hideInstantDetailsView;
@end

@implementation CycleprintsViewController

@synthesize distanceTextLabel, distanceValueLabel, speedTextLabel, speedValueLabel, displayLeftMenuButton, statsContainerView, locationButton, titleLabel, unfetchedContainerView, unfetchedSubtitleLabel, unfetchedTitleLabel, unfetchedMainTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lastCamera = [GMSCameraPosition cameraWithLatitude:19.343 longitude:-99.112 zoom:mediumZoom];
        UIImage *locationImage = [UIImage imageNamed:@"compass_button.png"];
        locationButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-locationImage.size.width-10, [App viewBounds].size.height-locationImage.size.height-marginUnit*2.5, locationImage.size.width, locationImage.size.height)];
        [locationButton setBackgroundImage:locationImage forState:UIControlStateNormal];
        [locationButton addTarget:self action:@selector(showMyLocationOnMap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:locationButton];
        nextMapZoom = UnZoom;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[self.navigationController viewDeckController] setDelegate:self];
    [[self.navigationController viewDeckController] setRightController:nil];
    
    if (![[LocationManager sharedInstance] active] && ![Settings settingHoldsTrue:kDisablePedalPowerMessage]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"suggestion_message", nil)
                                                        message:NSLocalizedString(@"get_the_best_from_cycleprints", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"dont_show_again", nil) otherButtonTitles:NSLocalizedString(@"accept", nil), nil];
        [alert show];
    }
    
    [[self statsContainerView] setHidden:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
    [self loadMessagesContainer];
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
    [distanceTextLabel setText:NSLocalizedString(@"pedal_punch_distance", nil)];
    [speedTextLabel setText:NSLocalizedString(@"pedal_punch_speed", nil)];

    [titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:15]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
    [titleLabel setText:NSLocalizedString(@"pedal_power_title", nil).uppercaseString];

    [unfetchedMainTitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:15]];
    [unfetchedMainTitleLabel setTextColor:[LookAndFeel orangeColor]];
    [unfetchedMainTitleLabel setText:NSLocalizedString(@"pedal_power_title", nil).uppercaseString];
    
    [unfetchedTitleLabel setFont:[LookAndFeel defaultFontBookWithSize:12]];
    [unfetchedTitleLabel setTextColor:[LookAndFeel blueColor]];
    [unfetchedTitleLabel setText:NSLocalizedString(@"unfetched_pedal_power_title", nil)];
 
    [unfetchedSubtitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:11]];
    [unfetchedSubtitleLabel setTextColor:[LookAndFeel blueColor]];
    [unfetchedSubtitleLabel setText:NSLocalizedString(@"unfetched_pedal_power_subtitle", nil)];
 
    [[self statsContainerView] setHidden:YES];
    [[self unfetchedContainerView] setHidden:YES];
    
    UIImage *menuImage = [UIImage imageNamed:@"menu_button.png"];
    displayLeftMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [App viewBounds].size.height-menuImage.size.height-20*2.5,
                                                                       menuImage.size.width, menuImage.size.height)];
    [displayLeftMenuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [self.view addSubview:displayLeftMenuButton];
    [displayLeftMenuButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchDragOutside];
    [displayLeftMenuButton addTarget:self action:@selector(openLeftDock) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchCycleprints)];
    [gestureRecognizer setNumberOfTapsRequired:1];
    [unfetchedContainerView addGestureRecognizer:gestureRecognizer];
    
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) camera:lastCamera];
    mapView.myLocationEnabled = YES;
    [mapView setDelegate:self];
    [self.view addSubview:mapView];
    [self.view bringSubviewToFront:statsContainerView];
    [self.view bringSubviewToFront:messagesContainerView];
    [self.view bringSubviewToFront:displayLeftMenuButton];
    [self.view bringSubviewToFront:unfetchedContainerView];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    [hud setHidden:NO];
    [[LocationManager sharedInstance] setDelegate:self];
    
    if ([[LocationManager sharedInstance] location] != NULL) {
        lastCamera = [[GMSCameraPosition alloc]
                      initWithTarget:[[LocationManager sharedInstance] location].coordinate zoom:poiDetailedZoom bearing:mapView.camera.bearing viewingAngle:mapView.camera.viewingAngle];
        [mapView setCamera:lastCamera];
    }
    
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
    
    NSDate *now = [[NSDate alloc] init];
    
    /*
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];*/
    
    NSDictionary *dict = @{@"start_date": [self.formatter stringFromDate:[DateHelpers begginingOfDay:now]],
                           @"end_date": [self.formatter stringFromDate:[DateHelpers endOfDay:now]]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        [[self statsContainerView] setHidden:NO];
        [[self unfetchedContainerView] setHidden:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud setHidden:YES];
        [[self unfetchedContainerView] setHidden:NO];
        [[self statsContainerView] setHidden:YES];
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
    NSMutableArray *paths = [NSMutableArray array];
    for (Instant *instant in [Instant remoteInstants]) {
        float lat = [instant.latitude floatValue];
        float lon = [instant.longitude floatValue];
        if ([instant.timing floatValue] > 1000) {
            [paths addObject:path];
            path = [GMSMutablePath path];
        }
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);

        [path addCoordinate:position];
        
        [instant.marker setMap:mapView];
        [markers addObject:instant.marker];
    }
    // Add last
    if (![paths containsObject:path]) {
        [paths addObject:path];
    }

    for (GMSMutablePath *collectedPath in paths) {
        linePath = [GMSPolyline polylineWithPath:collectedPath];
        linePath.strokeColor = [LookAndFeel greenColor];
        linePath.strokeWidth = 3;
        linePath.geodesic = YES;
        [linePath setMap:mapView];
    }

}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([[(WikiMarker*) marker model] isKindOfClass:[Instant class]]) {
        WikiMarker *markerNew = (WikiMarker*) marker;
        Instant *instant = (Instant*) markerNew.model;
        if (detailsView == NULL) {
            detailsView = [[[NSBundle mainBundle] loadNibNamed:@"InstantDetailsView" owner:self options:nil] objectAtIndex:0];
            [self.view addSubview:detailsView];
            [detailsView setFrame:CGRectMake(0, statsContainerView.frame.size.height, detailsView.frame.size.width, detailsView.frame.size.height)];
        }
        
        [detailsView stylizeView];
        float timing = [[instant timing] floatValue]/60;
        
        [[detailsView timingValueLabel] setText:[NSString stringWithFormat:@"%0.2f", timing]];
        [[detailsView distanceValueLabel] setText:[NSString stringWithFormat:@"%0.2f", [[instant distance] floatValue]]];
        [[detailsView speedValueLabel] setText:[NSString stringWithFormat:@"%0.2f", [[instant speed] floatValue]]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInstantDetailsView)];
        [tapGesture setNumberOfTapsRequired:1];
        [detailsView addGestureRecognizer:tapGesture];
    }
    return YES;
}

- (void) hideInstantDetailsView
{
    if (detailsView != NULL) {
        [detailsView removeFromSuperview];
        detailsView = NULL;
    }
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self hideInstantDetailsView];
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
    NSLog(@"RRRR");
    lastCamera = [GMSCameraPosition cameraWithLatitude:[location coordinate].latitude
                                             longitude:[location coordinate].longitude
                                                  zoom:poiDetailedZoom];
    
    if (nextMapZoom == UnZoom) {
        [mapView setCamera:lastCamera];
    }
}

- (void) loadMessagesContainer
{
    messagesContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, statsContainerView.frame.size.height, [App viewBounds].size.width, 60)];
    
    messageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [App viewBounds].size.width-10, 20)];
    messageSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, [App viewBounds].size.width-10, 20)];
    
    [messageTitleLabel setText:NSLocalizedString(@"stucked_pedal_punch", nil)];
    [messageSubtitleLabel setText:NSLocalizedString(@"free_pedal_punch", nil)];
    [messageTitleLabel setFont:[LookAndFeel defaultFontBookWithSize:17]];
    [messageSubtitleLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [messageTitleLabel setTextColor:[UIColor whiteColor]];
    [messageSubtitleLabel setTextColor:[UIColor whiteColor]];
    
    [messagesContainerView setBackgroundColor:[LookAndFeel orangeColor]];
    [messagesContainerView addSubview:messageTitleLabel];
    [messagesContainerView addSubview:messageSubtitleLabel];
    [self.view addSubview:messagesContainerView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attemptToSynchronize)];
    [gestureRecognizer setNumberOfTapsRequired:1];
    [messagesContainerView addGestureRecognizer:gestureRecognizer];
    
    if ([[Instant allRecords] count] <= 10) {
        [messagesContainerView setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
