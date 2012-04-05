//
//  HZFCheckinTableViewCell.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZFCheckin;

@interface HZFCheckinTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelUser;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategory;

@property (strong, nonatomic) HZFCheckin *checkin;

@end
