//
//  FavoritesManager.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/18/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import "MapViewController.h"

@interface FavoritesManager : NSObject {
    MapViewController *controller;
}

@property (nonatomic, strong) MapViewController *controller;

- (id) initWithMapViewController:(MapViewController*)mapViewController;
- (void) reflectFavoritedStatusForItemWithId:(NSNumber*)itemId andType:(NSString*)type;

@end
