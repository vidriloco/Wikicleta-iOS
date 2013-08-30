//
//  LayersChooserViewController.m
//  Cyclo
//
//  Created by Alejandro Cruz Paz on 8/13/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayersChooserViewController.h"

@interface LayersChooserViewController () {
    LayersScrollView *layersMenu;
    NSString *selectedLayer;
}

@end


@implementation LayersChooserViewController

@synthesize layersMenuList, delegate;

- (id) init
{
    self = [super init];
    if (self) {
        layersMenuList = [NSMutableDictionary dictionary];

        self.view = [[UIView alloc] initWithFrame:CGRectMake(20, 40, [App viewBounds].size.width-40, 300)];
        
        NSArray *layers = [NSArray arrayWithObjects:layersParkings, layersRoutes, layersBicycleLanes, layersWorkshops, layersBicycleSharings, layersTips, nil];
        
        layersMenu = [[LayersScrollView alloc] initWithLayers:layers withLayersController:self];
        [self.view addSubview:layersMenu];
        
    }
    return self;
}

- (void) selectedLayer:(id)layer
{
    [self.viewDeckController closeRightView];
    UIButtonWithLabel *buttonSelected = ((UIButtonWithLabel*) [layer superview]);
    UIButtonWithLabel *previouslySelected = [layersMenuList objectForKey:selectedLayer];
    
    [previouslySelected setSelected:NO];
    NSArray *array;
    if (buttonSelected.name == previouslySelected.name) {
        selectedLayer = @"";
        array = [NSArray array];
    } else {
        selectedLayer = buttonSelected.name;
        array = [NSArray arrayWithObject:selectedLayer];
        [buttonSelected setSelected:YES];
    }
    
    [delegate updateMapWithLayersSelected:array];
    
}

- (void) loadView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
