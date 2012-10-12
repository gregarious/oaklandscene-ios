//
//  SCEEventItemSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEEventItemSource.h"
#import "SCESimpleAnnotation.h"
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
    // TODO: currently depending on cell id existing. figure out better way to do this.
    
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

    // start off with default image, then load url-based one
    [[cell thumbnail] setImage:[UIImage imageNamed:@"default-event.png"]];
    if ([event imageUrl]) {
        [[SCEURLImageStore sharedStore] fetchImageWithURLString:[event imageUrl]
                                                   onCompletion:
         ^void(UIImage *image, NSError *err) {
            if (image) {
                [[cell thumbnail] setImage:image];
            }
        }];
    }
//
//    NSMutableArray *categoryLabels = [NSMutableArray array];
//    for (SCECategory *category in [event categories]) {
//        [categoryLabels addObject:[category label]];
//    }
//    [[cell categoryList] setCategoryLabelTexts:categoryLabels];
    
    return cell;
}

- (id<MKAnnotation>)feedView:(SCEFeedView *)feedView annotationForItem:(id)item
{
    SCEEvent* event = (SCEEvent *)item;
    
    SCESimpleAnnotation *annotation = [SCESimpleAnnotation annotationWithCoordinate:[[event place] location]
                                                                              title:[event name]
                                                                           subtitle:[[event place] name]
                                                                         resourceId:[event resourceId]];
    
    return annotation;
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
