//
//  SCEMapView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/8/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEMapView.h"

@implementation SCEMapView

@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame defaultRegion:(MKCoordinateRegion)region
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultRegion:region];
        [self setRegion:region];
    }
    return self;
}

- (void)setDataSource:(id<SCEMapViewDataSource>)ds
{
    dataSource = ds;
    [self reloadDataAndAutoresize:YES];
}

- (void)reloadDataAndAutoresize:(BOOL)shouldAutoresize
{
    BOOL userLocationAlreadyPresent = NO;
    for (id<MKAnnotation> ann in [self annotations]) {
        if ([ann isKindOfClass:[MKUserLocation class]]) {
            userLocationAlreadyPresent = YES;
        }
        else {
            [self removeAnnotation:ann];
        }
    }
    
//    // removes all current annotations and rebuilds them from the data source
//    [self removeAnnotations:[self annotations]];
    
    NSInteger totalAnnotations = [[self dataSource] numberOfAnnotationsInMapView:self];
    for (NSInteger i = 0; i < totalAnnotations; ++i) {
        id<MKAnnotation> ann = [[self dataSource] mapView:self annotationForIndex:i];

        if (userLocationAlreadyPresent && [ann isKindOfClass:[MKUserLocation class]]) {
            continue;   // skip adding the user annotation if it's already there
        }
        if ([ann coordinate].latitude != 0 && [ann coordinate].longitude != 0) {
            [self addAnnotation:ann];
        }
    }
    
    if (shouldAutoresize) {
        [self resizeToAnnotations];
    }
}

- (void)resizeToAnnotations
{
    MKCoordinateRegion region;

    // can't just use [annotations count], need to exclude MKUserLocation
    BOOL hasAnnotations = NO;
    
    // start with values that will immediately be overridden
    CLLocationDegrees maxLat = -90,
                      minLat = 90,
                      maxLng = -180,
                      minLng = 180;

    for (id<MKAnnotation> ann in [self annotations]) {
        // ignore the user location annotation from calculation
        if(![ann isKindOfClass:[MKUserLocation class]]) {
            CLLocationDegrees lat = [ann coordinate].latitude;
            CLLocationDegrees lng = [ann coordinate].longitude;
            maxLat = MAX(maxLat, lat);
            minLat = MIN(minLat, lat);
            maxLng = MAX(maxLng, lng);
            minLng = MIN(minLng, lng);
            hasAnnotations = YES;
        }
    }
    
    if (hasAnnotations) {
        region.center = CLLocationCoordinate2DMake(minLat+(maxLat-minLat)/2.0,
                                                   minLng+(maxLng-minLng)/2.0);

        // clamp span to at least .001 lat/lng
        region.span = MKCoordinateSpanMake(MAX(maxLat-minLat, .001) * 1.1,
                                           MAX(maxLng-minLng, .001) * 1.1);
    }
    else {
        region = [self defaultRegion];
    }
    
    [self setRegion:region animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
