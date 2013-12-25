//
//  LoginViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/29/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    MBProgressHUD *hud;
}

@end


@implementation LoginViewController

@synthesize titleLabel, subtitleLabel, usernameField, passwordField, contentScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.title = NSLocalizedString(@"login_title", nil);
        hud.mode = MBProgressHUDAnimationFade;
        [hud setHidden:YES];
        hud.labelText = NSLocalizedString(@"wait_please", nil);
    }
    return self;
}

- (void) attemptLogin
{
    if ([self validateFieldIsNotEmpty:usernameField] && [self validateFieldIsNotEmpty:passwordField]) {
        [self.view endEditing:YES];
        [hud setHidden:NO];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        
        NSDictionary *innerParams = @{@"login": usernameField.text, @"password": passwordField.text};
        NSDictionary *params = @{@"session" : innerParams};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[App urlForResource:@"loginUsers"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *successObject = [jsonParser objectWithString:[operation responseString] error:nil];
            [User saveUserFromDictionary:successObject];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissToMapViewController];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud setHidden:YES];
            if ([operation.responseString length] == 0) {
                [self showAlertDialogWith:NSLocalizedString(@"could_not_log_in", nil)
                               andContent:NSLocalizedString(@"no_backend_response_error", nil)
                            andTextButton:NSLocalizedString(@"accept", nil)];
            } else {
                [self showAlertDialogWith:NSLocalizedString(@"could_not_log_in", nil)
                               andContent:NSLocalizedString(@"could_not_log_in_explanation", nil)
                            andTextButton:NSLocalizedString(@"accept", nil)];
            }
            
        }];
    }
}

- (void)dismissTap:(id)sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void) dismissToMapViewController
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:[[MapViewController alloc] init] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImageBackgroundNamed:@"hand.png"];
    [self loadNavigationBarDefaultStyle];
    
    [usernameField setPlaceholder:NSLocalizedString(@"login_username_placeholder", nil)];
    [usernameField fixUI];
    [passwordField setPlaceholder:NSLocalizedString(@"login_password_placeholder", nil)];
    [passwordField fixUI];
    
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:25]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
    [titleLabel setText:NSLocalizedString(@"login_view_title", nil)];
   
    [subtitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:13]];
    [subtitleLabel setTextColor:[LookAndFeel blueColor]];
    [subtitleLabel setText:NSLocalizedString(@"login_view_subtitle", nil)];
    [self loadRightButtonWithString:NSLocalizedString(@"login_button", nil) andStringSelector:@"attemptLogin"];
}

#pragma - mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField){
        [self attemptLogin];
    }
    return YES;
}

- (UIScrollView*) scrollableView {
    return contentScrollView;
}

@end
