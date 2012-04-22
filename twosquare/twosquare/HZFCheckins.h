//
//  HZFCheckins.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HZFCheckin;

@interface HZFCheckins : NSObject

@property (strong, nonatomic) NSMutableArray *data;

+ (id)sharedInstance;
- (void)loadFakeData;
- (void)addCheckin:(HZFCheckin *)checkin;

@end
