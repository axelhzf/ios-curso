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

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject loadFakeData];
    });
    return _sharedObject;
}


- (void)loadFakeData {    
    HZFCheckin *checkin1 = [[HZFCheckin alloc] init];
    checkin1.nombre = @"Place1";
    checkin1.categoria = @"restaurante";
    checkin1.calificacion = 8;
    checkin1.usuario = @"axelhzf";
    checkin1.fechaCreacion = [NSDate date];
    checkin1.latitud = 37.4445;
    checkin1.longitud = -122.1602;
    [self.data addObject:checkin1];
    
    
    HZFCheckin *checkin2 = [[HZFCheckin alloc] init];
    checkin2.nombre = @"Place2";
    checkin2.categoria = @"tienda";
    checkin2.calificacion = 7;
    checkin2.usuario = @"axelhzf";
    checkin2.fechaCreacion = [NSDate date];  
    checkin2.latitud = 48.86223;
    checkin2.longitud = 2.351074;
    [self.data addObject:checkin2];
    
    
    HZFCheckin *checkin3 = [[HZFCheckin alloc] init];
    checkin3.nombre = @"Place3";
    checkin3.categoria = @"bar";
    checkin3.calificacion = 7;
    checkin3.usuario = @"axelhzf";
    checkin3.fechaCreacion = [NSDate date];  
    checkin3.latitud = 40.418889;
    checkin3.longitud = -3.691944;
    [self.data addObject:checkin3];
}

- (void)addCheckin:(HZFCheckin *)checkin {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://axelhzf-ios-tut.herokuapp.com/api/checkins"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[checkin toJson]];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [data addObject:checkin];
}

@end
