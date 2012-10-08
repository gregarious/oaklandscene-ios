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

@implementation SCENewsStore

@synthesize items, lastSynced, categories;

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
    lastSynced = [NSDate date];
    
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
    // TODO: Reenable API-based fetching.
    
    // read in raw JSON data and hand it off to a SCEAPIResponse instance to interpret
    // TODO: error handling for NSData and/or JSON read?
    
    NSString* filename = [[NSBundle mainBundle] pathForResource:@"news-10062012"
                                                         ofType:@"json"];
    
    NSData* fileData = [NSData dataWithContentsOfFile:filename];
    NSMutableDictionary *d = [NSJSONSerialization JSONObjectWithData:fileData
                                                             options:0
                                                               error:nil];
    SCEAPIResponse *response = [[SCEAPIResponse alloc] init];
    [response readFromJSONDictionary:d];
    
    // Run through the objects in the API response, interpretting them as Events
    NSMutableArray *newItems = [[NSMutableArray alloc]
                                   initWithCapacity:[[response objects] count]];
    for (NSDictionary *d in [response objects]) {
        SCENewsStub *n = [[SCENewsStub alloc] init];
        [n readFromJSONDictionary:d];
        [newItems addObject:n];
    }
    [self setItems:newItems];
    
    if (block) {
        block([self items], nil);
    }
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
