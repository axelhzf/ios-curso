---
layout : default
title : Modelo
---

# Creación del proyecto

Para crear el proyecto seguiremos los pasos que hemos visto anteriormente `File/New/Project` lo llamamos `twosquare` y en este caso vamos a seleccionar Device Family `Universal`. Esto quiere decir que nuestra aplicación funcionará tanto en un iPhone como en un iPad. Esta es la opción correcta cuando quieres que tu aplicación se pueda utilizar en los dos dispositivos y en ningún caso sacar dos versiones distintas de tu aplicación. Esta es una práctica que suelen llevar a cabo algunos desarrolladores en la App Store y es realmente molesta para los usuarios. Supón que ya has pagado por una aplicación para tu iPhone y tienes que volver a pagar para poder utilizar en el iPad.

Ahora, cuando vayamos a ejecutar la aplicación podemos elegir si queremos abrir el simulador del iPad o el del iPhone. Prueba a arrancar la aplicación con los dos simuladores.

# Modelo

Antes que ponernos a diseñar las pantallas, debemos tener el modelo de datos que va a utilizar la aplicación. En nuestro caso va a ser muy sencillo y constará de dos clases: La primera contendrá los datos de un checkin y la segunda contendrá la lista con todos los checkins.

**HZFCheckin.h**

	@interface HZFCheckin : NSObject
    
	@property (copy, nonatomic) NSString *nombre;
	@property (copy, nonatomic) NSString *categoria;
	@property double calificacion;
     
	@property double latitud;
	@property double longitud;
    
	@property (copy, nonatomic) NSString *usuario;
	@property (strong, nonatomic) NSDate *fechaCreacion;
     
	@end

Puedes ver que esta e la primera vez que estamos variando los parámetros que utilizamos para definir las propiedades. Es común que cuando se declaren NSString se utilice la opción copy, que lo que hace es crear un nuevo objeto con el mismo contenido del anterior. En el caso de las propiedades que no son objetos (los doubles), no se pasa ningún parámetro.

**HZFCheckin.m**

	@implementation HZFCheckin
    
	@synthesize nombre, categoria, calificacion, latitud, longitud, usuario, fechaCreacion;
    
	@end

La implementación consisten sencillamente en sintetizar cada unas de las properties.

**HZFCheckins.h**

	@interface HZFCheckins : NSObject
    
	@property (strong, nonatomic) NSMutableArray *data;
    
	+ (HZFCheckins *)checkinsWithFakeData;
    
	@end

**HZFCheckins.m**

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
	    
	    return checkins;
	}
    
	@end

Por ahora la implementación se limita a rellenar la lista con datos falso para poder ir probando nuestra interfaz de usuario. Luego esta clase será la encargada de persistir los datos en el sistema de ficheros o en el servidor mediante un webservice.