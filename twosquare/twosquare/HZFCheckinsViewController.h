//
//  HZFCheckinsViewController.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@class HZFCheckins;

@interface HZFCheckinsViewController : UITableViewController

@property (nonatomic, strong) HZFCheckins *checkins;

@end
