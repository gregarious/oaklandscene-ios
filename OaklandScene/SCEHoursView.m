//
//  SCEHoursView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEHoursView.h"
#import "SCEPlace.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation SCEHoursView

@synthesize hoursArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize sz;
        
        // "Hours" label
        NSString* titleText = @"Hours";
        UIFont *titleFont = [UIFont boldSystemFontOfSize:13];
        sz = [titleText sizeWithFont:titleFont];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:titleFont];
        [titleLabel setText:titleText];

        // clock image
        UIImage *img = [UIImage imageNamed:@"clock.png"];
        UIImageView *clockImage = [[UIImageView alloc] initWithImage:img];
        sz = [img size];
        [clockImage setFrame:CGRectMake(0, 20, sz.width, sz.height)];
        
        [self addSubview:titleLabel];
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
    
    // set up new labels
    UIFont *font = [UIFont systemFontOfSize:11];


    NSMutableArray* newLabels = [NSMutableArray arrayWithCapacity:[hours count]];
    for (SCEPlaceHours *h in hours) {
        // Remove all leading zeros in hours (e.g. 07:00)
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"0(\\d)\\:" options:0 error:nil];
        NSMutableString* hoursText = [NSMutableString stringWithString:[h hours]];
        [regex replaceMatchesInString:hoursText options:0 range:NSMakeRange(0, [hoursText length]) withTemplate:@"$1:"];
        
        // build the label
        NSString *text = [NSString stringWithFormat:@"%@: %@", [h days], hoursText];
        CGSize sz = [text sizeWithFont:font];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
        [label setFont:font];
        [label setText:text];
        [label setBackgroundColor:[UIColor clearColor]];

        // add the label to our internal list and as a subview
        [newLabels addObject:label];
        [self addSubview:label];
    }
    
    hoursLabels = [NSArray arrayWithArray:newLabels];

    // layout the new subviews
    CGFloat rasterY = 20;
    for (UILabel *label in hoursLabels) {
        CGSize sz = [label frame].size;
        [label setFrame:CGRectMake(48, rasterY, sz.width, sz.height)];
        rasterY += sz.height;
    }
    CGPoint origin = [self frame].origin;
    [self setFrame:CGRectMake(origin.x, origin.y, 272, MAX(60, rasterY))];
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
