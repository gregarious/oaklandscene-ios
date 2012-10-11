//
//  SCECategoryPickerDialog.m
//  OaklandScene
//
//  Created by Greg Nicholas on 10/10/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCECategoryPickerDialog.h"

@implementation SCECategoryPickerDialog

@synthesize picker, toolbar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        toolbar = [[UIToolbar alloc] init];
        [toolbar sizeToFit];
        [self addSubview:toolbar];
        
        picker = [[UIPickerView alloc] init];
        CGRect pickerFrame = [picker frame];
        pickerFrame.size.width = 214;
        [picker setFrame:pickerFrame];
        [self addSubview:picker];
        [self sendSubviewToBack:picker];
        
        [self setClipsToBounds:YES];
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

- (void)didAddSubview:(UIView *)subview
{
    if (subview == picker) {
        CGRect pickerFrameInitial = [picker frame];
        pickerFrameInitial.origin.y = -pickerFrameInitial.size.height;
        [picker setFrame:pickerFrameInitial];
        
        CGRect pickerFrameFinal = [picker frame];
        pickerFrameFinal.origin.y = [toolbar bounds].size.height;

        [UIView transitionWithView:self
                          duration:.2f
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            [picker setFrame:pickerFrameFinal];
                        } completion:NULL];
    }
}

- (void)closeAnimationWithBlock:(void (^)(BOOL finished))completion
{
    CGRect pickerFrameFinal = [picker frame];
    pickerFrameFinal.origin.y = -pickerFrameFinal.size.height;
    
    [UIView transitionWithView:self
                      duration:.2f
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        [picker setFrame:pickerFrameFinal];
                    } completion:completion];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake([toolbar frame].size.width,
                      [picker frame].origin.y + [picker frame].size.height);
}

@end
