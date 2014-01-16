//
//  POISManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/15/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "POISManager.h"

@implementation POISManager

@synthesize controller;

- (id) initWithMapViewController:(MapViewController*)mapViewController
{
    if (self = [super init]) {
        self.controller = mapViewController;
    }
    return self;
}

- (void) prepareMapForPOIEditing
{
    [[controller mapManager] unmountSelectedModelMarkerFromMap];
    [[controller detailsView] setHidden:YES];
    [controller transitionMapToMode:EditShare];
    [[controller mapManager] displayOnEditModeNotification];
}

- (void) restoreMapOnCancelPOIEditing
{
    [[controller mapManager] mountSelectedModelMarkerFromMap];
    [[controller detailsView] setHidden:NO];
    [controller transitionMapToMode:Detail];
}

- (void) restoreMapOnFinishedPOIEditing
{
    [self restoreMapOnCancelPOIEditing];
    [controller hideViewForMarker];
    [[controller mapManager] displaySavedChangesNotification];
}

@end
