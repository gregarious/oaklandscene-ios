//
//  SCEEventItemSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventItemSource.h"
#import "SCEPlace.h"
#import "SCEEvent.h"
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCEFeedView.h"
#import "SCEURLImage.h"
#import "SCEEventViewController.h"
#import "SCEEventTableCell.h"

@implementation SCEEventItemSource

- (UIViewController *)feedView:(SCEFeedView *)feedView didSelectItem:(id)item
{
    SCEEvent *event = (SCEEvent *)item;
    SCEEventViewController *detailController = [[SCEEventViewController alloc] initWithEvent:event];
    return detailController;
}

- (UITableViewCell *)feedView:(SCEFeedView *)feedView tableCellForItem:(id)item
{
    // TODO: currently depending this identifier existing. figure out better way to do this.
    
    SCEEvent* event = (SCEEvent *)item;
    SCEEventTableCell *cell = [[feedView tableView] dequeueReusableCellWithIdentifier:@"SCEEventTableCell"];
    [[cell nameLabel] setText:[event name]];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterLongStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [[cell timeLabel] setText:[fmt stringFromDate:[event startTime]]];
    
    NSString *placeName;
    if ([event place]) {
        placeName = [[event place] name];
    }
    else {
        placeName = [event placePrimitive];
    }
    [[cell placeLabel] setText:[NSString stringWithFormat:@"at %@", placeName]];

    if ([event urlImage]) {
        [[cell thumbnail] setImage:[[event urlImage] image]];
    }
//
//    NSMutableArray *categoryLabels = [NSMutableArray array];
//    for (SCECategory *category in [event categories]) {
//        [categoryLabels addObject:[category label]];
//    }
//    [[cell categoryList] setCategoryLabelTexts:categoryLabels];
    
    return cell;
    
}

- (CGFloat)feedView:(SCEFeedView *)feedView tableCellHeightForItem:(id)item
{
    return 72;
}

- (NSString *)defaultCategoryLabelForFeedView:(SCEFeedView *)feedView
{
    return @"All Events";
}

@end
