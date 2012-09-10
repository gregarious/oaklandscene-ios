//
//  SCEPlaceFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceFeedViewController.h"
#import "SCEPlaceViewController.h"
#import "SCEPlace.h"
#import "SCEPlaceStore.h"
#import "SCEPlaceTableCell.h"

@implementation SCEPlaceFeedViewController

- (id)init
{
    self = [super init];
    if (self) {
        // set up the tab bar entry
        [self setTitle:@"Places"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"second"]];
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Places Near You"];
        [self addViewToggleButton];
        [self addSearchButton];

        // initialize the data store
        [self setContentStore:[SCEPlaceStore sharedStore]];
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
    UINib *nib = [UINib nibWithNibName:@"SCEPlaceTableCell" bundle:nil];
    [tableView registerNib:nib
        forCellReuseIdentifier:@"PlaceTableCell"];
}


//// UITableViewDataSource methods ////

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[[self contentStore] items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEPlace* place = [[[SCEPlaceStore sharedStore] items] objectAtIndex:[indexPath row]];
    SCEPlaceTableCell *cell = [tv dequeueReusableCellWithIdentifier:@"PlaceTableCell"];
    [[cell nameLabel] setText:[place name]];
    return cell;
}

//// UITableViewDelegate methods ////

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCEPlace *place = [[[self contentStore] items] objectAtIndex:[indexPath row]];
    SCEPlaceViewController *detailController = [[SCEPlaceViewController alloc] initWithPlace:place];
    
    [detailController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
