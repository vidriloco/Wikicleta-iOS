//
//  EditTipViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "EditTipViewController.h"

@interface EditTipViewController () {
    MBProgressHUD *hud;
}

- (NSDictionary*) generateParams;

@end

@implementation EditTipViewController

@synthesize instructionOne, scrollView, collectionView, tipDescriptionTextView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        [hud setHidden:YES];
        hud.labelText = NSLocalizedString(@"uploading_tip", nil);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LookAndFeel decorateUILabelAsMainViewTitle:instructionOne withLocalizedString:@"tip"];
    
    [LookAndFeel decorateUITextView:tipDescriptionTextView withLocalizedPlaceholder:@"description_placeholder"];
    [tipDescriptionTextView fixUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissTap:(id)sender
{
    [tipDescriptionTextView resignFirstResponder];
}

- (NSArray*) selectableCategories
{
    return @[@"danger", @"alert", @"sightseeing"];
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
    
    return @{
             @"extras": @{@"auth_token": @"jpsJmEZyWyT8PsSZq1pG"},
             @"tip": @{
                     @"content": tipDescriptionTextView.text,
                     @"category": [NSNumber numberWithInt:[collectionView currentlySelectedIndex]],
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
    if (![self validateStringIsNotEmpty:tipDescriptionTextView.text]) {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"description_cannot_be_empty", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
        return;
    }
    
    if (![self validateString:tipDescriptionTextView.text lengthIsLargerThan:minDescriptionSizeChars andShorterThan:maxDescriptionSizeChars]) {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"description_length_out_of_bounds", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
        return;
    }
    
    [self.view endEditing:YES];
    [hud setHidden:NO];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[App urlForResource:@"tips" withSubresource:@"post"] parameters:[self generateParams] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice_message", nil)
                                   message:NSLocalizedString(@"could_not_upload_error", nil)
                                  delegate:self cancelButtonTitle:NSLocalizedString(@"accept", nil) otherButtonTitles:NSLocalizedString(@"save_as_draft", nil), nil];
        [alert show];
    }];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"ToDrafts");
}

@end
