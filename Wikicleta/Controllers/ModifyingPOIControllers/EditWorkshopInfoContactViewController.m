//
//  EditWorkshopInfoContactViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "EditWorkshopInfoContactViewController.h"

@implementation EditWorkshopInfoContactViewController

@synthesize workshopHoraryTextView, workshopContactLabel, workshopNameOrTitleLabel, twitterTextField, websiteTextField, telephoneTextField, cellphoneTextField, arrobaLabel, contentScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [twitterTextField fixUI];
    [telephoneTextField fixUI];
    [cellphoneTextField fixUI];
    [websiteTextField fixUI];
    
    [twitterTextField setFont:[LookAndFeel defaultFontLightWithSize:14]];
    [twitterTextField setPlaceholder:NSLocalizedString(@"workshop_twitter", nil)];
    
    [telephoneTextField setFont:[LookAndFeel defaultFontLightWithSize:14]];
    [telephoneTextField setPlaceholder:NSLocalizedString(@"workshop_telephone", nil)];
    
    [cellphoneTextField setFont:[LookAndFeel defaultFontLightWithSize:14]];
    [cellphoneTextField setPlaceholder:NSLocalizedString(@"workshop_cellphone", nil)];
    
    [workshopNameOrTitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [workshopNameOrTitleLabel setText:NSLocalizedString(@"workshop", nil)];
    [workshopNameOrTitleLabel setTextColor:[LookAndFeel blueColor]];
    
    [workshopContactLabel setFont:[LookAndFeel defaultFontLightWithSize:15]];
    [workshopContactLabel setText:NSLocalizedString(@"workshop_info_contact", nil)];
    [workshopContactLabel setTextColor:[LookAndFeel orangeColor]];
    
    [websiteTextField setFont:[LookAndFeel defaultFontLightWithSize:14]];
    [websiteTextField setPlaceholder:NSLocalizedString(@"workshop_website", nil)];
    
    [arrobaLabel setTextColor:[LookAndFeel orangeColor]];
    [arrobaLabel setFont:[LookAndFeel defaultFontBoldWithSize:25]];
    
    [workshopHoraryTextView setFont:[LookAndFeel defaultFontLightWithSize:14]];
    [workshopHoraryTextView setText:NSLocalizedString(@"workshop_horary", nil)];
    [workshopHoraryTextView fixUI];
    [self.view bringSubviewToFront:contentScrollView];

}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [super textViewDidBeginEditing:textView];
    
    if ([[textView text] isEqualToString:NSLocalizedString(@"workshop_horary", nil)]) {
        [textView setText:@""];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [super textViewDidEndEditing:textView];
    if ([[textView text] isEqualToString:@""]) {
        [textView setText:NSLocalizedString(@"workshop_horary", nil)];
    }
}

- (void)dismissTap:(id)sender
{
    [twitterTextField resignFirstResponder];
    [telephoneTextField resignFirstResponder];
    [cellphoneTextField resignFirstResponder];
    [websiteTextField resignFirstResponder];
    [workshopHoraryTextView resignFirstResponder];
}

- (UIScrollView*) scrollableView {
    return contentScrollView;
}

#pragma - mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == twitterTextField){
        [twitterTextField becomeFirstResponder];
    }
    else if (textField == websiteTextField)
    {
        [websiteTextField becomeFirstResponder];
    }
    else if (textField == telephoneTextField)
    {
        [telephoneTextField becomeFirstResponder];
    }
    else if (textField == cellphoneTextField)
    {
        [cellphoneTextField becomeFirstResponder];
    }
    return YES;
}


@end
