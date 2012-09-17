//
//  SCESearchFeedDialogController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/17/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedSearchDialogController.h"

@implementation SCEFeedSearchDialogController
@synthesize categoryPicker;
@synthesize keywordText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setDelegate:(id<SCEFeedSearchDelegate>)d
{
    _delegate = d;
    [[self categoryPicker] setDelegate:_delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [[self keywordText] setDelegate:self];
    
    // set up categoryPicker to emulate "backgroundTapped" if picker tapped
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(backgroundTapped:)];
    [[self categoryPicker] addGestureRecognizer:tapGesture];
    
}

- (void)viewDidUnload
{
    [self setCategoryPicker:nil];
    [self setKeywordText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)searchButton:(id)sender {
    // pass the inputs on the form to the delegate
    [[self delegate] searchDialog:self
      didSubmitSearchWithCategoryRow:[[self categoryPicker] selectedRowInComponent:0]
                     keywordQuery:[[self keywordText] text]];
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}
@end
