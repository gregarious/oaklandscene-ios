//
//  SCESpecialItemSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/3/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESpecialItemSource.h"
#import "SCEPlace.h"
#import "SCESpecial.h"
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCEFeedView.h"
#import "SCEURLImage.h"
#import "SCESpecialViewController.h"
#import "SCESpecialTableCell.h"
#import "SCESimpleAnnotation.h"

@implementation SCESpecialItemSource

- (UIViewController *)feedView:(SCEFeedView *)feedView didSelectItem:(id)item
{
    SCESpecial *special = (SCESpecial *)item;
    SCESpecialViewController *detailController = [[SCESpecialViewController alloc] initWithSpecial:special];
    return detailController;
}

- (UITableViewCell *)feedView:(SCEFeedView *)feedView tableCellForItem:(id)item
{
    // TODO: currently depending this identifier existing. figure out better way to do this.
    
    SCESpecial* special = (SCESpecial *)item;
    SCESpecialTableCell *cell = [[feedView tableView] dequeueReusableCellWithIdentifier:@"SCESpecialTableCell"];
    [[cell titleLabel] setText:[special title]];
    
    if ([[special place] name]) {
        [[cell placeLabel] setText:[NSString stringWithFormat:@"at %@", [[special place] name]]];
    }
    
    if ([[special place] imageUrl]) {
        [[SCEURLImageStore sharedStore] fetchImageWithURLString:[[special place] imageUrl]
                                                   onCompletion:
         ^void(UIImage *image, NSError *err) {
             if (image) {
                 [[cell thumbnail] setImage:image];
             }
         }];
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterLongStyle];
    NSString *dateString = [fmt stringFromDate:[special expiresDate]];
    [[cell expiresLabel] setText:[NSString stringWithFormat:@"expires %@", dateString]];
    
    return cell;
    
}

- (id<MKAnnotation>)feedView:(SCEFeedView *)feedView annotationForItem:(id)item
{
    SCESpecial* special = (SCESpecial *)item;
    
    SCESimpleAnnotation *annotation = [SCESimpleAnnotation annotationWithCoordinate:[[special place] location]
                                                                              title:[special title]
                                                                           subtitle:[[special place] name]
                                                                         resourceId:[special resourceId]];

    
    return annotation;
}

- (CGFloat)feedView:(SCEFeedView *)feedView tableCellHeightForItem:(id)item
{
    return 72;
}

- (NSString *)defaultCategoryLabelForFeedView:(SCEFeedView *)feedView
{
    return @"All Specials";
}

@end
