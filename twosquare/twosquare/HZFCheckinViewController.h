//
//  HZFCheckinViewController.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 22/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class HZFCheckin;

@interface HZFCheckinViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) HZFCheckin* checkin;

@end
