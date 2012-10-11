//
//  SCENewsStub.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsStub.h"

@implementation SCENewsStub

@synthesize blurb, url, source, sourceUrl, publicationDate, title;
@synthesize resourceId;

-(void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setBlurb:[d objectForKey:@"blurb"]];
    [self setUrl:[d objectForKey:@"fulltext_url"]];
    [self setSourceUrl:[d objectForKey:@"source_site"]];
    [self setSource:[d objectForKey:@"source_name"]];
    [self setTitle:[d objectForKey:@"title"]];
    [self setResourceId:[d objectForKey:@"id"]];
    
    // set publicate date
    // TODO: error handling?
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    [self setPublicationDate:[fmt dateFromString:[d objectForKey:@"publication_date"]]];
}

@end
