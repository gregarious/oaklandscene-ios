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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set the nib files for subviews
        tableCellNibName = @"SCENewsTableCell";
        mapAnnotationNibName = @"";
        
        // set up the tab bar entry
        [self setTitle:@"News"];
        // TODO: add tab bar image
        
        // configure nav bar
        [[self navigationItem] setTitle:@"Latest News"];
        [self addSearchButton];
    }
    
    return self;
}

- (void) setViewMode:(NSUInteger)viewMode
{
    if (viewMode != SCEFeedViewModeTable) {
        @throw [NSException exceptionWithName:@"Invalid view mode"
                                       reason:@"only SCEFeedViewModelTable is supported for news feeds"
                                    userInfo:nil];
    }
    [super setViewMode:viewMode];
}

- (void)itemSelected
{
    SCENewsViewController *detailController = [[SCENewsViewController alloc] init];
    [detailController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
