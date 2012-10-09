//
//  SCEMapView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/8/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SCEMapViewDataSource.h"

@interface SCEMapView : MKMapView

@property (nonatomic, strong) id<SCEMapViewDataSource> dataSource;

- (void)reloadData;

@end
