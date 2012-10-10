//
//  SCEFeaturedImage.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/10/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeaturedImage.h"
#import "SCEURLImage.h"

@implementation SCEFeaturedImage

@synthesize urlImage, caption;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    id urlString = [d objectForKey:@"image"];
    if (urlString && urlString != [NSNull null]) {
        NSURL *url = [NSURL URLWithString:urlString
                            relativeToURL:[NSURL URLWithString:@"http://www.scenable.com/media/"]];
        [self setUrlImage:[[SCEURLImage alloc] initWithUrl:url]];
    }
    else {
        [self setUrlImage:nil];
    }
    [self setCaption:[d objectForKey:@"caption"]];
}

@end
