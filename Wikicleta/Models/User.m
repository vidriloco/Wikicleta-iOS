//
//  User.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/2/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "User.h"

@interface User () {
    NSString *error;
}

@property (nonatomic, strong) NSString *error;

@end

@implementation User

@synthesize name;
@synthesize email;
@synthesize token;
@synthesize password, passwordConfirmation;
@synthesize error;

+ (id) initWithName:(NSString *)name
          withEmail:(NSString *)email
       withPassword:(NSString *)password
andPasswordConfirmation:(NSString *)confirmation
{
    User *user = [[User alloc] init];
    [user setEmail:email];
    [user setName:name];
    [user setPassword:password];
    [user setPasswordConfirmation:confirmation];
    return user;
}

- (BOOL) save
{
    // Get the local context
    //NSManagedObjectContext *localContext    = [NSManagedObjectContext contextForCurrentThread];
    
    /*UserEntity *userEntity = [UserEntity createInContext:localContext];
    userEntity.name = name;
    userEntity.email = email;
    userEntity.token = token;
    
    // Save the modification in the local context
    // With MagicalRecords 2.0.8 or newer you should use the MR_saveNestedContexts
    return [localContext save:nil];*/
    return NO;
}

- (BOOL) isValidForSave
{
    if(email.length == 0) {
        error = @"No has proporcionado un correo electrónico";
        return NO;
    } 

    if (password.length < 5) {
        error = @"La contraseña proporcionada es muy corta";
        return NO;
    }
    
    if (![password isEqualToString:passwordConfirmation]) {
        error = @"La contraseña y su confirmación deben ser iguales";
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailCheck evaluateWithObject:email]) {
        error = @"El formato del correo proporcionado no es válido";
        return NO;
    }
    return YES;
}

- (NSString*) toJSON
{
    NSMutableDictionary *newUser = [NSMutableDictionary dictionary];
    NSMutableDictionary *user = [NSMutableDictionary dictionary];
    
    [user setObject:name forKey:kName];
    [user setObject:email forKey:kEmail];
    [user setObject:password forKey:kPassword];
    [user setObject:passwordConfirmation forKey:kPasswordConfirmation];
    [newUser setObject:user forKey:@"user"];
    return [newUser JSONRepresentation];
}

- (NSString*) errorMsj
{
    return error;
}

@end
