
//
//  RegistrationViewController.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/30/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

@synthesize name, password, passwordConfirmation, email;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Registro";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)commitRegistrationData:(id)sender
{
  if ([self requiredFieldsFilled]) {
    
    if ([self passwordFieldsMatch]) {
      
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      [manager POST:[App urlForResource:@"createUsers"] parameters:[self registrationDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerta"
                                                        message:@"Ocurrio un problema al realizar el registro"
                                                       delegate:nil
                                              cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil];
        [alert show];
        
      }];
      
    }
    else
    {
      
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerta"
                                                      message:@"Los passwords no coinciden"
                                                     delegate:nil
                                            cancelButtonTitle:@"Aceptar"
                                            otherButtonTitles:nil];
      [alert show];

    }
    
  }
  else
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerta"
                                                    message:@"Todos los campos son requeridos"
                                                   delegate:nil
                                          cancelButtonTitle:@"Aceptar"
                                          otherButtonTitles:nil];
    [alert show];
  }
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self setupUIControls];
      // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *) registrationDictionary
{
  
  NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *registerDictionary = [[NSMutableDictionary alloc] init];
  
  [userDictionary setValue:registerDictionary forKey:@"registration"];
  
  [registerDictionary setValue:name.text forKey:@"full_name"];
  [registerDictionary setValue:@"dummy" forKey:@"name"];
  [registerDictionary setValue:@"misaelpcCool" forKey:@"username"];
  [registerDictionary setValue:email.text forKey:@"email"];
  [registerDictionary setValue:password.text forKey:@"password"];
  [registerDictionary setValue:passwordConfirmation.text forKey:@"password_confirmation"];
  
  return userDictionary;
  
}

- (void)setupUIControls
{
  
  UITapGestureRecognizer *dismissKeyBoardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
  [self.view addGestureRecognizer:dismissKeyBoardTap];

}

- (void)dismissTap:(id)sender
{
  [self.email resignFirstResponder];
  [self.name resignFirstResponder];
  [self.password resignFirstResponder];
  [self.passwordConfirmation resignFirstResponder];
  [UIView animateWithDuration:1.0 animations:^{
    [self.contentScrollView setFrame:CGRectMake(0, 90, 320, 300)];
  } completion:^(BOOL finished) {
    
  }];
  
}

- (BOOL) requiredFieldsFilled
{
  BOOL filled = YES;
  
  if (self.name.text.length == 0) {
    filled = NO;
  }
  else if (self.email.text.length == 0)
  {
    filled = NO;
  }
  else if (self.password.text.length == 0)
  {
    filled = NO;
  }
  else if (self.passwordConfirmation.text == 0)
  {
    filled = NO;
  }
  return filled;
}

- (BOOL) passwordFieldsMatch
{
  if ([self.password.text isEqualToString:self.passwordConfirmation.text]) {
    return YES;
  }
  else
  {
    return NO;
  }
}

#pragma - mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.name) {
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
    [self commitRegistrationData:nil];
  }
  return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
  [self.contentScrollView setContentSize:CGSizeMake(320, 250)];

  [UIView animateWithDuration:1.0 animations:^{
    [self.contentScrollView setFrame:CGRectMake(0, 20, 320, 300)];
  } completion:^(BOOL finished) {
    
  }];
}

@end
