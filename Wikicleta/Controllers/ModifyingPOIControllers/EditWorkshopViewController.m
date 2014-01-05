//
//  EditWorkshopViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "EditWorkshopViewController.h"

@interface EditWorkshopViewController () {
    MBProgressHUD *hud;
}

- (NSDictionary*) generateParams;

@end

@implementation EditWorkshopViewController

@synthesize workshopIsStoreLabel, workshopIsStoreSwitch, instructionOne, workshopDescriptionTextView, workshopHoraryTextView, nameTextField, contentScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [workshopHoraryTextView setTag:0];
    [workshopDescriptionTextView setTag:1];
    
    [LookAndFeel decorateUILabelAsMainViewTitle:instructionOne withLocalizedString:@"workshop"];
    
    [LookAndFeel decorateUITextField:nameTextField withLocalizedPlaceholder:@"workshop_name"];
    [nameTextField fixUI];
    
    [LookAndFeel decorateUITextView:workshopDescriptionTextView withLocalizedPlaceholder:@"description_placeholder"];
    [LookAndFeel decorateUITextView:workshopHoraryTextView withLocalizedPlaceholder:@"workshop_horary"];
    [workshopHoraryTextView fixUI];
    [workshopDescriptionTextView fixUI];
    
    [LookAndFeel decorateUILabelAsCommon:workshopIsStoreLabel withLocalizedString:@"workshop_is_store"];
    
    [self.view bringSubviewToFront:contentScrollView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resizeContentScrollToFit:contentScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissTap:(id)sender
{
    [workshopHoraryTextView resignFirstResponder];
    [workshopDescriptionTextView resignFirstResponder];
    [nameTextField resignFirstResponder];
}

- (UIScrollView*) scrollableView {
    return contentScrollView;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [super textViewDidBeginEditing:textView];
    
    if ([[textView text] isEqualToString:NSLocalizedString(@"workshop_horary", nil)] ||
        [[textView text] isEqualToString:NSLocalizedString(@"description_placeholder", nil)]) {
        [textView setText:@""];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [super textViewDidEndEditing:textView];
    if ([[textView text] isEqualToString:@""] && [textView tag] == 0) {
        [textView setText:NSLocalizedString(@"workshop_horary", nil)];
    } else if ([[textView text] isEqualToString:@""] && [textView tag] == 1) {
        [textView setText:NSLocalizedString(@"description_placeholder", nil)];
    }
    
}

#pragma - mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == nameTextField) {
        [nameTextField becomeFirstResponder];
    }
    return YES;
}

- (NSDictionary*) generateParams
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    
    NSString *isStore = [workshopIsStoreSwitch isOn] ? @"1" : @"0";
    
    NSString *schedule = [workshopHoraryTextView.text isEqualToString:NSLocalizedString(@"workshop_horary", nil)] ?  @"" : workshopHoraryTextView.text;
    
    return @{
             @"extras": @{@"auth_token": @"jpsJmEZyWyT8PsSZq1pG"},
             @"workshop": @{
                     @"name": nameTextField.text,
                     @"details": workshopDescriptionTextView.text,
                     @"store": isStore,
                     @"horary": schedule,
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
    if ([nameTextField.text length] == 0) {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"name_cannot_be_empty", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
        return;
    }

    if ([workshopDescriptionTextView.text isEqualToString:NSLocalizedString(@"description_placeholder", nil)]) {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"description_cannot_be_empty", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
        return;
    }
    
    if (![self validateString:workshopDescriptionTextView.text lengthIsLargerThan:minDescriptionSizeChars andShorterThan:maxDescriptionSizeChars]) {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"description_length_out_of_bounds", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
        return;
    }
    
    
    [self.view endEditing:YES];
    [hud setHidden:NO];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[App urlForResource:@"workshops" withSubresource:@"post"] parameters:[self generateParams] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
