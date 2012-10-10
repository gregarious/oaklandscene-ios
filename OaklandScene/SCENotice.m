//
//  SCENotice.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/10/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENotice.h"
#import "ISO8601DateFormatter.h"

@implementation SCENotice

@synthesize content, title, dtcreated;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setContent:[d objectForKey:@"content"]];
    [self setContent:[d objectForKey:@"title"]];

    id dtcreatedString = [d objectForKey:@"dtcreated"];
    if (dtcreatedString && dtcreatedString != [NSNull null]) {
        ISO8601DateFormatter *fmt = [[ISO8601DateFormatter alloc] init];
        [self setDtcreated:[fmt dateFromString:dtcreatedString]];
    }
}

@end
