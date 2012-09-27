//
//  SCEHoursView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEHoursView.h"
#import "SCEPlace.h"
#import "SCEUtils.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation SCEHoursView

@synthesize hoursArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastLabelBottomYPos = 0;
        
        // "Hours" label
        titleLabel = [[UILabel alloc] init];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [titleLabel setText:@"Hours"];
        
        [self addSubview:titleLabel];
        [titleLabel sizeToFit];

        // clock image
        UIImage *img = [UIImage imageNamed:@"clock.png"];
        clockImage = [[UIImageView alloc] initWithImage:img];
        [clockImage setFrame:CGRectMake(0, 20, img.size.width, img.size.height)];
        
        [self addSubview:clockImage];
    }
    return self;
}

- (void)setHoursArray:(NSArray *)hours
{
    hoursArray = hours;
    for (UILabel *label in hoursLabels) {
        [label removeFromSuperview];
    }

    CGFloat rasterY = 20;
   
    // set up new labels
    NSMutableArray* newLabels = [NSMutableArray arrayWithCapacity:[hours count]];
    for (SCEPlaceHours *h in hours) {
        // Remove all leading zeros in hours (e.g. 07:00)
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"0(\\d)\\:" options:0 error:nil];
        NSMutableString* hoursText = [NSMutableString stringWithString:[h hours]];
        [regex replaceMatchesInString:hoursText options:0 range:NSMakeRange(0, [hoursText length]) withTemplate:@"$1:"];
        
        // build the label
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setText:[NSString stringWithFormat:@"%@: %@", [h days], hoursText]];
        [label setBackgroundColor:[UIColor clearColor]];

        // set the ypos of this label in the frame
        [label setFrame:CGRectMake(48, rasterY, 224, 0)];
        [label sizeToFit];
        rasterY += label.frame.size.height;

        // add the label to our internal list and as a subview
        [newLabels addObject:label];
        [self addSubview:label];
    }
    hoursLabels = [NSArray arrayWithArray:newLabels];
    lastLabelBottomYPos = rasterY;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat clockBottomYPos = [clockImage frame].origin.y + [clockImage frame].size.height;
    return CGSizeMake(272, MAX(clockBottomYPos, lastLabelBottomYPos));
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
