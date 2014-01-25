//
//  DateHelpers.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/25/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "DateHelpers.h"

@implementation DateHelpers

+ (NSDate *)begginingOfDay:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 0];
    [components setMinute: 0];
    [components setSecond: 0];
    
    return [gregorian dateFromComponents: components];
    
}

+ (NSDate *)endOfDay:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 23];
    [components setMinute: 59];
    [components setSecond: 59];
    
    return [gregorian dateFromComponents: components];
    
}

@end
