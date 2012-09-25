//
//  SCEAboutView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEAboutView.h"

@implementation SCEAboutView

@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize sz;
        
        // "About" label
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"About"];
        sz = [[titleLabel text] sizeWithFont:[titleLabel font]];
        [titleLabel setFrame:CGRectMake(0, 0, sz.width, sz.height)];
        
        [self addSubview:titleLabel];
        
        // TODO: this is a dummy height for testing purposes
        [self setBounds:CGRectMake(0, 0, 272, 150)];
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
