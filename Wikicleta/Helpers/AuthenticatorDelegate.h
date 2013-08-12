//
//  AuthenticatorDelegate.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 11/9/12.
//  Copyright (c) 2012 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthenticatorDelegate <NSObject>
- (void) onAuthenticationWithStatus:(int)status;
@end
