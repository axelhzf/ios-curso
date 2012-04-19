//
//  HZFNewCheckinViewController.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZFNewCheckinViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *fieldNombre;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) IBOutlet UITableViewCell *categoryCell;

- (IBAction)hideKeyboard;
- (IBAction)save:(UIBarButtonItem *)sender;

@end
