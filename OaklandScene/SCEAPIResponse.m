//
//  SCEAPIResponse.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/12/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEAPIResponse.h"

@implementation SCEAPIResponse

@synthesize limit, offset, totalCount, nextURL, previousURL;
@synthesize objects;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    NSNumber *nLimit = [d objectForKey:@"limit"];
    NSNumber *nOffset = [d objectForKey:@"offset"];
    NSNumber *nTotal = [d objectForKey:@"total_count"];
    NSString *sPrev = [d objectForKey:@"previous"];
    NSString *sNext = [d objectForKey:@"next"];
    
    [self setLimit:[nLimit integerValue]];
    [self setOffset:[nOffset integerValue]];
    [self setTotalCount:[nTotal integerValue]];
    [self setPreviousURL:[NSURL URLWithString:sPrev]];
    [self setNextURL:[NSURL URLWithString:sNext]];
    
    [self setObjects:[d objectForKey:@"objects"]];
}

@end
