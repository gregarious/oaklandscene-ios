//
//  SCEAboutView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 9/24/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCEAboutView : UIView
{
    UILabel *titleLabel;
    UILabel *textLabel;
}

- (void)setAboutText:(NSString *)text;

@end
