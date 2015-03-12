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

@interface MyCookieLoginFilter : NSObject<CDTURLSessionResponseFilter>

@property NSURL *baseUrl;

- (CDTURLSessionFilterContext*) filterWithContext:(CDTURLSessionFilterContext*)context;
- (NSString*) getCookie;
@end

