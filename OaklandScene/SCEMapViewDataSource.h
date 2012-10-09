//
//  SCEMapViewDataSource.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/8/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class SCEMapView;

@protocol SCEMapViewDataSource <NSObject>

- (NSInteger)numberOfAnnotationsInMapView:(SCEMapView *)mapView;
- (id<MKAnnotation>)mapView:(SCEMapView *)mapView annotationForIndex:(NSInteger)index;

@end

