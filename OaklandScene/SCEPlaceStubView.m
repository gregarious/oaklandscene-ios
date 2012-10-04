//
//  SCEPlaceStubView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceStubView.h"

@implementation SCEPlaceStubView

@synthesize nameLabel, addressLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (IBAction)placePageButton:(id)sender {
    NSLog(@"place button pressed");
}

- (IBAction)directionsButton:(id)sender {
    NSLog(@"directions button pressed");
}
@end