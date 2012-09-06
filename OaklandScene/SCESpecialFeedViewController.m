//
//  SCESpecialsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialFeedViewController.h"
#import "SCESpecialViewController.h"

@implementation SCESpecialFeedViewController

- (id)init
{
    self = [super initWithTableCellNibName:@"SCESpecialTableCell" mapAnnotationNibName:nil];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Specials"];
        // TODO: add tab bar image
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Available Specials"];
        [self addViewToggleButton];
        [self addSearchButton];
    }
    
    return self;
}

- (void)itemSelected
{
    SCESpecialViewController *detailController = [[SCESpecialViewController alloc] init];
    [detailController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:detailController animated:YES];
}


@end
