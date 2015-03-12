//
//  CDTURLSessionFilterContext.h
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A Filter Context represents the input or output state of a Request
 Filter or Response Filter
 */

@interface CDTURLSessionFilterContext : NSObject

/**
 On input to a CDTURLSessionRequestFilter or
 CDTURLSessionResponseFilter: the original request, intended to be
 sent to the server

 On output from a CDTURLSessionRequestFilter: the request as modified
 by the filter, intended to be sent to the server

 On output from a CDTURLSessionResponseFilter: if replayRequest set to
 YES, the request to be replayed
 */
@property NSURLRequest *request;

/**
 On input to a CDTURLSessionResponseFilter: the response received from
 the server

 On input to a CDTURLSessionRequestFilter: nil (no response has been
 received yet, since no request has been made at this point)

 On output from a CDTURLSessionRequestFilter or
 CDTURLSessionResponseFilter: the response as modified by the filter
 */
@property NSURLResponse *response;

/**
 On output from a CDTURLSessionResponseFilter: if YES, then replay the
 request
 */
@property BOOL replayRequest;

/**
 Initialise with _request = nil, _response = nil, _replayRequest = NO
 */
- (id) init;

/**
 Initialise with _request = request, _response = nil, _replayRequest =
 NO
 */
- (id) initWithRequest:(NSURLRequest*)request;

@end
