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

@synthesize items, lastSynced, categories;

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
    // TODO: Reenable API-based fetching.
    
    // read in raw JSON data and hand it off to a SCEAPIResponse instance to interpret
    // TODO: error handling for NSData and/or JSON read?
    
    NSString* filename = [[NSBundle mainBundle] pathForResource:@"specials-10032012"
                                                         ofType:@"json"];
    
    NSData* fileData = [NSData dataWithContentsOfFile:filename];
    NSMutableDictionary *d = [NSJSONSerialization JSONObjectWithData:fileData
                                                             options:0
                                                               error:nil];
    SCEAPIResponse *response = [[SCEAPIResponse alloc] init];
    [response readFromJSONDictionary:d];
    
    // Run through the objects in the API response, interpretting them as Events
    NSMutableArray *newSpecials = [[NSMutableArray alloc]
                                   initWithCapacity:[[response objects] count]];
    for (NSDictionary *d in [response objects]) {
        SCESpecial *s = [[SCESpecial alloc] init];
        [s readFromJSONDictionary:d];
        [newSpecials addObject:s];
    }
    [self setItems:newSpecials];
    
    queryResultMap = [[NSMutableDictionary alloc] init];
    
    if (block) {
        block([self items], nil);
    }
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
