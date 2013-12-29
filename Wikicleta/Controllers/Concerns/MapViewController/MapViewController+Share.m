//
//  MapViewController+Share.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "MapViewController+Share.h"

@implementation MapViewController (Share)

MapMode currentMapMode;

- (void) toggleShareMode
{
    if (currentMapMode == Share) {
        currentMapMode = Find;
    } else {
        currentMapMode = Share;
    }
}

@end
