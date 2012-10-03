//
//  SCEFeedView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SCEFeedView.h"
#import "SCEResultsInfoBar.h"

@implementation SCEFeedView

@synthesize searchBar, resultsInfoBar, tableView, mapView, contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set up subviews
    }
    return self;
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
