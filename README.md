# CDTURLSession
Layer on top of NSHTTPURLSession with request/response filters, replaying requests, etc

Some of the concepts and names have been borrowed heavily from [Async Http Client][ahc].

[ahc]: https://github.com/AsyncHttpClient/async-http-client

# Sample Code
The main class (`main.m`) shows an example of POSTing a new json
document to the server, obtaining a session cookie 'on demand' (by
reacting to an HTTP status code).

An instance of `MyCookieLoginFilter` - a class conforming to the
`CDTResponseFilter` protocol - is added to the session's Response
Filters as follows:

```
MyCookieLoginFilter *myLoginFilter = [[MyCookieLoginFilter alloc] init];
myLoginFilter.baseUrl = baseUrl;
[session addResponseFilter:myLoginFilter];
```

MyCookieLoginFilter implements the following method:
```
- (CDTURLSessionFilterContext*) filterWithContext:(CDTURLSessionFilterContext*)context;
```

This method is executed for Response Filters after the response has
been obtained from the server.

The `CDTURLSessionFilterContext` object has a reference to the request
and response. By taking a context object as input and returning one as
output, it is possible to both:
- react to the current request or response
- modify the context (tranform the request before replaying it, or
  transform the response before running the original completion
  handler)

The `MyCookieLoginFilter` class implements the
`filterWithContext:context` method to do the following:
- intercept the "401 Unauthorized" response code
- fetch the new cookie
- replay the original failed request, modified to include the new cookie

Here is the relevant fragment of code:
```
if (((NSHTTPURLResponse*)context.response).statusCode == 401) {
    cookie = [self getCookie];
    // add cookie to request on context
    CDTURLSessionFilterContext *newContext = [[CDTURLSessionFilterContext alloc] init];
    NSMutableURLRequest *filteredRequest = [context.request copy];
    [filteredRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
    newContext.request = filteredRequest;
    newContext.replayRequest = TRUE;
    return newContext;
}
```

When the code is run against a suitable configured server, the outcome
is that the request initially fails, the session cookie is fetched,
and then finally the original request succeeds, resulting in the json
document being successfully uploaded.
