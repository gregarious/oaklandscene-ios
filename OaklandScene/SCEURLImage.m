//
//  SCEURLImage.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/28/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEURLImage.h"

@implementation SCEURLImage

static NSMutableArray *sharedConnectionList = nil;

@synthesize image, url;

- (id)init
{
    return [self initWithUrl:nil image:nil];
}

- (id)initWithUrl:(NSURL *)u
{
    return [self initWithUrl:u image:nil];
}

- (id)initWithUrl:(NSURL *)u image:(UIImage *)i
{
    self = [super init];
    if (self) {
        [self setImage:i];
        [self setUrl:u];
    }
    return self;
}

- (void)fetch
{
    buffer = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[self url]];
    internalConnection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self
                                                 startImmediately:YES];
    if (!sharedConnectionList) {
        sharedConnectionList = [NSMutableArray array];
    }
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [buffer setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    image = [UIImage imageWithData:buffer];
    buffer = nil;
    
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [sharedConnectionList removeObject:self];
}


@end
