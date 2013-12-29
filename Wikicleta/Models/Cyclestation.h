//
//  Cyclestation.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/27/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"
#import "ModelHumanizer.h"

@interface Cyclestation : BaseModel <ModelHumanizer>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSNumber *availableSlots;
@property (nonatomic, strong) NSNumber *availableBikes;
@property (nonatomic, strong) NSString *agency;

@property (nonatomic, strong) NSDate *updatedAt;

- (id) initWithDictionary:(NSDictionary*)dictionary withId:(NSString*)remoteId_;
+ (NSDictionary*) cyclestationsLoaded;

@end
