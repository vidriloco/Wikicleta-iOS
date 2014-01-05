//
//  EditTipViewController.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+UIPlus.h"
#import "SelectOnTapCollectionView.h"
#import "SelectOnTapView.h"
#import "CommonEditViewController.h"

@interface EditTipViewController : CommonEditViewController <UIAlertViewDelegate> 

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *instructionOne;
@property (nonatomic, weak) IBOutlet SelectOnTapCollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UITextView *tipDescriptionTextView;

@end
