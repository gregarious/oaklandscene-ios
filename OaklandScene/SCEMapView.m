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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDataSource:(id<SCEMapViewDataSource>)ds
{
    dataSource = ds;
    [self reloadData];
}

- (void)reloadData
{
    [self removeAnnotations:[self annotations]];
    NSInteger totalAnnotations = [[self dataSource] numberOfAnnotationsInMapView:self];
    for (NSInteger i = 0; i < totalAnnotations; ++i) {
        id<MKAnnotation> ann = [[self dataSource] mapView:self annotationForIndex:i];
        if ([ann coordinate].latitude != 0 && [ann coordinate].longitude != 0) {
            [self addAnnotation:ann];
        }
    }
    [self resizeToAnnotations];
}

- (void)resizeToAnnotations
{
    MKCoordinateRegion region;
    // start with values that will immediately be overridden
    CLLocationDegrees   maxLat = -90,
                        minLat = 90,
                        maxLng = -180,
                        minLng = 180;
    
    if ([[self annotations] count] == 0) {
        // sensible default with no annotations
        region.center = CLLocationCoordinate2DMake(40.4448302, -79.9524878);
        region.span = MKCoordinateSpanMake(.005, .005);
    }
    else {
        for (id<MKAnnotation> ann in [self annotations]) {
            CLLocationDegrees lat = [ann coordinate].latitude;
            CLLocationDegrees lng = [ann coordinate].longitude;
            maxLat = MAX(maxLat, lat);
            minLat = MIN(minLat, lat);
            maxLng = MAX(maxLng, lng);
            minLng = MIN(minLng, lng);
        }
        region.center = CLLocationCoordinate2DMake(minLat+(maxLat-minLat)/2.0,
                                                   minLng+(maxLng-minLng)/2.0);

        // clamp span to at least .001 lat/lng
        region.span = MKCoordinateSpanMake(MAX(maxLat-minLat, .001) * 1.05,
                                           MAX(maxLng-minLng, .001) * 1.05);
        NSLog(@"%f, %f", region.center.latitude, region.center.longitude);
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
