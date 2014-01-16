//
//  ModelHumanizer.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/26/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WikiMarker.h"

@protocol ModelHumanizer <NSObject>

@required
- (UIImage*) markerIcon;
- (NSString*) title;
- (NSString*) subtitle;
- (NSDate*) updatedAt;

@optional
- (NSString*) details;
- (NSString*) createdBy;
- (NSString*) likes;
- (NSString*) dislikes;
- (UIImage*) bigIcon;
- (NSString*) extraAnnotation;
- (NSString*) userPicURL;
- (NSNumber*) ownerId;
- (WikiMarker*) marker;
@end
