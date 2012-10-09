//
//  SCEPlaceFeedSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/9/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceFeedSource.h"
#import "SCEPlace.h"

@implementation SCEAnchoredPlaceItem
@synthesize place, distance;

- (id)initWithPlace:(SCEPlace *)p anchor:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        [self setPlace:p];
        CLLocationDegrees dlat = coord.latitude - [p location].latitude;
        CLLocationDegrees dlng = coord.longitude - [p location].longitude;
        [self setDistance:sqrt(dlat*dlat + dlng*dlng)];
    }
    return self;
}
@end

/*---------------------------------------------------------------------*/
/*---------------------------------------------------------------------*/

@implementation SCEPlaceFeedSource

@synthesize anchorCoordinate;

- (void)setAnchorCoordinate:(CLLocationCoordinate2D)coord
{
    anchorCoordinate = coord;
}

- (void)syncWithCompletion:(void (^)(NSError *))block
{
    void (^wrappedBlock)(NSError *);
    wrappedBlock = ^(NSError *err) {
        // sort the newly set items by distance from anchor
        [self sortItems];
        block(err);
    };
    [super syncWithCompletion:wrappedBlock];
}

- (void)sortItems
{
    if ([self items] && anchorCoordinate.latitude != 0 && anchorCoordinate.longitude != 0) {
        //  TODO: optimize if necessary. lots of copying going on here.
        NSMutableArray *anchoredPlaces = [NSMutableArray arrayWithCapacity:[[self items] count]];
        for (SCEPlace *place in [self items]) {
            [anchoredPlaces addObject:[[SCEAnchoredPlaceItem alloc] initWithPlace:place
                                                                           anchor:anchorCoordinate]];
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                                         ascending:YES];
        NSArray *sorted = [anchoredPlaces sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        NSMutableArray *placesOnly = [NSMutableArray arrayWithCapacity:[[self items] count]];
        for (SCEAnchoredPlaceItem *anchoredPlace in sorted) {
            [placesOnly addObject:[anchoredPlace place]];
        }
        
        _items = [NSArray arrayWithArray:placesOnly];
    }
}


@end
