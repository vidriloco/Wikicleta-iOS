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
#import "FavoritesManagerDelegate.h"

#define favoritedTag    111111
#define unfavoritedTag  999999

@interface FavoritesManager : NSObject {
    id<FavoritesManagerDelegate> controller;
}

@property (nonatomic) id<FavoritesManagerDelegate> controller;

- (id) initWithController:(id<FavoritesManagerDelegate>)delegateController;
- (void) reflectFavoritedStatusForItemWithId:(NSNumber*)itemId andType:(NSString*)type;
- (void) changeFavoritedStatusForItemWithId:(NSNumber*)itemId andType:(NSString*)type;

- (void) toggleFavoritedStatus;
@end
