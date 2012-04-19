//
//  HZFNewCheckinCategoryViewController.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZFNewCheckinCategoryViewController : UITableViewController

@property (strong, nonatomic) NSArray *categories;
@property NSString *selectedCategory;
@property (strong, nonatomic) NSNumber *selectedRow;
@property (weak, nonatomic) id delegate;

- (void)setSelectedCategory:(NSString*)category;

@end
