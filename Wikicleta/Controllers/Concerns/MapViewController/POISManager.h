//
//  POISManager.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/15/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"
#import "MapViewCompanionManager.h"

@interface POISManager : NSObject {
    MapViewController *controller;
}

@property (nonatomic, strong) MapViewController *controller;
@property (nonatomic, strong) MBProgressHUD *hud;

- (id) initWithMapViewController:(MapViewController*)mapViewController;
- (void) prepareMapForPOIEditing;
- (void) restoreMapOnCancelPOIEditing;
- (void) restoreMapOnFinishedPOIEditing;

@end
