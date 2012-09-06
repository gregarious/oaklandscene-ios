//
//  SCEFeedTableViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedTableViewController.h"
#import "SCEFeedViewController.h"

@implementation SCEFeedTableViewController

// Designated initializer
- (id)initWithCellNibName:(NSString *)s
           feedController:(SCEFeedViewController *)controller
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.cellNibName = s;
        self.feedViewController = controller;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    @throw [NSException exceptionWithName:@"Unsupported initializer"
                                   reason:@"please use initWithCellNibName: instead"
                                 userInfo:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:[self cellNibName] bundle:nil];
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:[self cellNibName]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [self cellNibName];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self feedViewController] itemSelected];
}

@end
