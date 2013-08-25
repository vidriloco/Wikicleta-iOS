//
//  LayersChooserViewController.m
//  Cyclo
//
//  Created by Alejandro Cruz Paz on 8/13/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LayersChooserViewController.h"

#define bottomMargin 40
#define rowHeight 50

@interface LayersChooserViewController () {
    NSArray *layers;
}

@end

@implementation LayersChooserViewController

- (id) init
{
    self = [super init];
    if (self) {
        layers = [NSArray arrayWithObjects:@"routes", @"parkings", @"workshops", @"bike_sharings", @"tips", nil];
        
        float size = layers.count*rowHeight;
        CGRect frame = CGRectMake(95, [App viewBounds].size.height-size-bottomMargin, 250, size);
        self.view = [[UIView alloc] initWithFrame:[App viewBounds]];

        UITableView *table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [table setBackgroundColor:[UIColor clearColor]];
        [table setBounces:NO];
        [table setRowHeight:rowHeight];
        table.dataSource = self;
        table.delegate = self;
        [self.view addSubview:table];
    }
    return self;
}

- (void) loadView
{
    
    /*int index = 0;
    for (NSString *layerIcon in layers) {
        NSString *lookupString = [layerIcon stringByAppendingString:@"_layers.png"];
        UIImage *imageForButton = [UIImage imageNamed:lookupString];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonsInitialPosition*index+imageForButton.size.width*index+marginBetween,
                                                                      [App viewBounds].size.height-imageForButton.size.height-hAlignment,
                                                                      imageForButton.size.width, imageForButton.size.height)];
        [button setTitle:NSLocalizedString([layerIcon stringByAppendingString:@"_layers"], @"lookupString") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"1f3a50"] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont fontWithName:@"Gotham Rounded" size:15]];
        
        [button setImage:imageForButton forState:UIControlStateNormal];
        [self.view addSubview:button];
        index=index+1;
    }*/
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [layers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionId = [layers objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"layersMenu"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        [cell.textLabel setText:NSLocalizedString([sectionId stringByAppendingString:@"_layers"], @"lookupString")];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
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
