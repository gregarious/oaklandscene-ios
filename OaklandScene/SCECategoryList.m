//
//  SCECategoryList.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/27/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCECategoryList.h"

@implementation SCECategoryList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCategoryLabelTexts:(NSArray *)strings
{
    // clear out any label subviews
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    CGFloat rasterX = 0;
    for (NSString* text in strings) {
        UILabel *label = [[UILabel alloc] init];
        [label setText:text];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setBackgroundColor:[UIColor lightGrayColor]];
        [label setFrame:CGRectMake(rasterX, 0, 0, 16)];
        [self addSubview:label];
        [label sizeToFit];
        rasterX += [label frame].size.width + 6;
    }
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
