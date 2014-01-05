//
//  SelectOnTapCollectionView.m
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "SelectOnTapCollectionView.h"

@interface SelectOnTapCollectionView () {
    NSArray *storedCollectedViews;
    int currentView;
}

@end

@implementation SelectOnTapCollectionView

- (void) addCollection:(NSArray *)collection
{
    currentView = 0;
    storedCollectedViews = collection;
    
    for (SelectOnTapView *view in storedCollectedViews) {
        [self addSubview:view];
        [view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [view addTarget:self
                 action:@selector(bringNextViewToFront)
       forControlEvents:UIControlEventTouchUpInside];
        [view stylizeView];
    }
    
    [self bringToFrontViewWithIndex:currentView];
    
}

- (void) bringNextViewToFront
{
    if (currentView == [storedCollectedViews count]-1) {
        currentView = 0;
    } else {
        currentView += 1;
    }
    [self bringToFrontViewWithIndex:currentView];
}

- (void) bringToFrontViewWithIndex:(int)index
{
    SelectOnTapView *view = [storedCollectedViews objectAtIndex:index];
    [self bringSubviewToFront:view];
}

- (void) stylizeView
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[LookAndFeel lightBlueColor] CGColor];
    self.layer.cornerRadius = 5.0f;
}

- (int) currentlySelectedIndex
{
    return currentView+1;
}

@end
