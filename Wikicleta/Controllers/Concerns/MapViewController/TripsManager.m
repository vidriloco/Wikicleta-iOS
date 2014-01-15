//
//  TripsManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/14/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "TripsManager.h"

@implementation TripsManager

@synthesize tripPoiView, controller;

- (id) initWithMapViewController:(MapViewController*)mapViewController
{
    if (self = [super init]) {
        self.controller = mapViewController;
    }
    return self;
}

- (void) drawViewForTripPoi:(TripPoi *)poi
{
    [self hideCurrentTripPoiView];
    
    tripPoiView = [[[NSBundle mainBundle] loadNibNamed:@"TripPoiView" owner:self options:nil] objectAtIndex:0];
    [controller.view addSubview:tripPoiView];
    [tripPoiView setFrame:CGRectMake(0, 30, [tripPoiView frame].size.width, [tripPoiView frame].size.height)];
    [tripPoiView stylizeView];
    [[tripPoiView titleLabel] setText:[poi title]];
    if (poi.title != (id)[NSNull null]) {
        [[tripPoiView titleLabel] setText:[poi title]];
    }
    
    if (poi.subtitle != (id)[NSNull null]) {
        [[tripPoiView subtitleLabel] setText:[poi subtitle]];
    }
    
    if (poi.extraAnnotation != nil) {
        if ([poi.extraAnnotation length] <= 30) {
            [[tripPoiView subtitleLabel] setText:[[[tripPoiView subtitleLabel].text stringByAppendingString:@" - "] stringByAppendingString:poi.extraAnnotation]];
            [[tripPoiView detailsLabel] removeFromSuperview];
        } else {
            [[tripPoiView detailsLabel] setText:[poi extraAnnotation]];
        }
    } else {
        [[tripPoiView detailsLabel] removeFromSuperview];
    }
    
    float height = 20;
    for (UIView *view in [tripPoiView subviews]) {
        height = [view frame].size.height + height;
    }
    
    [tripPoiView setFrame:CGRectMake(tripPoiView.frame.origin.x, tripPoiView.frame.origin.y, tripPoiView.frame.size.width, height)];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCurrentTripPoiView)];
    [recognizer setNumberOfTapsRequired:1];
    [tripPoiView addGestureRecognizer:recognizer];
    
    if ([controller currentMapMode] != DetailFixed) {
        [self toggleFixateViewForButton:[(TripView*) [controller detailsView] fixateTogglerButton]];
    }
}

- (void) hideCurrentTripPoiView
{
    if (tripPoiView != nil) {
        [tripPoiView removeFromSuperview];
        tripPoiView = nil;
    }
}

- (void) toggleFixateViewForButton:(UIButton*)button
{
    TripView *view = [controller detailsView];
    if ([controller currentMapMode] != DetailFixed) {
        [button setTitle:NSLocalizedString(@"route_detach_view", nil) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"attach_icon.png"] forState:UIControlStateNormal];
        [[view hiddenTitleLabel] setHidden:NO];
        [button setAlpha:1];
        [UIView animateWithDuration:0.3 animations:^{
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+view.frame.size.height-40, view.frame.size.width, view.frame.size.height)];
        } completion:nil];
        [controller transitionMapToMode:DetailFixed];
    } else {
        [[view hiddenTitleLabel] setHidden:YES];
        [button setTitle:NSLocalizedString(@"route_attach_view", nil) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"attach_icon_h.png"] forState:UIControlStateNormal];
        [button setAlpha:0.5];
        [UIView animateWithDuration:0.3 animations:^{
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-view.frame.size.height+40, view.frame.size.width, view.frame.size.height)];
        } completion:nil];
        [button setTag:0];
        [controller transitionMapToMode:Detail];
    }

}

@end
