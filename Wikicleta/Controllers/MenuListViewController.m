//
//  MenuListViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/10/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MenuListViewController.h"
#import "MainMenuViewController.h"

@interface MenuListViewController () {
    NSArray *menuSections;
    UITableView *tableView;
    MainMenuViewController *associatedController;
}

@end

static NSString *reuseIdentifier = @"menu-cell-reuse";

@implementation MenuListViewController

static NSString *simpleTableIdentifier = @"mainMenuItem";

- (id) initWithFrame:(CGRect)frame withOptions:(NSArray *)options withController:(MainMenuViewController *)menuController {
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
        associatedController = menuController;
        
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

- (void) tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [associatedController deselectAll];
    [tableView_ selectRowAtIndexPath:indexPath animated:YES scrollPosition:nil];
    
    NSString *selectedMenuItem = [menuSections objectAtIndex:[indexPath row]];

    [associatedController.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        if ([selectedMenuItem isEqualToString:@"discover"]) {
            if (![[(UINavigationController*) [[associatedController viewDeckController] centerController] topViewController] isKindOfClass:[MapViewController class]]) {
                [(UINavigationController*) [[associatedController viewDeckController] centerController] pushViewController:[[MapViewController alloc]init] animated:NO];
            }
        } else if ([selectedMenuItem isEqualToString:@"join"]) {
            [(UINavigationController*) [[associatedController viewDeckController] centerController] popToRootViewControllerAnimated:NO];
            
        } else if ([selectedMenuItem isEqualToString:@"profile"]) {
            [(UINavigationController*) [[associatedController viewDeckController] centerController] pushViewController:[[ProfileViewController alloc] initWithNibName:nil bundle:nil] animated:NO];
        } else if ([selectedMenuItem isEqualToString:@"trails"]) {
            [(UINavigationController*) [[associatedController viewDeckController] centerController] pushViewController:[[CycleprintsViewController alloc] initWithNibName:nil bundle:nil] animated:NO];
        }
    }];
}


- (void) deselectAllRows
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
