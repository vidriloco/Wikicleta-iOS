//
//  NSObject+FieldValidators.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/23/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define emailRegexp                 @"[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})"
#define usernameRegexp              @"^[a-z0-9_-]{3,16}$"
#define minDescriptionSizeChars     30
#define maxDescriptionSizeChars     200

@interface NSObject (FieldValidators)

- (BOOL) validateStringEqual:(NSString*)stringOne toString:(NSString*)stringTwo;
- (BOOL) validateStringIsNotEmpty:(NSString*)string;
- (BOOL) validateStringAsEmail:(NSString*)string;
- (BOOL) validateStringAsUsername:(NSString*)string;
- (BOOL) validateString:(NSString*)string lengthIsLargerThan:(int)minLength andShorterThan:(int)maxLength;

@end
