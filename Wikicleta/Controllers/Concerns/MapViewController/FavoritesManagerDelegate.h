//
//  FavoritesManagerDelegate.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/18/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelHumanizer.h"

@protocol FavoritesManagerDelegate <NSObject>

@required
- (UIButton*) togglerButton;
- (id<ModelHumanizer>) subjectModel;

@end
