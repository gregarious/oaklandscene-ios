//
//  SCESearchDialogController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/14/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCESearchDialogController.h"

@implementation SCESearchDialogController

@synthesize delegate;

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

- (void)viewDidUnload
{
    queryField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)search:(UIButton *)sender {
    if (delegate) {
        [delegate searchDialog:self
   didSubmitSearchWithCategory:0
                  keywordQuery:[queryField text]];
    }
}

@end
