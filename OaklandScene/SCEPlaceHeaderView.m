//
//  SCEPlaceHeaderView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceHeaderView.h"

@implementation SCEPlaceHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize sz;
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_header_bkgd.png"]];
        sz = [[background image] size];
        [background setFrame:CGRectMake(0, 0, sz.width, sz.height)];

        [self addSubview:background];
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
