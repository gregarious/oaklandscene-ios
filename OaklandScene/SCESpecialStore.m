//
//  SCESpecialStore.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialStore.h"
#import "SCEItemStore.h"
#import "SCESpecial.h"
#import "SCEAPIConnection.h"
#import "SCEAPIResponse.h"

@implementation SCESpecialStore

@synthesize items, lastSynced, categories, syncInProgress;

+ (SCESpecialStore *)sharedStore
{
    static SCESpecialStore* staticStore = nil;
    if (!staticStore) {
        staticStore = [[SCESpecialStore alloc] init];
    }
    return staticStore;
}

- (BOOL)isLoaded
{
    return ([self lastSynced] != nil);
}

- (void)setItems:(NSMutableArray *)specials
{
    items = [[NSMutableArray alloc] initWithArray:specials];
    lastSynced = [NSDate date];
    
    // reset dictionary
    idSpecialMap = [[NSMutableDictionary alloc] init];
    
    for (SCESpecial* special in specials) {
        [idSpecialMap setObject:special
                       forKey:[special resourceId]];
    }
    categories = [NSArray array];   // no categories for specials
}

- (void)syncContentWithCompletion:(void (^)(NSArray *, NSError *))block
{
    // TODO: error handling for JSON read?
    syncInProgress = YES;
    
    // TODO: add time zone support
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"YYYY-MM-dd"];
    NSString *isoNowString = [fmt stringFromDate:[NSDate date]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@&dexpires__gte=%@",
                           @"http://www.scenable.com/api/v1/special/?format=json&listed=true&limit=0",
                           isoNowString];
    
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
             // Run through the objects in the API response, interpretting them as Specials
             NSMutableArray *newSpecials = [[NSMutableArray alloc]
                                          initWithCapacity:[[response objects] count]];
             for (NSDictionary *d in [response objects]) {
                 SCESpecial *s = [[SCESpecial alloc] init];
                 [s readFromJSONDictionary:d];
                 [newSpecials addObject:s];
             }
             [self setItems:newSpecials];
             objectsReturned = newSpecials;
             
             queryResultMap = [[NSMutableDictionary alloc] init];
         }
         
         syncInProgress = NO;
         if (block) {
             block(objectsReturned, err);
         }
     }];
    
    [connection start];
}
    
// specials are not currently searchable, just call return block with error
- (void)findItemsMatchingQuery:(NSString *)query
                      category:(SCECategory *)category
                      onReturn:(void (^)(NSArray *, NSError *))returnBlock
{
    returnBlock(nil, [NSError errorWithDomain:@"Specials are not searchable"
                                         code:2
                                     userInfo:nil]);    
}

- (SCESpecial *)itemFromResourceId:(NSString *)rId
{
    return [idSpecialMap objectForKey:rId];
}

@end
