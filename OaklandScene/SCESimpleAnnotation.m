//
//  SCESimpleAnnotation.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESimpleAnnotation.h"


@implementation SCESimpleAnnotation

@synthesize coordinate;

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coord
{
    SCESimpleAnnotation *obj = [[SCESimpleAnnotation alloc] init];
    [obj setCoordinate:coord];
    return obj;
}

@end
