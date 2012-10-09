//
//  SCENoticesViewController.m
//  OaklandScene
//
//  Created by Lara Schenck on 10/8/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENoticesViewController.h"

@interface SCENoticesViewController ()

@end

@implementation SCENoticesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPicOfDayImage:nil];
    [self setNoticeText:nil];
    [self setHeaderLogo:nil];
    [self setPublishDate:nil];
    [super viewDidUnload];
}
@end
