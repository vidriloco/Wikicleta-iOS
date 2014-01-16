//
//  CommonEditViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormBaseViewController.h"
#import "SelectOnTapCollectionView.h"
#import "UIViewController+Helpers.h"
#import "NSObject+FieldValidators.h"
#import "User.h"
#import <MBProgressHUD/MBProgressHUD.h>

typedef enum {New, Edit} POIMode;

@class  MapViewController;

@interface CommonEditViewController : FormBaseViewController {
    CLLocationCoordinate2D selectedCoordinate;
    POIMode selectedMode;
}

@property (nonatomic, assign) CLLocationCoordinate2D selectedCoordinate;
@property (nonatomic, assign) POIMode selectedMode;

- (void) setCoordinate:(CLLocationCoordinate2D)coordinate withMode:(POIMode)mode;
- (NSArray*) selectableCategories;
- (void) loadCategoriesInView;
- (SelectOnTapCollectionView*) selectOnTapCollectionView;
- (void) attemptSave;
- (void) dismiss;
- (NSDictionary*) authPair;

@end
