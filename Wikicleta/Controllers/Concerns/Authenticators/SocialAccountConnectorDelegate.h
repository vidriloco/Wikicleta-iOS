//
//  SocialAccountConnectorDelegate.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 2/28/14.
//  Copyright (c) 2014 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocialAccountConnectorDelegate <NSObject>

- (void) onAccountSelectionPhaseWithAccounts:(NSArray*)accountsList;
- (void) onAuthenticationFinishedWith:(NSDictionary*)dictionary;
- (void) onAuthenticationStarted;
- (void) onAuthenticationFinished;
@end
