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
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCECategoryPickerDialogController.h"
#import "SCEFeedItemContainer.h"
#import "SCEFeedSource.h"

#import "SCEPlaceTableCell.h"
#import "SCEFeedStaticCell.h"

@implementation SCEPlaceFeedViewController

@synthesize feedSource;

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
        
        contentStore = [SCEPlaceStore sharedStore];
        [self setFeedSource:[[SCEFeedSource alloc] initWithStore:contentStore]];
        
        [self setDelegate:self];    // REFACTOR: yeah... weird.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // register the NIBs for cell reuse
    [tableView registerNib:[UINib nibWithNibName:@"SCEPlaceTableCell" bundle:nil]
        forCellReuseIdentifier:@"PlaceTableCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"SCEFeedLoadingCell" bundle:nil]
        forCellReuseIdentifier:@"FeedLoadingCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"SCEFeedStaticCell" bundle:nil]
    forCellReuseIdentifier:@"FeedStaticCell"];
    
    // REFACTOR: need to figure out where this will go -- FeedVC doesn't need to know about contentStore?
    // if the main store is loaded, reset the feed
//    if ([contentStore isLoaded]) {
//        [self resetFeedFilters];
//    }
//    else {
//        [self addStaticMessageToFeed:@"Places could not be loaded"];
//        [[[self navigationItem] rightBarButtonItem] setEnabled:FALSE];
//    }
}


- (void)setFeedSource:(SCEFeedSource *)fs
{
    // set the loading message
    [self emptyFeed];
    [self addLoadingMessageToFeed];
    pagesDisplayed = 0;
    
    feedSource = fs;
    [feedSource setDelegate:self];
    [feedSource sync];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForItem:(SCEFeedItemContainer *)itemContainer
{
    if ([itemContainer type] == SCEFeedItemTypeLoading) {
        return [tv dequeueReusableCellWithIdentifier:@"FeedLoadingCell"];
    }
    else if([itemContainer type] == SCEFeedItemTypeObject) {
        SCEPlace* place = [itemContainer content];
        SCEPlaceTableCell *cell = [tv dequeueReusableCellWithIdentifier:@"PlaceTableCell"];
        [[cell nameLabel] setText:[place name]];
        [[cell addressLabel] setText:[place streetAddress]];

        if ([place urlImage]) {
            [[cell thumbnail] setImage:[[place urlImage] image]];
        }
        else {
            [[cell thumbnail] setImage:nil];    // TODO: stock image?
        }

        NSMutableArray *categoryLabels = [NSMutableArray array];
        for (SCECategory *category in [place categories]) {
            [categoryLabels addObject:[category label]];
        }
        [[cell categoryList] setCategoryLabelTexts:categoryLabels];

        return cell;
    }
    else {  // handle both Static and Action cells
        SCEFeedStaticCell* cell = [tv dequeueReusableCellWithIdentifier:@"FeedStaticCell"];
        [[cell textLabel] setText:[itemContainer content]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForItem:(SCEFeedItemContainer *)itemContainer
{
    if ([itemContainer type] == SCEFeedItemTypeObject) {
        return 72.0;
    }
    else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tv didSelectItem:(SCEFeedItemContainer *)itemContainer
{
    if([itemContainer type] == SCEFeedItemTypeObject) {
        SCEPlace *place = [itemContainer content];
        SCEPlaceViewController *detailController = [[SCEPlaceViewController alloc] initWithPlace:place];
    
        [detailController setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:detailController animated:YES];
    }
    else if([itemContainer type] == SCEFeedItemTypeAction) {
        [displayedItems removeLastObject];
        [self addNextPageToFeed];
        [tableView reloadData];
        
        
        //REFACTOR: reimplement this
//        // scroll list so new items are on top
//        [tableView scrollToRowAtIndexPath:indexPath
//                         atScrollPosition:UITableViewScrollPositionTop
//                                 animated:YES];
    }
}

@end
