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
    void (^completionBlock)(UIImage *, NSError *);
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *url;

- (id)initWithUrl:(NSURL *)u;
- (void)fetchWithCompletion:(void (^)(UIImage *, NSError *))block;

@end


@interface SCEURLImageStore : NSObject

@property (nonatomic) NSMutableDictionary *storedObjects;
@property (nonatomic) NSURL *baseUrl;

+ (SCEURLImageStore *)sharedStore;

- (void)refreshAll;
- (void)fetchImageWithURLString:(NSString *)url onCompletion:(void (^)(UIImage *, NSError *))block;
- (void)fetchImageWithURLString:(NSString *)url onCompletion:(void (^)(UIImage *, NSError *))block forceRefresh:(BOOL)refresh;

@end
