//
//  SCENewsItemSource.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsItemSource.h"
#import "SCEPlace.h"
#import "SCENewsStub.h"
#import "SCECategory.h"
#import "SCECategoryList.h"
#import "SCEFeedView.h"
#import "SCENewsViewController.h"
#import "SCENewsTableCell.h"

@implementation SCENewsItemSource

- (UIViewController *)feedView:(SCEFeedView *)feedView didSelectItem:(id)item
{
    SCENewsStub *newsItem = (SCENewsStub *)item;
    SCENewsViewController *detailController = [[SCENewsViewController alloc] initWithNewsStub:newsItem];
    return detailController;
}

- (UITableViewCell *)feedView:(SCEFeedView *)feedView tableCellForItem:(id)item
{
    // TODO: currently depending on cell id existing. figure out better way to do this.
    
    SCENewsStub* newsItem = (SCENewsStub *)item;
    SCENewsTableCell *cell = [[feedView tableView] dequeueReusableCellWithIdentifier:@"SCENewsTableCell"];
    [[cell headlineLabel] setText:[newsItem title]];
    
    [[cell publishDateLabel] setText:
        [NSDateFormatter localizedStringFromDate:[newsItem publicationDate]
                                       dateStyle:NSDateFormatterLongStyle
                                       timeStyle:NSDateFormatterNoStyle]];
    
    return cell;
}

- (id<MKAnnotation>)feedView:(SCEFeedView *)feedView annotationForItem:(id)item
{
    return nil; // no map view for news
}

- (CGFloat)feedView:(SCEFeedView *)feedView tableCellHeightForItem:(id)item
{
    return 72;
}

- (NSString *)defaultCategoryLabelForFeedView:(SCEFeedView *)feedView
{
    return @"All News";
}

@end
