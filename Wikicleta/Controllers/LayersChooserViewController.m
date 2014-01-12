//
//  LayersChooserViewController.m
//  Wikicleta
//
//  This class implements the right menu chooser from which
//  users can select up to one layer of POIs to view on the map
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
        
        NSArray *layers = [NSArray arrayWithObjects:layersParkings, layersRoutes, layersWorkshops, layersBicycleSharings, layersTips, layersCyclingGroups, nil];
        
        layersMenu = [[LayersScrollView alloc] initWithLayers:layers withLayersController:self];
        [self.view addSubview:layersMenu];
        
    }
    return self;
}

- (void) selectedLayer:(id)layer
{
    [self.viewDeckController closeRightView];
    LayerItemView *buttonSelected = (LayerItemView*) layer;
    LayerItemView *previouslySelected = [layersMenuList objectForKey:selectedLayer];
    
    if (selectedLayer != buttonSelected.name) {
        selectedLayer = buttonSelected.name;
        [previouslySelected setSelected:NO];
        [buttonSelected setSelected:YES];
    } else {
        [previouslySelected setSelected:NO];
        selectedLayer = nil;
    }


    [delegate setActiveLayer:selectedLayer];
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
