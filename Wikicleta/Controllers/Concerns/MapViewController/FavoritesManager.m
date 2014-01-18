//
//  FavoritesManager.m
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 1/18/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import "FavoritesManager.h"

@interface FavoritesManager () {
    
}

- (void) markFavorite;
- (void) unmarkFavorite;

@end

@implementation FavoritesManager

@synthesize controller;

- (id) initWithController:(id<FavoritesManagerDelegate>)delegateController
{
    if (self = [super init]) {
        self.controller = delegateController;
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
                [self markFavorite];
            } else {
                [self unmarkFavorite];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) toggleFavoritedStatus
{
    [self changeFavoritedStatusForItemWithId:[[controller subjectModel] identifier]
                                     andType:NSStringFromClass([[controller subjectModel] class])];
}

- (void) changeFavoritedStatusForItemWithId:(NSNumber*)itemId andType:(NSString*)type
{
    NSString *mode = [[controller togglerButton] tag] == favoritedTag ? @"unmark" : @"mark";
    NSString *url = [[App urlForResource:@"favorites" withSubresource:@"post"]
                       stringByReplacingOccurrencesOfString:@":mode"
                       withString:mode];
    
    NSDictionary *params = @{@"favorite": @{
                                @"favorited_object_id": itemId,
                                @"favorited_object_type": type,
                                @"user_id": [[User currentUser] identifier]
                            },
                             @"extras": @{
                                @"auth_token": [[User currentUser] token]}
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:nil];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *response = [jsonParser objectWithString:[operation responseString] error:nil];
        if ([[response objectForKey:@"success"] boolValue]) {
            if ([mode isEqualToString:@"mark"]) {
                [self markFavorite];
            } else {
                [self unmarkFavorite];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) markFavorite
{
    [[controller togglerButton] setImage:[UIImage imageNamed:@"favorited_icon"] forState:UIControlStateNormal];
    [[controller togglerButton] setTag:favoritedTag];
}

- (void) unmarkFavorite
{
    [[controller togglerButton] setImage:[UIImage imageNamed:@"non_favorited_icon"] forState:UIControlStateNormal];
    [[controller togglerButton] setTag:unfavoritedTag];
}

@end
