//
//  SCESimpleAnnotation.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESimpleAnnotation.h"


@implementation SCESimpleAnnotation

@synthesize coordinate, resourceId;

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coord
                         title:(NSString *)title
                      subtitle:(NSString *)subtitle
                    resourceId:(NSString *)rId
{
    SCESimpleAnnotation *obj = [[SCESimpleAnnotation alloc] init];
    [obj setCoordinate:coord];
    [obj setTitle:title];
    [obj setSubtitle:subtitle];
    [obj setResourceId:rId];
    return obj;
}

@end
