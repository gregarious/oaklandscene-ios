//
//  SCEResultsInfoBar.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEResultsInfoBar.h"

@implementation SCEResultsInfoBar

@synthesize infoLabel, categoryButton;
@synthesize reloadButton, showReloadButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        [[self infoLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [[self infoLabel] setAdjustsFontSizeToFitWidth:YES];
        [[self infoLabel] setTextColor:[UIColor whiteColor]];
        [[self infoLabel] setBackgroundColor:[UIColor clearColor]];
        labelWrapperButton = [[UIBarButtonItem alloc] initWithCustomView:infoLabel];
        
        categoryButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                          style:UIBarButtonItemStyleBordered
                                                         target:nil
                                                         action:nil];
        
        spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                               target:nil
                                                               action:nil];
        
        reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                     target:nil
                                                                     action:nil];
        
        
        toolbar = [[UIToolbar alloc] initWithFrame:frame];
        [self setShowReloadButton:NO];  // will also lay out the items
        
        [toolbar setItems:@[categoryButton, labelWrapperButton]];
        
        [self addSubview:toolbar];
    }
    return self;
}

- (void)setShowReloadButton:(BOOL)show
{
    showReloadButton = show;
    if (show) {
        [toolbar setItems:@[categoryButton, labelWrapperButton, spacer, reloadButton]];
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
