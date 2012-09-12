//
//  SCEAPIConnection.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/12/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SCEAPIConnection : NSObject
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);

// will either store an NSDict or an NSArray (depending on the API response)
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

- (id)initWithRequest:(NSURLRequest*)r;

- (void)start;

@end
