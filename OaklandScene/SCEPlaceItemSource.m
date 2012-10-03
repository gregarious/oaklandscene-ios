//
//  SCEPlaceItemSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/2/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEPlaceItemSource.h"
#import "SCEPlace.h"
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCEPlaceTableCell.h"
#import "SCEPlaceViewController.h"
#import "SCEFeedView.h"

@implementation SCEPlaceItemSource

- (UIViewController *)feedView:(SCEFeedView *)feedView didSelectItem:(id)item
{
    SCEPlace *place = (SCEPlace *)item;
    SCEPlaceViewController *detailController = [[SCEPlaceViewController alloc] initWithPlace:place];
    return detailController;
}

- (UITableViewCell *)feedView:(SCEFeedView *)feedView tableCellForItem:(id)item
{
    // TODO: currently depending this identifier existing. figure out better way to do this.
    
    SCEPlace* place = (SCEPlace *)item;
    SCEPlaceTableCell *cell = [[feedView tableView] dequeueReusableCellWithIdentifier:@"SCEPlaceTableCell"];
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

- (CGFloat)feedView:(SCEFeedView *)feedView tableCellHeightForItem:(id)item
{
    return 72;
}

- (NSString *)defaultCategoryLabelForFeedView:(SCEFeedView *)feedView
{
    return @"All Places";
}
@end
