//
//  SCEPlaceStubView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEPlaceStubDelegate.h"

@interface SCEPlaceStubView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *placePageButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;

@property (weak, nonatomic) id<SCEPlaceStubDelegate> delegate;

- (IBAction)placePageButtonTapped:(id)sender;
- (IBAction)directionsButtonTapped:(id)sender;


@end
