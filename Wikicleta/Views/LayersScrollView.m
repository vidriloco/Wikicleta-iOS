//
//  LayersScrollView.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayersScrollView.h"
#import "LayersChooserViewController.h"

@implementation LayersScrollView

- (id) initWithLayers:(NSArray *)layers withLayersController:(LayersChooserViewController *)layersController
{
    self = [super initWithFrame:CGRectMake(200, 10, 150, [App viewBounds].size.height-20)];
    if (self) {
        self.contentSize = CGSizeMake(150, 100 * [layers count]);
        [self setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
        [self setContentOffset:CGPointMake(0, -10)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        int i = 0;
        for (NSString *layer in layers) {
            UIButtonWithLabel *buttonLabel= [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(8, i*100, 100, 50)
                                                                            withName:[layer stringByAppendingString:@"_layers"]
                                                                  withTextSeparation:50];
            [self addSubview:buttonLabel];
            [buttonLabel setSelected:NO];
            [buttonLabel.button addTarget:layersController action:@selector(selectedLayer:) forControlEvents:UIControlEventTouchUpInside];
            [[layersController layersMenuList] setValue:buttonLabel forKey:buttonLabel.name];
            i+=1;
        }
    }
    
    return self;
}



@end
