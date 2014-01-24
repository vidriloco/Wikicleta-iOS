//
//  Settings.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/24/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "Settings.h"

@implementation Settings


+ (void) updateSetting:(NSString*)setting withObject:(NSObject*)object {
    [[NSUserDefaults standardUserDefaults] setObject:object  forKey:setting];
}

+ (BOOL) settingHoldsTrue:(NSString *)setting
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:setting] == nil) {
        return NO;
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:setting] isEqualToString:@"True"];
}

@end
