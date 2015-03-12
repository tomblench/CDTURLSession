//
//  CDTURLSessionFilterContext.h
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDTURLSessionFilterContext : NSObject

@property NSURLRequest *request;
@property NSURLResponse *response;
@property BOOL replayRequest;

@end
