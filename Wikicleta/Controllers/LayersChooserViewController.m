//
//  LayersChooserViewController.m
//  Cyclo
//
//  Created by Alejandro Cruz Paz on 8/13/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayersChooserViewController.h"

@interface LayersChooserViewController () {
}

@end


@implementation LayersChooserViewController

- (id) init
{
    self = [super init];
    if (self) {
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(20, 40, [App viewBounds].size.width-40, 300)];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 30)];
        [title setFont:[UIFont fontWithName:@"Gotham Rounded" size:18]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setTextColor:[UIColor colorWithHexString:@"1f3a50"]];
        [title setText:NSLocalizedString(@"layers_menu_title", nil)];
        [self.view addSubview:title];
        
        NSArray *layers = [NSArray arrayWithObjects:@"parkings", @"bike_sharings", @"tips", @"workshops", @"routes", nil];
        
        for (int i = 0; i < layers.count; i++) {
            CGFloat xOrigin = i * 95;
            UIButtonWithLabel *button = [[UIButtonWithLabel alloc] initWithFrame:CGRectMake(xOrigin+20, 60, 50, 50)
                                                                  withName:[[layers objectAtIndex:i] stringByAppendingString:@"_layers.png"]
                                                              withTextSeparation:50];
            [self.view addSubview:button];
        }
        //[self.view addSubview:layersMenu];
    }
    return self;
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
