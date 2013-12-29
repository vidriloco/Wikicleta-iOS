//
//  LayersScrollView.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "UIButtonWithLabel.h"
#import "LayerItemView.h"

@class LayersChooserViewController;

@interface LayersScrollView : UIScrollView {
    LayersChooserViewController *layersController;
}

@property (nonatomic, strong) LayersChooserViewController *layersController;

- (id) initWithLayers:(NSArray*)layers withLayersController:(LayersChooserViewController*)layersController;
@end
