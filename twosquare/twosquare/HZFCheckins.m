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
    checkin1.categoria = @"restaurante";
    checkin1.calificacion = 8;
    checkin1.usuario = @"axelhzf";
    checkin1.fechaCreacion = [NSDate date];
    [checkins.data addObject:checkin1];

    
    HZFCheckin *checkin2 = [[HZFCheckin alloc] init];
    checkin2.nombre = @"Place2";
    checkin2.categoria = @"tienda";
    checkin2.calificacion = 7;
    checkin2.usuario = @"axelhzf";
    checkin2.fechaCreacion = [NSDate date];  
    [checkins.data addObject:checkin2];
    

    HZFCheckin *checkin3 = [[HZFCheckin alloc] init];
    checkin3.nombre = @"Place3";
    checkin3.categoria = @"bar";
    checkin3.calificacion = 7;
    checkin3.usuario = @"axelhzf";
    checkin3.fechaCreacion = [NSDate date];  
    [checkins.data addObject:checkin3];
    
    [checkins.data addObjectsFromArray:checkins.data];
    [checkins.data addObjectsFromArray:checkins.data];
    [checkins.data addObjectsFromArray:checkins.data];
    
    return checkins;
}

@end
