//
//  AppDelegate.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/6/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandingViewController.h"
#import "App.h"
#import <GoogleMaps/GoogleMaps.h>
#import "IIViewDeckController.h"
#import "ActiveRecord.h"
#import "TestFlight.h"
#import "LocationManager.h"
#import "Instant.h"

#define MIXPANEL_TOKEN @"def4310ad4a74133db2291d53f6abecc"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
*/

@end
