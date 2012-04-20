//
//  HZFNewCheckinCategoryViewController.m
//  twosquare
//
//  Created by Axel Hernández Ferrera on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFNewCheckinCategoryViewController.h"

@interface HZFNewCheckinCategoryViewController ()
@end

@implementation HZFNewCheckinCategoryViewController

@synthesize categories, selectedRow, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.categories = nil;
    self.delegate = nil;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        
    if([delegate respondsToSelector:@selector(setCategory:)]){
        [delegate setValue:[self selectedCategory] forKey:@"category"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSString *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category;
        
    if(self.selectedRow){
        if(indexPath.row == [self.selectedRow intValue]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
        
    return cell;
}

- (NSArray *)categories {
    if(categories == nil){
        categories = [NSArray arrayWithObjects:@"bar", @"restaurante", @"tienda", nil];
    }
    return categories;
}

- (NSString *)selectedCategory {
    return [self.categories objectAtIndex:self.selectedRow.intValue];
}

- (void)setSelectedCategory:(NSString*)category {
    self.selectedRow = nil;
    for(int i = 0; i < self.categories.count; i++){
        if([[self.categories objectAtIndex:i] isEqualToString:category]){
            self.selectedRow = [NSNumber numberWithInt:i];
            break;
        }
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(selectedRow){
        NSUInteger oldRow = self.selectedRow.intValue;
        NSUInteger newRow = indexPath.row;
        if(oldRow != newRow){
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];            
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    self.selectedRow = [NSNumber numberWithInt:indexPath.row];
}

@end
