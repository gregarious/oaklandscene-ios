//
//  SCEAboutView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEAboutView.h"

@implementation SCEAboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // "About" label
        titleLabel = [[UILabel alloc] init];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [titleLabel setText:@"About"];

        [self addSubview:titleLabel];
        [titleLabel sizeToFit];
    }
    return self;
}

- (void)setAboutText:(NSString *)text
{
    [textLabel removeFromSuperview];
    
    // set up new textLabel
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 272, 0)];
    [textLabel setFont:[UIFont systemFontOfSize:11]];
    [textLabel setText:text];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [textLabel setNumberOfLines:0];

    [self addSubview:textLabel];
    [textLabel sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat titleBottomYPos = [titleLabel frame].size.height;
    CGFloat textBottomYPos = [textLabel frame].size.height;
    return CGSizeMake(size.width, MAX(titleBottomYPos, textBottomYPos));
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
