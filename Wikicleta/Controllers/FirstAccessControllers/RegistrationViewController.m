
//
//  RegistrationViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController () {
    MBProgressHUD *hud;
}

- (void) commitRegistration;
- (void) dismissToMapViewController;
- (void) dismiss;
- (void) attemptSignup;

@end

@implementation RegistrationViewController

@synthesize username, password, passwordConfirmation, email, contentScrollView, titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"registration_title", nil);
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        [hud setHidden:YES];
        hud.labelText = NSLocalizedString(@"wait_please", nil);
    }
    return self;
}

- (void) attemptSignup
{
    if ([self requiredFieldsFilled]) {
        if (![self passwordFieldsMatch]) {
            [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                           andContent:NSLocalizedString(@"password_dont_match_error_message", nil)
                        andTextButton:NSLocalizedString(@"accept", nil)];
        } else if(![self validateStringAsUsername:[username text]]) {
            [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                           andContent:NSLocalizedString(@"username_format_error_message", nil)
                        andTextButton:NSLocalizedString(@"accept", nil)];
        } else if(![self validateStringAsEmail:[email text]]) {
            [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                           andContent:NSLocalizedString(@"email_format_error_message", nil)
                        andTextButton:NSLocalizedString(@"accept", nil)];
        } else {
            [self commitRegistration];
        }
    } else {
        [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                       andContent:NSLocalizedString(@"all_fields_required", nil)
                    andTextButton:NSLocalizedString(@"accept", nil)];
    }
}

- (void) commitRegistration
{
    [self.view endEditing:YES];
    [hud setHidden:NO];
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *registerDictionary = [[NSMutableDictionary alloc] init];
    
    [userDictionary setValue:registerDictionary forKey:@"registration"];
    
    [registerDictionary setValue:username.text forKey:@"username"];
    [registerDictionary setValue:email.text forKey:@"email"];
    [registerDictionary setValue:password.text forKey:@"password"];
    [registerDictionary setValue:passwordConfirmation.text forKey:@"password_confirmation"];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[App urlForResource:@"createUsers"] parameters:userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *successObject = [jsonParser objectWithString:[operation responseString] error:nil];
        [User buildOrUpdateUserFromDictionary:successObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self dismissToMapViewController];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud setHidden:YES];

        if ([operation.responseString length] == 0) {
            [self showAlertDialogWith:NSLocalizedString(@"could_not_sign_in", nil)
                           andContent:NSLocalizedString(@"no_backend_response_error", nil)
                        andTextButton:NSLocalizedString(@"accept", nil)];
        } else {
            NSDictionary *errorObject = [jsonParser objectWithString:[operation responseString] error:nil];
            if ([errorObject objectForKey:@"errors"]) {
                if ([[errorObject objectForKey:@"errors"] objectForKey:@"username"]) {
                    [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                                   andContent:NSLocalizedString(@"username_taken_error", nil)
                                andTextButton:NSLocalizedString(@"accept", nil)];
                } else if([[errorObject objectForKey:@"errors"] objectForKey:@"email"]) {
                    [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                                   andContent:NSLocalizedString(@"email_taken_error", nil)
                                andTextButton:NSLocalizedString(@"accept", nil)];
                } else {
                    [self showAlertDialogWith:NSLocalizedString(@"notice_message", nil)
                                   andContent:NSLocalizedString(@"sign_in_error_message", nil)
                                andTextButton:NSLocalizedString(@"accept", nil)];
                }
            }
        }
        
    }];
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dismissToMapViewController
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:[[MapViewController alloc] init] animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImageBackgroundNamed:@"cyclers.png"];
    [self loadNavigationBarDefaultStyle];
    [self loadRightButtonWithString:NSLocalizedString(@"registration_button", nil) andStringSelector:@"attemptSignup"];

    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:13]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
    [titleLabel setText:NSLocalizedString(@"registration_view_title", nil)];
    
    [LookAndFeel decorateUITextField:username withLocalizedPlaceholder:@"registration_username_placeholder"];
    [username fixUI];
    
    [LookAndFeel decorateUITextField:password withLocalizedPlaceholder:@"registration_password_placeholder"];
    [password fixUI];
    
    [LookAndFeel decorateUITextField:passwordConfirmation withLocalizedPlaceholder:@"registration_password_confirmation_placeholder"];
    [passwordConfirmation fixUI];
    
    [LookAndFeel decorateUITextField:email withLocalizedPlaceholder:@"registration_email_placeholder"];
    [email fixUI];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissTap:(id)sender
{
  [self.email resignFirstResponder];
  [self.username resignFirstResponder];
  [self.password resignFirstResponder];
  [self.passwordConfirmation resignFirstResponder];
}

- (BOOL) requiredFieldsFilled
{
    return [self validateStringIsNotEmpty:username.text] ||
    [self validateStringIsNotEmpty:email.text] ||
    [self validateStringIsNotEmpty:password.text] ||
    [self validateStringIsNotEmpty:passwordConfirmation.text];
}

- (BOOL) passwordFieldsMatch
{
    return [self validateStringEqual:self.password.text toString:self.passwordConfirmation.text] && [self validateStringIsNotEmpty:password.text];
}

#pragma - mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.username) {
    [self.email becomeFirstResponder];
  }
  else if (textField == self.email){
    [self.password becomeFirstResponder];
  }
  else if (textField ==  password)
  {
    [self.passwordConfirmation becomeFirstResponder];
  }
  else if (textField == passwordConfirmation)
  {
    [self attemptSignup];
  }
  return YES;
}

- (UIScrollView*) scrollableView {
    return contentScrollView;
}

@end
