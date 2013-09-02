//
//  MapSettingsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 9/1/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MapSettingsViewController.h"

@interface MapSettingsViewController ()

- (void) returnToRootController:(id)receiver;
- (void) chooseYourLayersGroup;
- (void) pageChanged;

@end

@implementation MapSettingsViewController

@synthesize backgroundView, navBarTitle, scrollView, pageControl, settingsText, jumpGroupsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) returnToRootController:(id)receiver
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [pageControl setNumberOfPages:kPagesLevelOne];
    [pageControl setCurrentPage:0];
    [pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnToRootController:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    [navBarTitle setTextColor:[LookAndFeel orangeColor]];
    [navBarTitle setFont:[LookAndFeel defaultFontLightWithSize:17]];
    [navBarTitle setText:NSLocalizedString(@"settings_map", nil)];
        
    [scrollView setDelegate:self];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*kPagesLevelOne, scrollView.frame.size.height)];
    
    int i = 0;
    for (NSString *viewType in @[@"layers", @"groups"]) {
        UIView *modMapView;
        if ([viewType isEqualToString:@"layers"]) {
            modMapView = [[[NSBundle mainBundle] loadNibNamed:[@"LayerBasedView" stringByAppendingString:[App postfixView]] owner:self options:nil] objectAtIndex:0];
        } else {
            modMapView = [[[NSBundle mainBundle] loadNibNamed:[@"GroupsBasedView" stringByAppendingString:[App postfixView]] owner:self options:nil] objectAtIndex:0];
        }
        
        UILabel *label = (UILabel*) [modMapView viewWithTag:1];
        [label setFont:[LookAndFeel defaultFontLightWithSize:16]];
        [label setTextColor:[LookAndFeel orangeColor]];
        
        [settingsText setTextColor:[LookAndFeel blueColor]];
        [settingsText setFont:[LookAndFeel defaultFontLightWithSize:16]];
        
        [modMapView setFrame:CGRectMake(scrollView.frame.size.width * i, modMapView.frame.origin.y, modMapView.frame.size.width, modMapView.frame.size.height)];
        [scrollView addSubview:modMapView];

        i=i+1;
    }
    
    [jumpGroupsController addTarget:self action:@selector(chooseYourLayersGroup) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chooseYourLayersGroup
{
    [self presentModalViewController:[[LayersGroupsViewController alloc] initWithNibName:@"LayersGroupsViewController" bundle:Nil] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void) pageChanged
{
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
}

@end
