//
//  FormBaseViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/23/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "FormBaseViewController.h"

@interface FormBaseViewController () {
    id activeTextView;
    CGPoint originalScrollOffset;
    CGSize kbSize;
}

- (void) setupUIControls;

@end

@implementation FormBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUIControls];

    originalScrollOffset = CGPointZero;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self subscribeToKeyboardEvents:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self subscribeToKeyboardEvents:NO];
}

- (void) setupUIControls
{
    UITapGestureRecognizer *dismissKeyBoardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
    [self.view addGestureRecognizer:dismissKeyBoardTap];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextView = (id) textField;
    [self positionKeyBoardUnderActiveField];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    activeTextView = nil;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    activeTextView = (id) textView;
    [self positionKeyBoardUnderActiveField];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    activeTextView = nil;
}

- (void)subscribeToKeyboardEvents:(BOOL)subscribe{
    if(subscribe){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self positionKeyBoardUnderActiveField];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (IS_OS_7_OR_LATER) {
        [[self scrollableView] setContentOffset:originalScrollOffset animated:NO];
        originalScrollOffset = CGPointZero;
    } else {
        originalScrollOffset = CGPointZero;
        [[self scrollableView] setContentOffset:originalScrollOffset animated:NO];
    }
}

- (void) positionKeyBoardUnderActiveField {
    // get the keyboard height
    double keyboardHeight = kbSize.height;
    // save the position of the scroll view, so that we can scroll it to its original position when keyboard disappears.
    if(CGPointEqualToPoint(originalScrollOffset, CGPointZero)) {
        originalScrollOffset = [self scrollableView].contentOffset;
    }
    
    CGPoint cp = [activeTextView convertPoint:[activeTextView bounds].origin toView:self.view];
    cp.y += [activeTextView frame].size.height;
    
    if (!IS_OS_7_OR_LATER) {
        cp.y += 60;
    }
    
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    double sh = bounds.size.height;
    
    // scroll if the keyboard is hiding the text view
    if(cp.y > sh - keyboardHeight){
        double sofset = cp.y - (sh - keyboardHeight);
        CGPoint offset = [self scrollableView].contentOffset;
        offset.y += sofset;
        [[self scrollableView] setContentOffset:offset animated:YES];
    }
}

- (UIScrollView*) scrollableView {
    return nil;
}

- (void)dismissTap:(id)sender {
    
}

@end
