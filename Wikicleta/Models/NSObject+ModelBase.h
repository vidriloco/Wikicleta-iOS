//
//  NSObject+ModelBase.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/10/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ModelBase) {

}

+ (void) buildFrom:(NSArray*)array;

- (NSDateFormatter*) formatter;
- (NSString*) localizedKindString;
- (NSString*) kindString;

@end
