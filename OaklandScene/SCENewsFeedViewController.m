//
//  SCENewsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsFeedViewController.h"
#import "SCENewsViewController.h"
#import "SCEFeedView.h"

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
        
        // TODO: set up feed source
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register the NIBs for cell reuse
    [tableView registerNib:[UINib nibWithNibName:@"SCESpecialTableCell" bundle:nil]
           forCellReuseIdentifier:@"SCESpecialTableCell"];
}

@end
