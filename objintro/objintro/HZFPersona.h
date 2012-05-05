//
//  HZFPersona.h
//  objintro
//
//  Created by Axel Hernández Ferrera on 05/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZFPersona : NSObject

@property (strong, nonatomic) NSString *nombre;
@property (strong, nonatomic) NSString *apellido;

-(NSString *)nombreCompleto;

@end
