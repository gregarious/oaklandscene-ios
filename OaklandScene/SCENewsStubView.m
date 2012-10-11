//
//  SCENewsStubView.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/7/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCENewsStubView.h"

@implementation SCENewsStubView

@synthesize headlineLabel, sourceNameLabel, publicationDateLabel;
@synthesize openSourceButton, blurbLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastSubviewBottomYPos = 0;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // set up the background images
        CGSize sz;
        UIImageView *windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_bkgd.png"]];
        sz = [[windowBackground image] size];
        [windowBackground setFrame:CGRectMake(0, 0, sz.width, sz.height)];
        
        UIImageView *contentBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_content_bkgd.png"]];
        sz = [[contentBackground image] size];
        [contentBackground setFrame:CGRectMake(12, 0, sz.width, sz.height)];
        
        // add the subviews
        [self addSubview:windowBackground];
        [self addSubview:contentBackground];

        // create the various labels and buttons that make up the view
        headlineLabel = [[UILabel alloc] init];
        [headlineLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [headlineLabel setNumberOfLines:0];
        [headlineLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:headlineLabel];
        
        sourceNameLabel = [[UILabel alloc] init];
        [sourceNameLabel setBackgroundColor:[UIColor clearColor]];
        [sourceNameLabel setFont:[UIFont italicSystemFontOfSize:14]];
        [sourceNameLabel setTextColor:[UIColor colorWithWhite:0.43 alpha:1]];
        [self addSubview:sourceNameLabel];
        
        publicationDateLabel = [[UILabel alloc] init];
        [publicationDateLabel setBackgroundColor:[UIColor clearColor]];
        [publicationDateLabel setFont:[UIFont systemFontOfSize:14]];
        [publicationDateLabel setTextColor:[UIColor colorWithWhite:0.43 alpha:1]];
        [self addSubview:publicationDateLabel];
        
        staticSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 0)];
        [staticSourceLabel setText:@"Source:"];
        [staticSourceLabel setBackgroundColor:[UIColor clearColor]];
        [staticSourceLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:staticSourceLabel];
        
        blurbLabel = [[UILabel alloc] init];
        [blurbLabel setBackgroundColor:[UIColor clearColor]];
        [blurbLabel setFont:[UIFont systemFontOfSize:14]];
        [blurbLabel setNumberOfLines:0];
        [self addSubview:blurbLabel];
        
        openSourceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openSourceButton setBackgroundImage:[UIImage imageNamed:@"view_article_btn.png"]
                                    forState:UIControlStateNormal];
        [openSourceButton setTitle:@"Read Full Article"
                          forState:UIControlStateNormal];
        [self addSubview:openSourceButton];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat rasterY = 12.0;
    [[self headlineLabel] setFrame:CGRectMake(24, rasterY, 272, 0)];
    [[self headlineLabel] sizeToFit];
    rasterY += [[self headlineLabel] frame].size.height + 12;
    
    [staticSourceLabel setFrame:CGRectMake(24, rasterY, 0, 0)];
    [staticSourceLabel setFont:[UIFont italicSystemFontOfSize:14]];
    [staticSourceLabel sizeToFit];
    
    CGFloat rasterX = [staticSourceLabel frame].origin.x +
                        [staticSourceLabel frame].size.width;
    rasterX += 4;
    
    [[self sourceNameLabel] setFrame:CGRectMake(rasterX, rasterY, 272-rasterX, 0)];
    [[self sourceNameLabel] sizeToFit];
    rasterY += [[self sourceNameLabel] frame].size.height + 2;
    
    [[self publicationDateLabel] setFrame:CGRectMake(rasterX, rasterY, 272-rasterX, 0)];
    [[self publicationDateLabel] sizeToFit];
    rasterY += [[self publicationDateLabel] frame].size.height + 12;
    
    [[self blurbLabel] setFrame:CGRectMake(24, rasterY, 272, 0)];
    [[self blurbLabel] sizeToFit];
    rasterY += [[self blurbLabel] frame].size.height + 12;
    
    [[self openSourceButton] setFrame:CGRectMake(48, rasterY, 224, 44)];
    rasterY += [[self openSourceButton] frame].size.height + 12;
    
    lastSubviewBottomYPos = rasterY;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, lastSubviewBottomYPos);
}

@end
