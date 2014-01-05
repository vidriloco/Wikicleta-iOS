//
//  NSObject+FieldValidators.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/23/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "NSObject+FieldValidators.h"

@implementation NSObject (FieldValidators)

- (BOOL) validateStringEqual:(NSString *)stringOne toString:(NSString *)stringTwo
{
    return [stringOne isEqualToString:stringTwo];
}

- (BOOL) validateStringIsNotEmpty:(NSString*)string
{
    return string.length != 0;
}

- (BOOL) validateStringAsEmail:(NSString *)string
{
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegexp];
    return [test evaluateWithObject:string];
}

- (BOOL) validateStringAsUsername:(NSString *)string
{
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegexp];
    return [test evaluateWithObject:string];
}

- (BOOL) validateString:(NSString*)string lengthIsLargerThan:(int)minLength andShorterThan:(int)maxLength
{
    return string.length > minLength && string.length < maxLength;
}

@end
