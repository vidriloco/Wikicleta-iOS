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

@interface CycleprintsViewController : UIViewController<IIViewDeckControllerDelegate, GMSMapViewDelegate, UIAlertViewDelegate> {
    UIButton *displayLeftMenuButton;
}

@property (nonatomic, weak) IBOutlet UILabel *noteTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *noteSubtitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *distanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedTextLabel;
@property (nonatomic, weak) IBOutlet UIView *statsContainerView;
@property (nonatomic, weak) IBOutlet UIView *messagesContainerView;

@property (nonatomic, strong) UIButton *displayLeftMenuButton;

- (void) fetchCycleprints;

@end
