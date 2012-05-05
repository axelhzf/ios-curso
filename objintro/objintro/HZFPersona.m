//
//  HZFPersona.m
//  objintro
//
//  Created by Axel Hernández Ferrera on 05/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HZFPersona.h"

@implementation HZFPersona

@synthesize nombre, apellido;

-(NSString *)nombreCompleto {
    NSString *nombreCompleto = [NSString stringWithFormat:@"%@ %@", self.nombre, self.apellido];
    return nombreCompleto;
}

@end
