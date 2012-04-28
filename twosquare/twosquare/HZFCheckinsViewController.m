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

#define kHZFQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface HZFCheckinsViewController ()

@end

@implementation HZFCheckinsViewController

@synthesize checkins;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkins = [HZFCheckins sharedInstance];
    
    
    __weak HZFCheckinsViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{                        
        [weakSelf performSelector:@selector(fetch) withObject:nil afterDelay:2];
    }];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.checkins = nil;
}

- (void)fetch{
    dispatch_async(kHZFQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://axelhzf-ios-tut.herokuapp.com/api/checkins"]];
        NSError* error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        NSMutableArray *jsonCheckins = [NSMutableArray array];
        for(NSDictionary *jsonElement in jsonArray){
            HZFCheckin *checkin = [HZFCheckin checkinFromDictionary:jsonElement];
            [jsonCheckins addObject:checkin];
        }
        [self performSelectorOnMainThread:@selector(fetchedCheckins:) withObject:jsonCheckins waitUntilDone:NO];
    });
}

- (void)fetchedCheckins:(NSMutableArray *)fetchedCheckins {
    self.checkins.data = fetchedCheckins;
    [self.tableView reloadData];
    [self.tableView.pullToRefreshView stopAnimating];
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
    if([segue.identifier isEqualToString:@"toCheckinView"]){
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
