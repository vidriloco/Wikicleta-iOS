//
//  BaseModel.m
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

@synthesize marker, kind, dateFormatter, remoteId;

+ (void) buildFrom:(NSArray*)array {}


- (NSString*) localizedKindString
{
    return NSLocalizedString([self kindString], nil);
}

- (NSString*) kindString
{
    return [categories objectForKey:kind];
}

- (NSObject*) identifier
{
    return self.remoteId;
}

- (void) loadDateFormatter
{
    if (dateFormatter == NULL) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}

@end
