//
//  SCEPlaceFeedViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEPlaceFeedViewController.h"
#import "SCEPlaceViewController.h"

@implementation SCEPlaceFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set the nib files for subviews
        tableCellNibName = @"SCEPlaceTableCell";
        mapAnnotationNibName = @"";

        // set up the tab bar entry
        [self setTitle:@"Places"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"second"]];
        
        // configure nav bar
        [[self navigationItem] setTitle:@"Places Near You"];
        [self addViewToggleButton];
        [self addSearchButton];
    }
    return self;
}

- (void)itemSelected
{
    SCEPlaceViewController *detailController = [[SCEPlaceViewController alloc] init];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
