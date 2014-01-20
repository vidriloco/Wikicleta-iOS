//
//  SettingsViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/18/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

- (void) attemptSave;
- (void) selectPicture;
- (UIImage*) resizeImage:(UIImage*) image toSize:(CGSize)newSize;

@end

@implementation SettingsViewController

@synthesize userPicButton, userBioTextView, usernameTextField, titleLabel, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"profile_your_settings", nil);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImageBackgroundNamed:@"gear_icon_big.png"];
    [self loadNavigationBarDefaultStyle];
    [self loadLeftButtonWithString:NSLocalizedString(@"close", nil) andStringSelector:@"dismiss"];
    [self loadRightButtonWithString:NSLocalizedString(@"save", nil) andStringSelector:@"attemptSave"];
    
    [LookAndFeel decorateUITextView:userBioTextView withLocalizedPlaceholder:@"userbio_placeholder"];
    [LookAndFeel decorateUITextField:usernameTextField withLocalizedPlaceholder:@"username_placeholder"];
    
    [usernameTextField setText:[User currentUser].username];
    [userBioTextView setText:[User currentUser].bio];

    [LookAndFeel decorateUILabelAsMainViewTitle:titleLabel withLocalizedString:@"user_settings_instructions"];
    [userBioTextView fixUI];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [userPicButton addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) attemptSave
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"updating", nil);
    [hud setLabelFont:[LookAndFeel defaultFontBookWithSize:15]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithData:UIImageJPEGRepresentation([userPicButton imageView].image, 0.5)], 1.0);
        NSString *imageOnBase64 = [imageData base64Encoding];
        NSString *username = [usernameTextField text];
        NSString *userBio = [userBioTextView text];
        NSString *url = [App urlForResource:@"profiles" withSubresource:@"post" andReplacementSymbol:@":id" withReplacementValue:[NSString stringWithFormat:@"%d", [[User currentUser].identifier intValue]]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"user" : @{@"image_pic": imageOnBase64,
                                             @"username": username,
                                             @"bio": userBio},
                                 @"extras" : @{@"auth_token" : [[User currentUser] token]}};
        
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self dismiss];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
        }];

    });
    

    
    
    }

- (UIImage*) resizeImage:(UIImage*) image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) selectPicture
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    NSLog(@"selecting pic");
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)dismissTap:(id)sender
{
    [userBioTextView resignFirstResponder];
    [usernameTextField resignFirstResponder];
}

- (UIScrollView*) scrollableView {
    return scrollView;
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernameTextField) {
        [userBioTextView becomeFirstResponder];
    }
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [userPicButton setImage:image forState:UIControlStateNormal];
    [[userPicButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [userPicButton.layer setCornerRadius:45];
    userPicButton.layer.masksToBounds = YES;
    [picker dismissModalViewControllerAnimated:YES];
    
}

@end
