//
//  GlobalSettings.m
//  Wikicleta
//
//  Created by Spalatinje on 9/3/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "GlobalSettings.h"

#define layeringMod @"mapLayeringMod"
#define layersInBlueSet @"blueSetSelected"
#define layersInOrangeSet @"orangeSetSelected"

@implementation GlobalSettings

+ (void) setSelectedLayers:(NSArray*)layers forGroup:(LayerGroup)group {
    if (group == BlueSet) {
        [[NSUserDefaults standardUserDefaults] setObject:layers forKey:layersInBlueSet];
    } else if(group == OrangeSet) {
        [[NSUserDefaults standardUserDefaults] setObject:layers forKey:layersInOrangeSet];
    }
}

+ (void) setMapLayeringMod:(LayeringMod)mod {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:mod] forKey:layeringMod];
}

+ (NSArray*) layersOnGroup:(LayerGroup)group
{
    if (group == BlueSet) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:layersInBlueSet];
    } else if (group == OrangeSet) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:layersInOrangeSet];
    }
    return [NSArray array];
}

+ (LayeringMod) mapLayeringMod
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:layeringMod];
}

+ (BOOL) isLayeringModEnabled:(LayeringMod)layeringMod_
{
    return [GlobalSettings mapLayeringMod] == layeringMod_;
}

@end
