//
//  LocationManagerDelegate.h
//  Wikicleta
//
//  Created by Alejandro Cruz on 1/19/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@protocol LocationManagerDelegate <NSObject>

@required
- (void) locationUpdated:(CLLocation*)location;

@end
