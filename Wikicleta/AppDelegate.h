//
//  AppDelegate.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/6/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "App.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end