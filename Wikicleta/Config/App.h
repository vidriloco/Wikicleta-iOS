//
//  App.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/7/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <SinglySDK/SinglySDK.h>

#define kURLsFile   @"urls.plist"
#define kDev        0
#define kProd       1
#define kClientId       @"cfbf6882027bcbd4f24197b9cefc09aa"
#define kClientSecret   @"78314708ad7342e8d6d0883589d82bab"

@interface App : NSObject

+ (void) initializeWithEnv:(int)env;
+ (CGRect) viewBounds;
+ (CLLocationCoordinate2D) mexicoCityCoordinates;
+ (NSString*) appVersion;
+ (NSString*) backendURL;
+ (NSString*) urlForResource:(NSString *)resource;
+ (void) loadURLSet;

@end