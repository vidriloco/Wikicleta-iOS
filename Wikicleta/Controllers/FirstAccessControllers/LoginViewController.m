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
        [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    }
    return self;
}

- (void) attemptLogin
{
    if ([self validateStringIsNotEmpty:usernameField.text] && [self validateStringIsNotEmpty:passwordField.text]) {
        [self.view endEditing:YES];
        [hud setHidden:NO];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        
        NSDictionary *innerParams = @{@"login": usernameField.text, @"password": passwordField.text};
        NSDictionary *params = @{@"session" : innerParams};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[App urlForResource:@"loginUsers"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *successObject = [jsonParser objectWithString:[operation responseString] error:nil];
            [User buildOrUpdateUserFromDictionary:successObject];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissToMapViewController];
            [[Mixpanel sharedInstance] track:@"On Successful Login" properties:@{
                @"date": [[NSDate new] description]
            }];
            [[Mixpanel sharedInstance] identify:[[User currentUser] stringifiedId]];
            [[Mixpanel sharedInstance].people set:@{
                                                    @"name": [[User currentUser] username],
                                                    @"email": [[User currentUser] email]}];
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
            [[Mixpanel sharedInstance] track:@"On Failed Login" properties:@{
                @"date": [[NSDate new] description]
            }];
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
    
    [LookAndFeel decorateUILabelAsMainViewTitle:titleLabel withLocalizedString:@"login_view_title"];
    [LookAndFeel decorateUILabelAsMainViewSubtitle:subtitleLabel withLocalizedString:@"login_view_subtitle"];

    [LookAndFeel decorateUITextField:usernameField withLocalizedPlaceholder:@"login_username_placeholder"];
    [usernameField fixUI];
 
    [LookAndFeel decorateUITextField:passwordField withLocalizedPlaceholder:@"login_password_placeholder"];
    [passwordField fixUI];
    
    [self loadRightButtonWithString:NSLocalizedString(@"login_button", nil) andStringSelector:@"attemptLogin"];
    
    [[Mixpanel sharedInstance] track:@"On Login Page" properties:@{
        @"date": [[NSDate new] description]
    }];
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
