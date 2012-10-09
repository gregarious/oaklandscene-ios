//
//  SCESimpleAnnotation.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SCESimpleAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *resourceId;

@property (nonatomic) CLLocationCoordinate2D coordinate;

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coord
                         title:(NSString *)title
                      subtitle:(NSString *)subtitle
                    resourceId:(NSString *)rId;

@end
