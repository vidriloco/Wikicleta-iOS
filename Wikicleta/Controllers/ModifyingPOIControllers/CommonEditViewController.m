//
//  CommonEditViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "CommonEditViewController.h"

@interface CommonEditViewController ()

@end

@implementation CommonEditViewController

@synthesize selectedCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"new", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImageBackgroundNamed:@"upload_icon.png"];
    [self loadNavigationBarDefaultStyle];
    [self loadCategoriesInView];
    [self loadRightButtonWithString:NSLocalizedString(@"save", nil) andStringSelector:@"attemptSave"];
    [self loadLeftButtonWithString:NSLocalizedString(@"close", nil) andStringSelector:@"dismiss"];
}

- (void) loadCategoriesInView
{
    NSMutableArray *collectedViews = [NSMutableArray array];
    SelectOnTapView *tapView;
    for (NSString *parkingType in [self selectableCategories]) {
        tapView = [[[NSBundle mainBundle]
                    loadNibNamed:@"SelectOnTapView" owner:self options:nil]
                   objectAtIndex:0];
        [[tapView titleLabel] setText:NSLocalizedString(parkingType, nil)];
        [[tapView iconImage] setImage:
         [UIImage imageNamed:[NSString stringWithFormat:@"%@_marker.png", parkingType]]];
        [collectedViews addObject:tapView];
    }
    
    [[self selectOnTapCollectionView] addCollection:collectedViews];
    [[self selectOnTapCollectionView] stylizeView];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSArray*) selectableCategories
{
    return @[];
}

- (UIScrollView*) scrollableView {
    return nil;
}

- (SelectOnTapCollectionView*) selectOnTapCollectionView
{
    return nil;
}

- (void) attemptSave
{
    
}

- (void) dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
