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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set the nib files for subviews
        tableCellNibName = @"SCESpecialTableCell";
        mapAnnotationNibName = @"";
        
        // set up the tab bar entry
        [self setTitle:@"Specials"];
        // TODO: add tab bar image
        
        // configure nav bar
        [[self navigationItem] setTitle:@"Available Specials"];
        [self addViewToggleButton];
        [self addSearchButton];
    }
    
    return self;
}

- (void)itemSelected
{
    SCESpecialViewController *detailController = [[SCESpecialViewController alloc] init];
    [[self navigationController] pushViewController:detailController animated:YES];
}


@end
