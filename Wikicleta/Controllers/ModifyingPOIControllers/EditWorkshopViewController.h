//
//  EditWorkshopViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+UIPlus.h"
#import "UITextField+UIPlus.h"
#import "SelectOnTapCollectionView.h"
#import "SelectOnTapView.h"
#import "CommonEditViewController.h"
#import "EditWorkshopInfoContactViewController.h"
#import "IIViewDeckController.h"
#import "POISManager.h"
#import "Workshop.h"

@interface EditWorkshopViewController : CommonEditViewController

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UILabel *instructionOne;
@property (nonatomic, weak) IBOutlet UITextView *workshopDescriptionTextView;
@property (nonatomic, weak) IBOutlet UILabel *workshopIsStoreLabel;
@property (nonatomic, weak) IBOutlet UISwitch *workshopIsStoreSwitch;

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextView *workshopHoraryTextView;

- (void) fillInWithDataFrom:(Workshop*)workshop;

@end
