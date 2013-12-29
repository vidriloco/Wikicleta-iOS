//
//  Parking.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 8/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveRecord.h"
#import <GoogleMaps/GoogleMaps.h>
#import "BaseModel.h"
#import "ModelHumanizer.h"

@interface Parking : BaseModel <ModelHumanizer>

@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic) BOOL hasRoof;
@property (nonatomic) BOOL anyoneCanEdit;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *likesCount;
@property (nonatomic, strong) NSNumber *dislikesCount;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userPicURL;

- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSNumber*)remoteId_;
+ (NSDictionary*) parkingsLoaded;

@end
