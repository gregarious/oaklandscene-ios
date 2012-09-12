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
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self will handle all UITableView delegation
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    // register the NIB for cell reuse
    UINib *nib = [UINib nibWithNibName:@"SCEEventTableCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"EventTableCell"];
}

//// UITableViewDataSource methods ////

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"EventTableCell"];
    return cell;
}

//// UITableViewDelegate methods ////

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEEventViewController *detailController = [[SCEEventViewController alloc] init];
    [detailController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
