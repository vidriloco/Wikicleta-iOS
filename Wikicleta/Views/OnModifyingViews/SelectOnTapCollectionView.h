//
//  SelectOnTapCollectionView.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectOnTapView.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectOnTapCollectionView : UIView

- (void) addCollection:(NSArray*)collection;
- (void) bringToFrontViewWithIndex:(int)index;
- (void) bringNextViewToFront;
- (void) stylizeView;
- (int) currentlySelectedIndex;

@end
