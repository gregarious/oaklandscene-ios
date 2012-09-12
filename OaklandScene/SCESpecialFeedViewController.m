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
    self = [super init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // self will handle all UITableView delegation
    [tableView setDelegate:self];
    [tableView setDataSource:self];

    // register the NIB for cell reuse
    UINib *nib = [UINib nibWithNibName:@"SCESpecialTableCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"SpecialTableCell"];
}

//// UITableViewDataSource methods ////

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"SpecialTableCell"];
    return cell;
}

//// UITableViewDelegate methods ////

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCESpecialViewController *detailController = [[SCESpecialViewController alloc] init];
    [detailController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
