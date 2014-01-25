//
//  DateHelpers.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/25/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelpers : NSObject

+ (NSDate *)begginingOfDay:(NSDate *)date;
+ (NSDate *)endOfDay:(NSDate *)date;

@end
