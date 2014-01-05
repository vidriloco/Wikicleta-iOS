//
//  EditWorkshopInfoContactViewController.h
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

@interface EditWorkshopInfoContactViewController : CommonEditViewController

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UILabel *workshopNameOrTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *workshopContactLabel;
@property (nonatomic, weak) IBOutlet UITextField *twitterTextField;
@property (nonatomic, weak) IBOutlet UITextField *cellphoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *telephoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *websiteTextField;
@property (nonatomic, weak) IBOutlet UILabel *arrobaLabel;
@property (nonatomic, weak) IBOutlet UITextView *workshopHoraryTextView;

@end
