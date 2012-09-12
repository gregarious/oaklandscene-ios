//
//  SCEAPIConnection.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/12/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEAPIConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation SCEAPIConnection

- (id)initWithRequest:(NSURLRequest *)r
{
    self = [super init];
    if (self) {
        [self setRequest:r];
    }
    return self;
}

// defer to designated initializer
- (id)init
{
    return [self initWithRequest:nil];
}

- (void)start
{
    container = [[NSMutableData alloc] init];
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:YES];
    
    // since connection has a delegate-based callback system, we need to ensure
    // the delegate (self) is in memory when connection returns
    if(!sharedConnectionList) {
        sharedConnectionList = [[NSMutableArray alloc] init];
    }
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:container
                                                      options:0
                                                        error:nil];
    [[self jsonRootObject] readFromJSONDictionary:d];
    if ([self completionBlock]) {
        [self completionBlock]([self jsonRootObject], nil);
    }
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self completionBlock]) {
        [self completionBlock](nil, error);
    }
    [sharedConnectionList removeObject:self];
}

@end
