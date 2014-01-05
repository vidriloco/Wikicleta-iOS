//
//  EditWorkshopViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/30/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "EditWorkshopViewController.h"

@interface EditWorkshopViewController ()

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



@end
