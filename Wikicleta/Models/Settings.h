//
//  Settings.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/24/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDisablePedalPowerMessage @"pedal-power-message"

@interface Settings : NSObject

+ (void) updateSetting:(NSString*)setting withObject:(NSObject*)object;
+ (BOOL) settingHoldsTrue:(NSString*)setting;

@end
