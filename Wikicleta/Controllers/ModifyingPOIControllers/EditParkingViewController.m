//
//  EditParkingViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/29/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "EditParkingViewController.h"

@interface EditParkingViewController () {
    MBProgressHUD *hud;
    Parking *storedParking;
}

- (NSDictionary*) generateParams;

@end

@implementation EditParkingViewController

@synthesize scrollView, instructionOne, parkingDescriptionTextView, collectionView, parkingHasRoofLabel, parkingHasRoofSwitch;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        [hud setHidden:YES];
        hud.labelText = NSLocalizedString(@"uploading_parking", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LookAndFeel decorateUILabelAsMainViewTitle:instructionOne withLocalizedString:@"parking"];
    
    [LookAndFeel decorateUITextView:parkingDescriptionTextView withLocalizedPlaceholder:@"description_placeholder"];
    [parkingDescriptionTextView fixUI];
    
    [LookAndFeel decorateUILabelAsCommon:parkingHasRoofLabel withLocalizedString:@"parking_has_roof"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissTap:(id)sender
{
    [parkingDescriptionTextView resignFirstResponder];
}

- (void) fillInWithDataFrom:(Parking*)parking
{
    [parkingDescriptionTextView setText:parking.details];
    [parkingHasRoofSwitch setOn:parking.hasRoof animated:YES];
    [collectionView bringToFrontViewWithIndex:[parking.kind intValue]-1];
    storedParking = parking;
}

- (NSArray*) selectableCategories
{
    return @[@"government_provided", @"urban_mobiliary", @"venue_provided"];
}

- (UIScrollView*) scrollableView {
    return scrollView;
}

- (SelectOnTapCollectionView*) selectOnTapCollectionView
{
    return collectionView;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [super textViewDidBeginEditing:textView];
    
    if ([[textView text] isEqualToString:NSLocalizedString(@"description_placeholder", nil)]) {
        [textView setText:@""];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [super textViewDidEndEditing:textView];
    if ([[textView text] isEqualToString:@""]) {
        [textView setText:NSLocalizedString(@"description_placeholder", nil)];
    }
    
}

- (NSDictionary*) generateParams
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    
    NSString *roof = [parkingHasRoofSwitch isOn] ? @"1" : @"0";
    
    return @{
             @"extras": [self authPair],
             @"parking": @{
                     @"details": parkingDescriptionTextView.text,
                     @"kind": [NSNumber numberWithInt:[collectionView currentlySelectedIndex]],
                     @"has_roof":roof,
                     @"created_at": [df stringFromDate:currentDate],
                     @"updated_at": [df stringFromDate:currentDate]
                     },
             @"coordinates": @{
                     @"lat": [NSString stringWithFormat:@"%f", selectedCoordinate.latitude],
                     @"lon": [NSString stringWithFormat:@"%f", selectedCoordinate.longitude]}
             };
}

- (void) attemptSave
{
    if (![self validateStringIsNotEmpty:parkingDescriptionTextView.text] || [parkingDescriptionTextView.text isEqualToString:NSLocalizedString(@"description_placeholder", nil)]) {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"description_cannot_be_empty", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
        return;
    }
    
    if (![self validateString:parkingDescriptionTextView.text lengthIsLargerThan:minDescriptionSizeChars andShorterThan:maxDescriptionSizeChars]) {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"description_length_out_of_bounds", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
        return;
    }
    
    [self.view endEditing:YES];
    [hud setHidden:NO];
    
    // Block for failure on the response
    void (^responseOnFailure)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice_message", nil)
                                                        message:NSLocalizedString(@"could_not_upload_error", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"accept", nil) otherButtonTitles:NSLocalizedString(@"save_as_draft", nil), nil];
        [alert show];
    };
    
    // Block for success on the response
    void (^responseOnSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[(MapViewController*) [[self.navigationController viewControllers] objectAtIndex:1] poisManager] restoreMapOnFinishedPOIEditing];
        
        [self.navigationController popViewControllerAnimated:YES];
        [(MapViewController*) [self.navigationController topViewController] displayMapOnPOILocation:selectedCoordinate];
    };
    
    if (selectedMode == New) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[App urlForResource:@"parkings" withSubresource:@"post"] parameters:[self generateParams] success:responseOnSuccess failure:responseOnFailure];
    } else if (selectedMode == Edit) {
        NSString *url = [[App urlForResource:@"parkings" withSubresource:@"put"]
                         stringByReplacingOccurrencesOfString:@":id"
                         withString: [NSString stringWithFormat:@"%d", [storedParking.remoteId intValue]]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager PUT:url parameters:[self generateParams] success:responseOnSuccess failure:responseOnFailure];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"ToDrafts");
}

@end
