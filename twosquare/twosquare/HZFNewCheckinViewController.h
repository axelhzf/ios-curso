//
//  HZFNewCheckinViewController.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HZFNewCheckinViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *fieldNombre;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) IBOutlet UITableViewCell *categoryCell;


@property (strong, nonatomic) IBOutlet UITableViewCell *latitudeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *longitudeCell;

- (IBAction)hideKeyboard;
- (IBAction)save:(UIBarButtonItem *)sender;

- (IBAction)cancelButton:(id)sender;

@end
