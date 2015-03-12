//
//  CDTURLSessionResponseFilter.h
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

@class CDTURLSessionFilterContext;

/**
 A Response Filter is run after the response is obtained from the
 server but before the original completionHandler. The Response
 Filter enables two main behaviours:

 - Modifying the response for every request

 - Replaying a (potentially modified) request by reacting to the
   response. For example, obtaining a cookie on receipt of a 401
   response code, modifying the "Cookie" header of the original
   request, then setting replayRequest to YES to replay the request
   with the new "Cookie" header.
 */
@protocol CDTURLSessionResponseFilter <NSObject>

- (CDTURLSessionFilterContext*) filterWithContext:(CDTURLSessionFilterContext*)context;

@end
