//
//  App.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/7/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kURLsFile   @"urls.plist"
#define kDev        0
#define kProd       1
#define kClientId       @"cfbf6882027bcbd4f24197b9cefc09aa"
#define kClientSecret   @"78314708ad7342e8d6d0883589d82bab"

#define layersParkings          @"parkings"
#define layersBicycleSharings   @"cycle_stations"
#define layersRoutes            @"routes"
#define layersBicycleLanes      @"cycle_paths"
#define layersWorkshops         @"workshops"
#define layersTips              @"tips"
#define layersCyclingGroups     @"cycling_groups"
#define layersTrips             @"trips"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface App : NSObject

+ (void) initializeWithEnv:(int)env;
+ (CGRect) viewBounds;
+ (CLLocationCoordinate2D) mexicoCityCoordinates;
+ (NSString*) appVersion;
+ (NSString*) backendURL;
+ (NSString*) urlForResource:(NSString *)resource;
+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource;
+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource andReplacementSymbol:(NSString *)symbol withReplacementValue:(NSString *)value;

+ (void) loadURLSet;

@end
