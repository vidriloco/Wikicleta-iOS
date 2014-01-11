//
//  NSObject+ModelBase.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/10/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "NSObject+ModelBase.h"

@implementation NSObject (ModelBase)

static NSDateFormatter *dateFormatter;

+ (void) buildFrom:(NSArray*)array {}

- (NSDateFormatter*) formatter
{
    if (dateFormatter == NULL) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return dateFormatter;
}

- (NSString*) localizedKindString
{
    return NSLocalizedString([self kindString], nil);
}

- (NSString*) kindString
{
    return nil;
}

@end
