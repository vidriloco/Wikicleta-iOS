//
//  CTARequestData.h
//  Wikicleta
//
//  Created by Misael Pérez Chamorro on 12/5/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTARequestData : NSObject

@property (nonatomic , strong) NSString *actionPath;
@property (nonatomic , strong) NSString *requestMethod;
@property (nonatomic , strong) NSData *requestBody;
@property (nonatomic , strong) NSURL *baseURL;

@end
