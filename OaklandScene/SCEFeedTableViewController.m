//
//  SCEFeedTableViewController.m
//  OaklandScene
//
//  Created by Greg Nicholas on 9/5/12.
//  Copyright (c) 2012 Scenable. All rights reserved.
//

#import "SCEFeedTableViewController.h"
#import "SCEPlaceViewController.h"

@implementation SCEFeedTableViewController

#warning This isn't the designated initializer. Figure out better way to do this.
- (id)initWithStyle:(UITableViewStyle)style
      cellNibName:(NSString *)cellClass;
{
    self = [super initWithStyle:style];
    if (self) {
        self.cellNibName = cellClass;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    @throw [NSException exceptionWithName:@"Unsupported initializer"
                                   reason:@"please use cellNibName: instead"
                                 userInfo:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:[self cellNibName] bundle:nil];
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:[self cellNibName]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [self cellNibName];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning Hard coded Detail VC needs to be pushed up to parent class
    SCEPlaceViewController *detailController = [[SCEPlaceViewController alloc] init];
    [[self navigationController] pushViewController:detailController animated:YES];
}

@end
