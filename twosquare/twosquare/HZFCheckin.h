//
//  HZFCheckin.h
//  twosquare
//
//  Created by Axel Hernández Ferrera on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZFCheckin : NSObject

@property (copy, nonatomic) NSString *nombre;
@property (copy, nonatomic) NSString *categoria;
@property double calificacion;

@property double latitud;
@property double longitud;

@property (copy, nonatomic) NSString *usuario;
@property (strong, nonatomic) NSDate *fechaCreacion;

@end
