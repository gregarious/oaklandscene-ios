//
//  SCENewsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsFeedViewController.h"
#import "SCENewsViewController.h"

@implementation SCENewsFeedViewController

- (id)init
{
    self = [super init];
    
    if (self) {        
        // set up the tab bar entry
        [self setTitle:@"News"];
        // TODO: add tab bar image
        
        // configure nav bar
//        [[self navigationItem] setTitle:@"Latest News"];
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
    UINib *nib = [UINib nibWithNibName:@"SCENewsTableCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"NewsTableCell"];
}


//// UITableViewDataSource methods ////

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"NewsTableCell"];
    return cell;
}

//// UITableViewDelegate methods ////

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCENewsViewController *detailController = [[SCENewsViewController alloc] init];
    [detailController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
