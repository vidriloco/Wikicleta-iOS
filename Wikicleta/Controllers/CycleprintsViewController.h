//
//  CycleprintsViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/23/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LookAndFeel.h"
#import "AFHTTPRequestOperationManager.h"
#import "App.h"
#import "IIViewDeckController.h"
#import "LocationManager.h"
#import "Settings.h"
#import "WikiMarker.h"
#import "DateHelpers.h"
#import "InstantDetailsView.h"

#define routeSpliterThreshold 1000

@interface CycleprintsViewController : UIViewController<IIViewDeckControllerDelegate, GMSMapViewDelegate, UIAlertViewDelegate, LocationManagerDelegate> {
    UIButton *displayLeftMenuButton;
    UIButton *locationButton;
}



@property (nonatomic, weak) IBOutlet UILabel *distanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *statsContainerView;

@property (nonatomic, weak) IBOutlet UIView *unfetchedContainerView;
@property (nonatomic, weak) IBOutlet UILabel *unfetchedTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *unfetchedSubtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *unfetchedMainTitleLabel;

@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) UIButton *displayLeftMenuButton;

- (void) fetchCycleprints;
- (void) showMyLocationOnMap;
- (void) loadMessagesContainer;

@end
