//
//  MyCookieLoginFilter.m
//  HttpTest
//
//  Created by tomblench on 12/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

#import "MyCookieLoginFilter.h"
#import "CDTURLSessionFilterContext.h"

extern NSString *g_username;
extern NSString *g_password;

@implementation MyCookieLoginFilter

- (CDTURLSessionFilterContext*) filterWithContext:(CDTURLSessionFilterContext*)context
{
    NSString *cookie;
    NSLog(@"running filter %ld", ((NSHTTPURLResponse*)context.response).statusCode);
    NSLog(@"request %@", context.request);
    NSLog(@"response %@", context.response);
    if (((NSHTTPURLResponse*)context.response).statusCode == 401) {
        cookie = [self getCookie];
        // new context - TODO make a copy constructor for this
        // add cookie to request on context
        CDTURLSessionFilterContext *newContext = [[CDTURLSessionFilterContext alloc] init];
        NSMutableURLRequest *filteredRequest = [context.request copy];
        [filteredRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
        newContext.request = filteredRequest;
        newContext.replayRequest = TRUE;
        return newContext;
    }
    return context;
}

- (NSString*) getCookie
{
    NSLog(@"get cookie");
    
    NSString *bodyData = [NSString stringWithFormat:@"{\"name\":\"%@\",\"password\":\"%@\"}", g_username, g_password];
    __block NSString *cookie;
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[_baseUrl URLByAppendingPathComponent:@"/_session"]];
    
    
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", g_username, g_password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]];
    [postRequest setValue:authString forHTTPHeaderField:@"Authorization"];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    // NB can't use shared session as we are already in a block so the queue will be stalled
    NSURLSession *session = [NSURLSession sessionWithConfiguration:nil];
    __block bool done = NO;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:postRequest
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSLog(@"Data %@ response %@ error %@", data, response, error);
                                                cookie = [[(NSHTTPURLResponse*)response allHeaderFields] valueForKey:@"Set-Cookie"];
                                                NSLog(@"Got cookie %@", cookie);
                                                done = YES;
                                            }
                                  ];
    [task resume];
    while(!done) {
        NSLog(@"getting cookie State %ld", [task state]);
    }
    
    return cookie;
}

@end
