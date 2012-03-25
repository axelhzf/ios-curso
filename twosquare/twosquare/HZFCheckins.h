//
//  HZFCheckins.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZFCheckins : NSObject

@property (strong, nonatomic) NSMutableArray *data;

+ (HZFCheckins *)checkinsWithFakeData;

@end
