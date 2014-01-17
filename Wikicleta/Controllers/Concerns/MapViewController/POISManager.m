//
//  POISManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/15/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "POISManager.h"

@implementation POISManager

@synthesize controller;

- (id) initWithMapViewController:(MapViewController*)mapViewController
{
    if (self = [super init]) {
        self.controller = mapViewController;
    }
    return self;
}

- (void) prepareMapForPOIEditing
{
    [[controller mapManager] unmountSelectedModelMarkerFromMap];
    [[controller detailsView] setHidden:YES];
    [controller transitionMapToMode:EditShare];
    [[controller mapManager] displayOnEditModeNotification];
}

- (void) restoreMapOnCancelPOIEditing
{
    [[controller mapManager] mountSelectedModelMarkerFromMap];
    [[controller detailsView] setHidden:NO];
    [controller transitionMapToMode:Detail];
}

- (void) restoreMapOnFinishedPOIEditing
{
    [self restoreMapOnCancelPOIEditing];
    [controller hideViewForMarker];
    [[controller mapManager] displaySavedChangesNotification];
}

- (void) confirmPOIDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"question_message", nil)
                                                    message:NSLocalizedString(@"delete_record_message", nil)
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"accept", nil) otherButtonTitles:NSLocalizedString(@"cancel", nil), nil];
    [alert show];
}

- (void) attemptDelete
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.labelText = NSLocalizedString(@"deleting_on", nil);
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    
    NSDictionary *params = @{@"extras": @{@"auth_token": [[User currentUser] token]}};
    
    NSString *resourceType;
    if ([[controller currentlySelectedModel] isKindOfClass:[Tip class]]) {
        resourceType = @"tips";
    } else if ([[controller currentlySelectedModel] isKindOfClass:[Parking class]]) {
        resourceType = @"parkings";
    } else if ([[controller currentlySelectedModel] isKindOfClass:[Workshop class]]) {
        resourceType = @"workshops";
    }
    
    NSString *url = [[App urlForResource:resourceType withSubresource:@"delete"]
                     stringByReplacingOccurrencesOfString:@":id"
                     withString: [NSString stringWithFormat:@"%d", [[[controller currentlySelectedModel] identifier] intValue]]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:nil];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        [hud hide:YES];
        [controller hideViewForMarker];
        [controller transitionMapToMode:Explore];
        [[controller mapManager] displayDeletedNotification];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice_message", nil)
                                                        message:NSLocalizedString(@"could_not_delete_error", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"accept", nil) otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [self attemptDelete];
    }
}

@end
