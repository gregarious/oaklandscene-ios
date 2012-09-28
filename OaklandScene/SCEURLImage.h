//
//  SCEURLImage.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/28/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCEURLImage : NSObject <NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *buffer;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *url;

- (id)initWithUrl:(NSURL *)u;
- (id)initWithUrl:(NSURL *)u image:(UIImage *)i;
- (void)fetch;

@end
