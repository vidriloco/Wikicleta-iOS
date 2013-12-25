//
//  App.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/7/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import "App.h"

static NSDictionary* urls;
static int environment;

@implementation App

+ (CGRect) viewBounds
{
    return [[UIScreen mainScreen] bounds];
}

+ (CLLocationCoordinate2D) mexicoCityCoordinates
{
    return CLLocationCoordinate2DMake(19.427744, -99.136505);
}

+ (NSString*) appVersion
{
    return @"0.1";
}

+ (NSString*) backendURL
{
  
    if (environment == kDev) {
        return [urls objectForKey:@"backendURLDev"];
    } else {
        return [urls objectForKey:@"backendURL"];
    }
}

+ (NSString*) urlForResource:(NSString *)resource
{
    [self loadURLSet];
    return [[self backendURL] stringByAppendingString:[urls objectForKey:resource]];
}

+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource
{
    [self loadURLSet];
    return [[self backendURL] stringByAppendingString:[[urls objectForKey:resource] objectForKey:subresource]];
}

+ (void) loadURLSet
{
    if(urls == NULL) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:kURLsFile];
        urls = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    }
}

+ (void) initializeWithEnv:(int)env {
    environment = env;
}

@end
