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

#define layersParkings @"parkings"
#define layersBicycleSharings @"bike_sharings"
#define layersRoutes @"routes"
#define layersBicycleLanes @"bicycle_lanes"
#define layersWorkshops @"workshops"
#define layersTips @"tips"

#define isIphone5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface App : NSObject

+ (void) initializeWithEnv:(int)env;
+ (CGRect) windowSize;
+ (CGRect) viewBounds;
+ (CLLocationCoordinate2D) mexicoCityCoordinates;
+ (NSString*) appVersion;
+ (NSString*) backendURL;
+ (NSString*) urlForResource:(NSString *)resource;
+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource;
+ (void) loadURLSet;

+ (NSString*) postfixView;

@end
