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
    UITableView *tableView;
    IIViewDeckController *localDeckController;
}

@end

static NSString *reuseIdentifier = @"menu-cell-reuse";

@implementation MenuListViewController

static NSString *simpleTableIdentifier = @"mainMenuItem";

- (id) initWithFrame:(CGRect)frame withOptions:(NSArray *)options withViewDeckController:(IIViewDeckController *)deckController
{
    self = [super init];
    if (self) {
        menuSections = options;
        
        tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.view = tableView;

        [tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setBounces:NO];
        [tableView setRowHeight:35];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"MenuViewCell"
                                              bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:reuseIdentifier];
        localDeckController = deckController;
        
    }
    return self;
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

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionId = [menuSections objectAtIndex:indexPath.row];

    MenuViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:reuseIdentifier];
    }
    
    [cell setIconAndTextByName:sectionId];
    [cell setDefaultLookAndFeel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedMenuItem = [menuSections objectAtIndex:[indexPath row]];
    if ([selectedMenuItem isEqualToString:@"map"]) {
        if (![localDeckController.centerController isKindOfClass:[MapViewController class]]) {
            localDeckController.centerController = [[MapViewController alloc] init];
        }
        [localDeckController closeLeftViewAnimated:YES];
    } else if ([selectedMenuItem isEqualToString:@"discover"]) {
        
    } else if ([selectedMenuItem isEqualToString:@"activity"]) {
        
    }
}

@end
