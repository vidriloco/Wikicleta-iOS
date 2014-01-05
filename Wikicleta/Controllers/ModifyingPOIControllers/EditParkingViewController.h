//
//  EditParkingViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+UIPlus.h"
#import "SelectOnTapCollectionView.h"
#import "SelectOnTapView.h"
#import "CommonEditViewController.h"

@interface EditParkingViewController : CommonEditViewController 

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *instructionOne;
@property (nonatomic, weak) IBOutlet SelectOnTapCollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *parkingHasRoofLabel;
@property (nonatomic, weak) IBOutlet UISwitch *parkingHasRoofSwitch;
@property (nonatomic, weak) IBOutlet UITextView *parkingDescriptionTextView;

@end
