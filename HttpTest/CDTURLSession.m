//
//  CDTURLSession.m
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

#import "CDTURLSession.h"
#import "CDTURLSessionFilterContext.h"

@implementation CDTURLSession

- (id)init
{
    self = [super init];
    if (self) {
        //        _session = [NSURLSession sharedSession];
        _responseFilters = [NSMutableArray array];
    }
    return self;
}

- (void)addResponseFilter:(NSObject<CDTURLSessionResponseFilter>*)filter
{
    [_responseFilters addObject:filter];
}


- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    CDTURLSessionFilterContext *context = [[CDTURLSessionFilterContext alloc] init];
    context.replayRequest = NO;
    context.request = request;
    return [self dataTaskWithContext:context completionHandler:completionHandler];
    
}

- (NSURLSessionDataTask *)dataTaskWithContext:(CDTURLSessionFilterContext*)context
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    // TODO
    // do request
    // run response filter before completion handler
    // retries?
    
    __weak CDTURLSession *weakSelf = self;
    
    NSLog(@"dataTaskWithRequest");
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:context.request completionHandler: ^void (NSData *_data, NSURLResponse *_response, NSError *_error) {
        // create 1st context
        // TODO properly with ctor
        //NSLog(@"Response %@", _response);
        //NSLog(@"Responsefilters %@", _responseFilters);
        
        //NSLog(@"Responsefilters...");
        NSLog(@"Responsefilters %@", _responseFilters);
        CDTURLSessionFilterContext *currentContext = context;
        context.response = _response;
        context.replayRequest = FALSE;
        for (NSObject<CDTURLSessionResponseFilter> *filter in _responseFilters) {
            currentContext = [filter filterWithContext:currentContext];
        }
        NSLog(@"completion handler");
        if (currentContext.replayRequest) {
            NSLog(@"*** REPLAY ***");
            // replay the request, now with the modified request from context
            // TODO retry limiting for recursion avoidance
            CDTURLSession *strongSelf = weakSelf;
            NSURLSessionDataTask *replayTask = [strongSelf dataTaskWithContext:currentContext completionHandler:completionHandler];
            [replayTask resume];
        } else {
            // if we're not replaying then we can call the completion handler
            completionHandler(_data, _response, _error);
        }
    } ];
    return task;
}

@end
