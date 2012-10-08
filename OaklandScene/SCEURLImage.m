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
    return [self initWithUrl:nil];
}

- (id)initWithUrl:(NSURL *)u
{
    self = [super init];
    if (self) {
        [self setUrl:u];
    }
    return self;
}

- (void)fetchWithCompletion:(void (^)(UIImage *, NSError *))block
{
    buffer = [NSMutableData data];
    completionBlock = block;
    
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
    
    if (completionBlock) {
        completionBlock(image, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [sharedConnectionList removeObject:self];
    if (completionBlock) {
        completionBlock(nil, error);
    }
}

@end

@implementation SCEURLImageStore

@synthesize storedObjects;

- (SCEURLImageStore *)init
{
    self = [super init];
    if (self) {
        [self setStoredObjects:[NSMutableDictionary dictionary]];
        [self setBaseUrl:[NSURL URLWithString:@"http://www.scenable.com"]];
    }
    return self;
}

+ (SCEURLImageStore *)sharedStore
{
    static SCEURLImageStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCEURLImageStore alloc] init];
    }
    return staticStore;
}

- (void)fetchImageWithURLString:(NSString *)url
             onCompletion:(void (^)(UIImage *, NSError *))block
{
    return [self fetchImageWithURLString:url
                            onCompletion:block
                            forceRefresh:NO];
}

- (void)fetchImageWithURLString:(NSString *)url
             onCompletion:(void (^)(UIImage *, NSError *))block
             forceRefresh:(BOOL)refresh
{
    SCEURLImage *urlImage = [[self storedObjects] objectForKey:url];
    if (urlImage && [urlImage image]) {
        if (block) {
            block([urlImage image], nil);
        }
    }
    else {
        // otherwise create a new URLImage and fetch it
        NSURL *fullUrl = [NSURL URLWithString:url
                                relativeToURL:[self baseUrl]];
        urlImage = [[SCEURLImage alloc] initWithUrl:fullUrl];
        [[self storedObjects] setObject:urlImage forKey:url];
        [urlImage fetchWithCompletion:block];
    }
}

- (void)refreshAll
{
    id key; // will be NSString
    while ((key = [[self storedObjects] keyEnumerator])) {
        [self fetchImageWithURLString:key
                         onCompletion:nil
                         forceRefresh:YES];
    }
}

@end
