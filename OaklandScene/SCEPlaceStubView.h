//
//  SCEPlaceStubView.h
//  OaklandScene
//
//  Created by Greg Nicholas on 10/4/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCEPlaceStubView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (IBAction)placePageButton:(id)sender;
- (IBAction)directionsButton:(id)sender;


@end
