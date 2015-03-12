//
//  MyCookieLoginFilter.h
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDTURLSessionResponseFilter.h"

@class CDTURLSessionFilterContext;

/**
 Sample implementation of a Response Filter:
 Obtains cookie on receipt of a 401 response code and replays request.
 */

@interface MyCookieLoginFilter : NSObject<CDTURLSessionResponseFilter>

@property NSURL *baseUrl;

- (CDTURLSessionFilterContext*) filterWithContext:(CDTURLSessionFilterContext*)context;
- (NSString*) getCookie;
@end

