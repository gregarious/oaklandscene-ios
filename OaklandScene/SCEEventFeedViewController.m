//
//  SCEEventsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventFeedViewController.h"
#import "SCEEventViewController.h"
#import "SCEFeedView.h"

@implementation SCEEventFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Events"];
        // TODO: add tab bar image
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Upcoming Events"];
        [self addViewToggleButton];
        [self addSearchButton];
        
        // TODO: set up feed source
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register the NIBs for cell reuse
    [tableView registerNib:[UINib nibWithNibName:@"SCEEventTableCell" bundle:nil]
           forCellReuseIdentifier:@"SCEEventTableCell"];
}

@end
