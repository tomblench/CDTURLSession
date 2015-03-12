//
//  CDTURLSessionFilterContext.m
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

#import "CDTURLSessionFilterContext.h"

@implementation CDTURLSessionFilterContext

- (id) init
{
    self = [super init];
    if (self) {
        _replayRequest = FALSE;
    }
    return self;
}

- (id) initWithRequest:(NSURLRequest*)request
{
    self = [super init];
    if (self) {
        _replayRequest = FALSE;
        _request = request;
    }
    return self;
}

@end
