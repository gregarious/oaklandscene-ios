//
//  SCESplashView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/10/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESplashView.h"
#import "SCEUtils.h"

@implementation SCESplashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [SCEUtils logRect:frame withLabel:@"image frame"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        SCEResolution screenResolution = [SCEUtils screenResolution];
        if (screenResolution == SCEResolutionRetina4) {
            [imageView setImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
        }
        else if (screenResolution == SCEResolutionRetina3_5) {
            [imageView setImage:[UIImage imageNamed:@"Default@2x~iphone.png"]];
        }
        else {
            [imageView setImage:[UIImage imageNamed:@"Default~iphone.png"]];
        }
        [self addSubview:imageView];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGRect indicatorFrame = [activityIndicator frame];
        indicatorFrame.origin.x = frame.size.width/2.0 - [activityIndicator bounds].size.width/2.0;
        indicatorFrame.origin.y = frame.size.height - [activityIndicator bounds].size.height - 40;
        [activityIndicator setFrame:indicatorFrame];
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
