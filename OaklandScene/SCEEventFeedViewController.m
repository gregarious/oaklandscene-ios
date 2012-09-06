//
//  SCEEventsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventFeedViewController.h"
#import "SCEEventViewController.h"

@implementation SCEEventFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set the nib files for subviews
        tableCellNibName = @"SCEEventTableCell";
        mapAnnotationNibName = @"";
        
        // set up the tab bar entry
        [self setTitle:@"Events"];
        // TODO: add tab bar image
        
        // configure nav bar
        [[self navigationItem] setTitle:@"Upcoming Events"];
        [self addViewToggleButton];
        [self addSearchButton];
    }
    
    return self;
}

- (void)itemSelected
{
    SCEEventViewController *detailController = [[SCEEventViewController alloc] init];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
