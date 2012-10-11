//
//  SCENoticesViewController.m
//  OaklandScene
//
//  Created by Lara Schenck on 10/8/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENoticesViewController.h"
#import "SCEAPIConnection.h"
#import "SCENotice.h"
#import "SCEFeaturedImage.h"
#import "SCEURLImage.h"
#import "SCEUtils.h"

@implementation SCENoticesViewController

@synthesize notice, featuredImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imagePullInProgress = noticePullInProgress = NO;
        [self pullImage];
        [self pullNotice];
        
        [self setTitle:@"Notices"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"notices.png"]];
        
        UIImage *logo = [UIImage imageNamed:@"titlebar_logo.png"];
        [[self navigationItem] setTitleView:[[UIImageView alloc] initWithImage:logo]];
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
    [self setPublishDate:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pullImage];
    [self pullNotice];
}

- (void)pullImage
{
    if (![self featuredImage] && !imagePullInProgress) {
        imagePullInProgress = YES;

        // determine size of thumbnail to pull based on device resolution
        NSString *size;
        SCEResolution screenResolution = [SCEUtils screenResolution];
        if (screenResolution == SCEResolutionRetina4) {
            size = @"540x540";
        }
        else if (screenResolution == SCEResolutionRetina3_5) {
            size = @"440x440";
        }
        else {
            size = @"220x220";
        }
        
        NSString *urlString = [NSString
                               stringWithFormat:@"http://www.scenable.com/api/v1/featuredimage/random/?format=json&size=%@", size];

        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];
        [connection setJsonRootObject:[[SCEFeaturedImage alloc] init]];
        [connection setCompletionBlock:^void(id obj, NSError *err) {
            // when API returns, set the featured image property and make
            // a new request to fetch the actual image file
            if (obj) {
                SCEFeaturedImage *featImg = (SCEFeaturedImage *)obj;
                [self setFeaturedImage:featImg];
                [[featImg urlImage] fetchWithCompletion:^(UIImage *img, NSError *err){
                    
                    UIImage *toImage = img;
                    [UIView transitionWithView:[self view]
                                      duration:1.0f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        [[self picOfDayImage] setImage:toImage];
                                    } completion:NULL];
                    
                    
                    [[self picOfDayImage] setImage:img];
                }];
                imagePullInProgress = NO;
            }
        }];
        [connection start];
    }
}

- (void)pullNotice
{
    if (![self notice] && !noticePullInProgress) {
        noticePullInProgress = YES;
        NSString *urlString = @"http://www.scenable.com/api/v1/notice/latest/?format=json";
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        SCEAPIConnection *connection = [[SCEAPIConnection alloc] initWithRequest:req];
        [connection setJsonRootObject:[[SCENotice alloc] init]];
        [connection setCompletionBlock:^void(id obj, NSError *err) {
            if (obj) {
                SCENotice *n = (SCENotice *)obj;
                [self setNotice:n];
                [[self noticeText] setText:[n content]];
                NSString *pub = [NSDateFormatter localizedStringFromDate:[n dtcreated]
                                                               dateStyle:NSDateFormatterLongStyle
                                                               timeStyle:NSDateFormatterShortStyle];
                if (pub) {
                    [[self publishDate] setText:[@"Posted on " stringByAppendingString:pub]];
                }
                else {
                    [[self publishDate] setText:nil];
                }
            }
            noticePullInProgress = NO;
        }];
        [connection start];
    }
}

@end
