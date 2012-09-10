//
//  SCEGeocoded.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol SCEGeocoded <NSObject>

- (CLLocationCoordinate2D *)location;

@end
