//
//  BaseModel.m
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
@synthesize marker, kind;

+ (void) buildFrom:(NSArray*)array {}


- (NSString*) localizedKindString
{
    return NSLocalizedString([self kindString], nil);
}

- (NSString*) kindString
{
    return [categories objectForKey:kind];
}

- (NSString*) title
{
    return nil;
}

- (NSString*) subtitle
{
    return nil;
}

- (NSString*) image
{
    return nil;
}

- (int) identifier
{
    return  -1;
}

@end
