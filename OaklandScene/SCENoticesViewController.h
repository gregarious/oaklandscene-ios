//
//  SCENoticesViewController.h
//  OaklandScene
//
//  Created by Lara Schenck on 10/8/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCENotice, SCEFeaturedImage;

@interface SCENoticesViewController : UIViewController
{
    BOOL imagePullInProgress;
    BOOL noticePullInProgress;
}

@property (weak, nonatomic) IBOutlet UILabel *noticeText;
@property (weak, nonatomic) IBOutlet UILabel *publishDate;
@property (weak, nonatomic) IBOutlet UIImageView *picOfDayImage;

@property (nonatomic) SCENotice *notice;
@property (nonatomic) SCEFeaturedImage *featuredImage;

- (void)pullImage;
- (void)pullNotice;

@end
