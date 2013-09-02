//
//  SettingsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/31/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () {
    UzysSlideMenu *settingsMenu;
}

- (void) selectedPreferenceCategory:(id)category;

@end

@implementation SettingsViewController

@synthesize dragMsgLabel, sectionNameLabel, imageBackground, mapViewSettings;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *settingsCategories = @[@"settings_map", @"settings_location", @"settings_social", @"settings_gadgets"];
    NSMutableArray *settingsMenuItems = [NSMutableArray array];
    for (NSString *category in settingsCategories) {
        UzysSMMenuItem *menuItem = [[UzysSMMenuItem alloc] initWithTitle:NSLocalizedString(category, nil)
                                                                   image:[UIImage imageNamed:[category stringByAppendingString:@"_icon.png"]]
                                                                  action:^(UzysSMMenuItem *item) {
                                                                      [self selectedPreferenceCategory:category];
                                                                  }];
        [settingsMenuItems addObject:menuItem];
    }
    
    settingsMenu = [[UzysSlideMenu alloc] initWithItems:settingsMenuItems];
    [self.view addSubview:settingsMenu];

    [settingsMenu toggleMenu];
    
    [sectionNameLabel setTextColor:[LookAndFeel orangeColor]];
    [sectionNameLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [sectionNameLabel setText:[NSLocalizedString(@"settings_section_name_label", nil) uppercaseString]];
    
    [dragMsgLabel setTextColor:[LookAndFeel blueColor]];
    [dragMsgLabel setFont:[LookAndFeel defaultFontLightWithSize:19]];
    [dragMsgLabel setText:NSLocalizedString(@"drag_to_back_label", nil)];
    [dragMsgLabel setNumberOfLines:2];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [settingsMenu toggleMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CategoriesSelected

- (void) selectedPreferenceCategory:(id)category
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC);
    if ([category isEqualToString:@"settings_map"]) {
        dispatch_after(popTime, dispatch_get_current_queue(), ^{
            [self presentModalViewController:[[MapSettingsViewController alloc]
                                              initWithNibName:[@"MapSettingsViewController" stringByAppendingString:[App postfixView]] bundle:nil] animated:NO];
        });
    } else if([category isEqualToString:@"settings_social"]) {
        dispatch_after(popTime, dispatch_get_current_queue(), ^{
            [self presentModalViewController:[[SocialSettingsViewController alloc]
                                              initWithNibName:[@"SocialSettingsViewController" stringByAppendingString:[App postfixView]] bundle:nil] animated:NO];
        });
    }
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [settingsMenu openIconMenu];
    
}

@end
