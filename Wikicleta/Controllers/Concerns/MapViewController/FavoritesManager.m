//
//  FavoritesManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/18/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "FavoritesManager.h"

@implementation FavoritesManager

@synthesize controller;

- (id) initWithMapViewController:(MapViewController*)mapViewController
{
    if (self = [super init]) {
        self.controller = mapViewController;
    }
    return self;
}

- (void) reflectFavoritedStatusForItemWithId:(NSNumber *)itemId andType:(NSString *)type
{
    NSString *url = [[[[App urlForResource:@"favorites" withSubresource:@"get_status"]
                     stringByReplacingOccurrencesOfString:@":object_id"
                     withString: [NSString stringWithFormat:@"%d", [itemId intValue]]] stringByReplacingOccurrencesOfString:@":object_type" withString:type]
                     stringByReplacingOccurrencesOfString:@":user_id" withString:[NSString stringWithFormat:@"%d", [[[User currentUser] identifier] intValue]]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            if ([[response objectForKey:@"is_favorite"] boolValue]) {
                [[[controller detailsView] favoriteButton] setImage:[UIImage imageNamed:@"favorited_icon"] forState:UIControlStateNormal];
            } else {
                [[[controller detailsView] favoriteButton] setImage:[UIImage imageNamed:@"non_favorited_icon"] forState:UIControlStateNormal];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
