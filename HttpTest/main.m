//
//  main.m
//  HttpTest
//
//  Created by tomblench on 09/03/2015.
//  Copyright (c) 2015 tomblench. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CDTURLSessionFilterContext.h"
#import "CDTURLSessionResponseFilter.h"
#import "CDTURLSession.h"

#import "MyCookieLoginFilter.h"

NSString *g_username = @"admin";
NSString *g_password = @"admin";


int main(int argc, const char * argv[]) {
    
    CDTURLSession *session = [[CDTURLSession alloc] init];
    
    NSString *bodyData = @"{\"hello\":\"world\"}";
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://localhost:5984"];
    NSURL *doc = [baseUrl URLByAppendingPathComponent:@"/test/123-from-xcode"];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:doc];
    
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:@"100-continue" forHTTPHeaderField:@"Expect"];
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"PUT"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    MyCookieLoginFilter *myLoginFilter = [[MyCookieLoginFilter alloc] init];
    myLoginFilter.baseUrl = baseUrl;
    
    [session addResponseFilter:myLoginFilter];
    __block bool done = NO;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:postRequest
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSLog(@"Data %@ response %@ error %@", data, response, error);
//                                                if (((NSHTTPURLResponse*)response).statusCode != 401)
                                                    done =YES;
                                            }
                                  ];
    [task resume];
    while(!done) {
//        NSLog(@"doing task State %ld", [task state]);
    }

    NSLog(@"done %ld", [task state]);
    
    
    return 0;
}
