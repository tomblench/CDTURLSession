//
//  CDTURLSessionResponseFilter.h
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

@class CDTURLSessionFilterContext;


@protocol CDTURLSessionResponseFilter <NSObject>


- (CDTURLSessionFilterContext*) filterWithContext:(CDTURLSessionFilterContext*)context;

@end
