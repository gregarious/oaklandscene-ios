//
//  SCENoticesViewController.h
//  OaklandScene
//
//  Created by Lara Schenck on 10/8/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCENoticesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *noticeText;
@property (weak, nonatomic) IBOutlet UINavigationBar *headerLogo;
@property (weak, nonatomic) IBOutlet UILabel *publishDate;
@property (weak, nonatomic) IBOutlet UIImageView *picOfDayImage;
@end
