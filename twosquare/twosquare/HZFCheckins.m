//
//  HZFCheckins.m
//  twosquare
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFCheckins.h"
#import "HZFCheckin.h"

@implementation HZFCheckins

@synthesize data;

- (id) init {
    if (self = [super init]) {
    	data = [NSMutableArray array];
    }
    return self;
}

+ (HZFCheckins *)checkinsWithFakeData {
    HZFCheckins *checkins = [[HZFCheckins alloc] init];

    HZFCheckin *checkin1 = [[HZFCheckin alloc] init];
    checkin1.nombre = @"Place1";
    checkin1.categoria = @"Restaurante";
    checkin1.calificacion = 8;
    checkin1.usuario = @"axelhzf";
    checkin1.fechaCreacion = [NSDate date];
    [checkins.data addObject:checkin1];

    
    HZFCheckin *checkin2 = [[HZFCheckin alloc] init];
    checkin2.nombre = @"Place2";
    checkin2.categoria = @"Tienda";
    checkin2.calificacion = 7;
    checkin2.usuario = @"axelhzf";
    checkin2.fechaCreacion = [NSDate date];
        
    [checkins.data addObject:checkin2];
    
    NSLog(@"fakes %d", [checkins.data count]);
    
    return checkins;
}

@end
