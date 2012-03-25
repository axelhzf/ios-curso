//
//  HZFSwitchViewController.h
//  MultiViews
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZFBlueViewController.h"
#import "HZFYellowViewController.h"
#import "HZFRedViewController.h"

@interface HZFSwitchViewController : UIViewController

@property (strong, nonatomic) HZFBlueViewController *blueViewController;
@property (strong, nonatomic) HZFYellowViewController *yellowViewController;
@property (strong, nonatomic) HZFRedViewController *redViewController;

- (IBAction)switchViews:(id)sender;

@end
