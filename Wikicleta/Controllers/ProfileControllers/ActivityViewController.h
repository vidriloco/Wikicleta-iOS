//
//  ActivityViewController.h
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

@interface ActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *activityList;
    
}

@property (nonatomic, strong) NSArray *activityList;
@property (nonatomic, weak) IBOutlet UITableView *contributionsTableView;

- (void) dismiss;
- (void) fetchUserActivity;

@end
