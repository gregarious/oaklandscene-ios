//
//  SCEAPIConnection.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/12/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEAPIConnection.h"

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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"places"
                                                         ofType:@"json"];
    
    NSData *rawJSON = [[NSData alloc] initWithContentsOfFile:filePath
                                                     options:NSUTF8StringEncoding
                                                       error:nil];
    
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:rawJSON
                                                         options:0
                                                           error:nil];

    [[self jsonRootObject] readFromJSONDictionary:root];
    if ([self completionBlock]) {
        [self completionBlock]([self jsonRootObject], nil);
    }
}

@end
