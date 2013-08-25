//
//  MenuListViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/10/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MenuListViewController.h"

@interface MenuListViewController () {
    NSArray *menuSections;
}

@end

@implementation MenuListViewController

static NSString *simpleTableIdentifier = @"mainMenuItem";

- (id) initWithFrame:(CGRect)frame withOptions:(NSArray *)options
{
    self = [super init];
    if (self) {
        menuSections = options;
        
        UITableView *table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [table setSeparatorStyle:UITableViewCellSelectionStyleNone];
        [table setBackgroundColor:[UIColor clearColor]];
        [table setBounces:NO];
        [table setRowHeight:35];
        table.dataSource = self;
        table.delegate = self;
        self.view = table;
        
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuSections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionId = [menuSections objectAtIndex:indexPath.row];

    MenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:simpleTableIdentifier
                                   withSectionName:sectionId];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
}

@end
