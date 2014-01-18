//
//  FavoritesViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/5/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "UIViewController+Helpers.h"
#import "POICellView.h"
#import "User.h"
#import "LightPOI.h"
#import "TTTTimeIntervalFormatter.h"
#import "MapViewController.h"
#import "IIViewDeckController.h"
#import "GenericBigMessageView.h"

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *favoritesList;
}

@property (nonatomic, strong) NSMutableDictionary *favoritesList;
@property (nonatomic, weak) IBOutlet UITableView *favoritesTableView;

- (void) dismiss;
- (void) fetchUserFavorites;

@end
