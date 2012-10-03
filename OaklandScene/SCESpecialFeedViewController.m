//
//  SCESpecialsFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialFeedViewController.h"
#import "SCESpecialViewController.h"
#import "SCEFeedView.h"

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
