//
//  HZFCheckinsViewController.m
//  twosquare
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFCheckinsViewController.h"
#import "HZFCheckins.h"
#import "HZFCheckin.h"
#import "HZFCheckinTableViewCell.h"

@interface HZFCheckinsViewController ()

@end

@implementation HZFCheckinsViewController

@synthesize checkins;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkins = [HZFCheckins sharedInstance];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.checkins = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return [self.checkins.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BasicCell";
    HZFCheckinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    HZFCheckin *checkin = [checkins.data objectAtIndex: indexPath.row];    
    cell.checkin = checkin;
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toMapView"]){
        HZFCheckinTableViewCell *cell = (HZFCheckinTableViewCell *)sender;
        id destination = segue.destinationViewController;
        SEL setCheckin = @selector(setCheckin:);
        if([destination respondsToSelector:setCheckin]){
            [destination performSelector:setCheckin withObject:cell.checkin];
        }
    }
}

#pragma mark - Table view delegate

@end
