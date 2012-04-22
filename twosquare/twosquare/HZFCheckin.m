//
//  HZFCheckin.m
//  twosquare
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFCheckin.h"

@implementation HZFCheckin

@synthesize nombre, categoria, calificacion, latitud, longitud, usuario, fechaCreacion;


+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter = nil;
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"ddMMMyyyy HH:mm:ss";     
    }
    return dateFormatter;
}

+ (HZFCheckin *)checkinFromDictionary:(NSDictionary *)dictionary {
        
    NSDateFormatter *dateFormatter = [HZFCheckin dateFormatter];
    
    HZFCheckin *checkin = [[HZFCheckin alloc] init];
    checkin.nombre = [dictionary objectForKey:@"nombre"];
    checkin.categoria = [dictionary objectForKey:@"categoria"];
    checkin.calificacion = [[dictionary objectForKey:@"calificacion"] doubleValue]; 
    checkin.latitud = [[dictionary objectForKey:@"latitud"] doubleValue]; 
    checkin.longitud = [[dictionary objectForKey:@"longitud"] doubleValue]; 
    checkin.usuario = [dictionary objectForKey:@"usuario"];
    checkin.fechaCreacion = [dateFormatter dateFromString:[dictionary objectForKey:@"fechaCreacion"]];
    
    return checkin;
}

- (NSData *)toJson {
    NSDateFormatter *dateFormatter = [HZFCheckin dateFormatter];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                nombre,
                                @"nombre",
                                categoria,
                                @"categoria",
                                [NSNumber numberWithDouble:calificacion],
                                @"calificacion",
                                [NSNumber numberWithDouble:latitud],
                                @"latitud",
                                [NSNumber numberWithDouble:longitud],
                                @"longitud",
                                usuario,
                                @"usuario",
                                [dateFormatter stringFromDate:fechaCreacion],
                                @"fechaCreacion"                                
                                , nil];
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}

@end
