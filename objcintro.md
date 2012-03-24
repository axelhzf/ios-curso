---
layout : default
title : Introducción a Objective-C
---

# Introducción a Objective-C


> Objective-C es un lenguaje de programación orientado a objetos creado como un superconjunto de C pero que implementase un modelo de objetos parecido al de Smalltalk. Originalmente fue creado por Brad Cox y la corporación StepStone en 1980. En 1988 fue adoptado como lenguaje de programación de NEXTSTEP y en 1992 fue liberado bajo licencia GPL para el compilador GCC. Actualmente se usa como lenguaje principal de programación en Mac OS X y GNUstep.


Objective-C es un superconjunto de C. Todo el código C es válido en Objective-C. 

La sintaxis de objetos de Objective-C deriva de Smalltalk. Toda la sintaxis para las operaciones no orientadas a objetos (incluyendo variables primitivas, pre-procesamiento, expresiones, declaración de funciones y llamadas a funciones) son idénticas a las de C, mientras que la sintaxis para las características orientadas a objetos es una implementación similar a la mensajería de Smalltalk.

[http://es.wikipedia.org/wiki/Objective-C]()


# Creación del proyecto para pruebas

Para introducirnos a la sintaxis de ObjectiveC vamos a hacerlo escribiendo unos test unitarios. Así de paso aprendemos a escribir test.

Para empezar creamos un proyecto nuevo `File/New Project` y marcamos el template `Empty Application`. Llamamos al proyecto como queramos y nos aseguramos de marcar la opción de `Use Automatic Reference Counting` y `Include Unit Test`.

Apple introdujo `Automatic Reference Counting (ARC)` en la versión 4.2 de Xcode que se corresponde con iOS 5. Esta característica nos ayuda con el manejo de memoria de nuestro objetos, encargandose de liberarla en el momento adecuado. No se trata de un recolector de basura como existen en otros lenguajes como Java. ARC cuenta las referencias que existen de un objeto, cuando el número de referencias es 0, se encarga de liberar la memoria porque ese objeto ya no podrá ser accesible. En versiones anteriores de Xcode el programador era el encargado de manejar la memoria.

# Unit Tests

Abrimos el fichero .m que está de la carpeta de tests y vamos a ir probando la sintaxis del lenguaje. Para ello tenemos que ir escribiendo el código en el método `testExample`.

Para ejecutar los tests podemos ir a `Product/Test` o utilizar el atajo de teclado `Cmd + U`.

Los métodos para realizar comprobaciones empiezan por ST:

* STFail(description)
* STAssertEquals(a1, a2, description)
* STAssertEqualObjects(a1, a2, description)
* STAssertFalse(exp, description)
* STAssertTrue(exp, description)
* STAssertNil(exp, description)

# Sintaxis básica

## Tipos de datos simples
	int a = 1;
	STAssertEquals(1, a, nil);
	
	float f = 1.45f;
	STAssertEquals(1.45f, f, nil);

## If
    int resultado;
	int n = 3;
	if(n == 3){
		resultado = 0;
	}else if(n < 3){
		resultado = -1;
	}else{
		resultado = 1;
	}
	STAssertEquals(0, resultado, nil);

## For
	int sum = 0;
	for(int i = 0; i < 10; i++){
		sum = sum + i;
	}
	STAssertEquals(45, sum, nil);

## Strings
    NSString *str = @"Hola mundo";
    STAssertEqualObjects(@"Hola mundo", str, nil);
    
	int n2 = 2;
	NSString *str2 = [NSString stringWithFormat:@"Hola mundo %n", n2];
    STAssertEqualObjects(@"Hola mundo 2", str2, nil);

## BOOL
	BOOL yes = YES;
	BOOL nop = NO;
	STAssertTrue(yes, nil);
	STAssertFalse(nop, nil);

## id
    id weakType = @"hola";
    STAssertEqualObjects(@"hola",weakType, nil);
	weakType = [NSNumber numberWithInt:3];
    STAssertEqualObjects([NSNumber numberWithInt:3],weakType, nil);

## Comentarios
	// Comentario
	/*
		Comentario multilinea
	*/

# Foundation Framework

## Arrays

	-(void)testArray {
	    NSArray* array =[NSArray arrayWithObjects:@"a", @"b", @"c", nil];
        
	    STAssertEquals((NSUInteger)3, array.count, nil);
	    STAssertEqualObjects(@"a", [array objectAtIndex:0], nil);
	    STAssertEqualObjects(@"b", [array objectAtIndex:1], nil);
	    
	    for(NSString *objeto in array){
	        NSLog(@"obj %@", objeto);
	    }
	    
	    NSMutableArray* mutable = [NSMutableArray array];
	    [mutable addObject:@"a"];
	    [mutable addObject:[NSNumber numberWithInt:2]];
	    [mutable addObject:[NSNumber numberWithFloat:3.14159]];
	    STAssertEquals((NSUInteger)3, mutable.count, nil);
	    [mutable removeObjectAtIndex:2];
	    STAssertEquals((NSUInteger)2, mutable.count, nil);
	}

## Diccionarios

	-(void)testDictionary {
	    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
	                          @"Valor 1", @"Clave 1",
	                          [NSNumber numberWithFloat:2.0], @"Clave 2",
	                          nil];
	    STAssertEqualObjects(@"Valor 1", [dictionary objectForKey:@"Clave 1"], nil);
	    STAssertEqualObjects([NSNumber numberWithFloat:2.0], [dictionary objectForKey:@"Clave 2"], nil);    
	    
	    
	    NSMutableDictionary* mutableDict = [NSMutableDictionary dictionary];
	    [mutableDict setObject:@"Un Valor" forKey:@"clave1"];
	    [mutableDict setObject:@"Otro Valor" forKey:@"clave1"];
	    
	    STAssertEquals((NSUInteger)1, [mutableDict count], @"Las claves son únicas");
	    
	    [mutableDict setObject:@"Otro Valor" forKey:@"clave2"];
	    STAssertEquals((NSUInteger)2, [mutableDict count], nil);
	}


# Clases

## <strike>Llamando a métodos</strike> Paso de mensajes

En objective-C al igual que en Smalltalk la invocación de métodos se realiza por paso de mensajes:

	[objeto metodo];
	[objeto metodoConParametro1:param1];
	returnValue = [objeto metodoConParametro1:param1 yParametro2:param2];

Ya vimos antes un ejemplo de uso 

	NSString *str = [NSString stringWithFormat:@"Hola mundo"];

El paso de mensajes se puede encadenar

	[obj mensaje2ConParametro:[obj2 mensaje2]]

El resultado del mensaje2 se le pasa como parámetro al mensaje1

## Accessors

	// Sintaxis tradicional
	[obj setName:@"value"];
	name = [obje name];

	// Sintaxis . (Objective-C 2.0)
	obj.name  = @"value"
	name = obj.name


## Creacion de objetos
	NSString* myString = [NSString string];
	NSString* myString = [[NSString alloc] init];
	NSNumber* value = [[NSNumber alloc] initWithFloat:1.0];


## Definición de clases

La definición de una clase tiene dos partes, la interfaz y la implementación

La interfaz se escribe en los ficheros .h

	@interface ExampleClass : NSObject {
		//variables
		NSString *var1;
	}
	//Métodos
	- (NSString*) method1;
	- (NSString*) method2;
	@end       

La implementación se escribe en los ficheros .m

	#import "ExampleClass.h"
	@implementation ExampleClass
	   
	- (NSString*) method1 {
	    ...
	}
	- (NSString*) method2 {
	    ...
	}
	@end

## Init

El método init suele seguir el siguiente patrón

	- (id) init {
	    if (self = [super init]) {
	    	//Código de inicialización de la clase
	    }
	    return self;
	}

El código lo que hace es llamar al método init de la clase padre, en caso de que la inicialización haya sido correcta, entrará en el if y nuestro código de inicialización específico.

## Properties

Las propiedades es una características de ObjectiveC que nos permite generar automáticamente los accessors. La sintaxis es la siguiente:

En la interfaz se definen:

	@property (nonatomic, strong) NSString *variable;

En la implementación tenemos que decirle que queremos que genere automáticamente los métodos

	@syntheisze variable;

## Paso de mensajes a nil

En Objective-C `nil` es el equivalente al `null` de otros lenguajes orientados a objetos. La diferencias es que puedes pasar a nil si que se produzca una excepción. En este caso , el resultado será `nil`.

La ventaja es que hay muchas ocasiones donde podemos evitarnos hacer comprobaciones de si el objeto es != nil para llamar a métodos.

## Categories

Las categorias permiten añadir métodos a clases que ya existen.

Por ejemplo, si quisieramos añadir un método nuevo a la clase NSString

	@interface NSString (Utilities)
		- (BOOL) isURL;
	@end

	#import "NSString-Utilities.h"
	            
	@implementation NSString (Utilities)
	- (BOOL) isURL
	{
	    if ( [self hasPrefix:@"http://"] )
	        return YES;
	    else
	        return NO;
	}
	@end


Y ya podríamos utilizarla

	NSString* string1 = @"http://pixar.com/";
	NSString* string2 = @"Pixar";
	if ( [string1 isURL] )
	    NSLog (@"string1 is a URL");
	if ( [string2 isURL] )
	    NSLog (@"string2 is a URL");  
	

Cuando haces modificaciones de una clase mediante una categoria, estos cambiamos afectan a todas las clases de la aplicación.


# Ejercicios

* Suma los números del 0 al 100
* Suma los números pares del 0 al 100 (Tip: El operador del resto entero es % )
* Crea un string con "hola", otro con "mundo" y otro más con la concatenación de los dos anteriores
* Crea un array con todos los números pares del 0 al 100
* Dado un array con elementos repetidos, crea uno nuevo sin los elementos repetidos


# Conclusiones

Esto ha sido una introducción muy rápida a Objective-C. A medida que sigamos avanzando en el curso iremos viendo más características del lenguajes y estudiando más clases del SDK. 

Como con todo lenguaje de programación, hace falta práctica para acostumbrarse a las peculiaridades de la sintaxis del lenguaje y aprenderse las clases que se utilizan más frecuentemente.

Si quieres más información acerca de Objective-C puedes consultar el apartado de referencias, donde hay tutoriales muy buenos y muy completos.

# Referencias
* [http://cocoadevcentral.com/d/learn_objectivec/]()
* [http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html]()
* [http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/OOP_ObjC/Introduction/Introduction.html]()
* [http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/ObjC_classic/_index.html]()