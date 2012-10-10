//
//  SCENewsStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/6/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsStub.h"
#import "SCENewsStore.h"
#import "SCEAPIResponse.h"
#import "SCEAPIConnection.h"

@implementation SCENewsStore

@synthesize items, lastSynced, categories, syncInProgress;

+ (SCENewsStore *)sharedStore
{
    static SCENewsStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCENewsStore alloc] init];
    }
    return staticStore;
}

- (BOOL)isLoaded
{
    return ([self lastSynced] != nil);
}

- (void)setItems:(NSMutableArray *)newsItems
{
    items = [[NSMutableArray alloc] initWithArray:newsItems];
    
    // reset dictionary
    idNewsStubMap = [[NSMutableDictionary alloc] init];
    
    for (SCENewsStub* stub in newsItems) {
        [idNewsStubMap setObject:stub
                          forKey:[stub resourceId]];
    }
    categories = [NSArray array];   // no categories for news
}

- (void)syncContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    // TODO: error handling for JSON read?
    syncInProgress = YES;
    
    // TODO: add time zone support
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"YYYY-MM-dd"];
    
    NSString *urlString = @"http://www.scenable.com/api/v1/news/?format=json&listed=true&limit=0";    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:8];
    
    SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];
    
    // connection will let this response object interpret the JSON
    SCEAPIResponse *rootJSONObj = [[SCEAPIResponse alloc] init];
    [connection setJsonRootObject:rootJSONObj];
    
    // on completed connection, set the internal place cache and call the given
    // block with the next array of places (or on error, just pass it through)
    [connection setCompletionBlock:
     ^void(SCEAPIResponse *response, NSError *err) {
         NSArray *objectsReturned = nil;
         if (response) {
             // Run through the objects in the API response, interpretting them as news items
             NSMutableArray *newItems = [[NSMutableArray alloc]
                                            initWithCapacity:[[response objects] count]];
             for (NSDictionary *d in [response objects]) {
                 SCENewsStub *s = [[SCENewsStub alloc] init];
                 [s readFromJSONDictionary:d];
                 [newItems addObject:s];
             }
             [self setItems:newItems];
             lastSynced = [NSDate date];
             
             objectsReturned = newItems;
         }
         
         syncInProgress = NO;
         if (block) {
             block(objectsReturned, err);
         }
     }];
    
    [connection start];
}

// news is not currently searchable, just call return block with error
- (void)findItemsMatchingQuery:(NSString *)query
                      category:(SCECategory *)category
                      onReturn:(void (^)(NSArray *, NSError *))returnBlock
{
    returnBlock(nil, [NSError errorWithDomain:@"News is not searchable"
                                         code:2
                                     userInfo:nil]);
}

- (SCENewsStub *)itemFromResourceId:(NSString *)rId
{
    return [idNewsStubMap objectForKey:rId];
}

@end
