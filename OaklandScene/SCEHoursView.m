//
//  SCEHoursView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEHoursView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation SCEHoursView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize sz;
        
        // "Hours" label
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Hours"];
        sz = [[titleLabel text] sizeWithFont:[titleLabel font]];
        [titleLabel setFrame:CGRectMake(0, 0, sz.width, sz.height)];

        // clock image
        UIImageView *clockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock.png"]];
        sz = [[clockImage image] size];
        [clockImage setFrame:CGRectMake(0, 16, sz.width, sz.height)];
        
        [self addSubview:titleLabel];
        [self addSubview:clockImage];
        
        [self setBounds:CGRectMake(0.0, 0.0, 272, 56)];
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
