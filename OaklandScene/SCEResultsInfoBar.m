//
//  SCEResultsInfoBar.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEResultsInfoBar.h"

@implementation SCEResultsInfoBar

@synthesize infoLabel, categoryButton, hideCategoryButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hideCategoryButton = false;
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        [[self infoLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [[self infoLabel] setTextColor:[UIColor whiteColor]];
        [[self infoLabel] setBackgroundColor:[UIColor clearColor]];
        labelWrapperButton = [[UIBarButtonItem alloc] initWithCustomView:infoLabel];
        
        categoryButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                          style:UIBarButtonItemStyleBordered
                                                         target:nil
                                                         action:nil];
        
        toolbar = [[UIToolbar alloc] initWithFrame:frame];
        [toolbar setItems:@[categoryButton, labelWrapperButton]];
        
        [self addSubview:toolbar];
    }
    return self;
}

- (void)setHideCategoryButton:(BOOL)shouldHide
{
    hideCategoryButton = shouldHide;
    if (shouldHide) {
        [toolbar setItems:@[labelWrapperButton]];
    }
    else {
        [toolbar setItems:@[categoryButton, labelWrapperButton]];
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
