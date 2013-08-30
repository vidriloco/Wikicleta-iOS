//
//  LayersChooserViewController.h
//  Cyclo
//
//  Created by Alejandro Cruz Paz on 8/13/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "UIColor-Expanded.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButtonWithLabel.h"
#import "LayersScrollView.h"
#import "LayersDelegate.h"
#import "IIViewDeckController.h"

@interface LayersChooserViewController : UIViewController {
    NSDictionary *layersMenuList;
    id<LayersDelegate> delegate;
}

@property (nonatomic, strong) NSDictionary *layersMenuList;
@property (nonatomic, strong) id<LayersDelegate> delegate;

- (void) selectedLayer:(id)layer;

@end
