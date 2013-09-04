//
//  GlobalSettings.h
//  Wikicleta
//
//  Created by Spalatinje on 9/3/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {LayersAtRight, LayersOnSets} LayeringMod;
typedef enum {BlueSet, OrangeSet} LayerGroup;

@interface GlobalSettings : NSObject

+ (void) setMapLayeringMod:(LayeringMod)mod;
+ (void) setSelectedLayers:(NSArray*)layers forGroup:(LayerGroup)group;
+ (NSArray*) layersOnGroup:(LayerGroup)group;
+ (LayeringMod) mapLayeringMod;
+ (BOOL) isLayeringModEnabled:(LayeringMod)layeringMod_;
+ (BOOL) isLayeringModEnabled:(LayeringMod)layeringMod_;

@end
