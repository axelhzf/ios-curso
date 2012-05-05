---
layout : default
title : Introducción a Objective-C
---

# Introducción a Objective-C

Objective-C es un superconjunto de C. Todo el código C es válido en Objective-C. Toda la sintaxis para las operaciones no orientadas a objetos (incluyendo variables primitivas, pre-procesamiento, expresiones, declaración de funciones y llamadas a funciones) son idénticas a las de C, mientras que la sintaxis de las características orientadas a objetos es una implementación similar a la mensajería de Smalltalk.

[http://es.wikipedia.org/wiki/Objective-C]()

# Creación del proyecto para pruebas

Para introducir la sintaxis de Objective-C vamos escribir unos test unitarios. Así de paso aprendemos a escribir test.

Para empezar crea un proyecto nuevo `File/New Project` y marcamos el template `Empty Application`. Ponle el nombre que quieras al proyecto y asegurate de marcar la opción de `Use Automatic Reference Counting` y `Include Unit Test`.

Apple introdujo `Automatic Reference Counting (ARC)` en la versión 4.2 de Xcode que se corresponde con iOS 4 y iOS 5. Esta característica simplifica el manejo de memoria. ARC se encarga de liberar los objetos en el momento adecuado. No se trata de un recolector de basura como existen en otros lenguajes como Java. ARC se basa en contar las referencias que existen de un objeto, cuando el número de referencias es 0, se encarga de liberar la memoria porque ese objeto ya no podrá ser accesible. Todo este proceso se hace en tiempo de compilación. Se modifica el código para añadir las sentencias necesarias para el manejo de memoria en el lugar adecuado. Esto implica que en tiempo de ejecución no se nota la diferencia entre utilizar esta característica o no. En versiones anteriores de Xcode el programador era el encargado de manejar la memoria.

# Unit Tests

Abre el fichero .m que está de la carpeta de tests y vamos a ir probando la sintaxis del lenguaje. 

Para ejecutar los tests podemos ir a `Product/Test` o utilizar el atajo de teclado `Cmd + U`.

Los métodos para realizar comprobaciones empiezan por ST:

* STFail(description)
* STAssertEquals(a1, a2, description)
* STAssertEqualObjects(a1, a2, description)
* STAssertFalse(exp, description)
* STAssertTrue(exp, description)
* STAssertNil(exp, description)

Los métodos de los test deben empezar por la palabra `test` para que se ejecuten.

# Sintaxis básica

## Tipos de datos simples
    //numbers
    int a = 1;
    STAssertEquals(1, a, @"ints");
    
    float f = 1.45f;
    STAssertEquals(1.45f, f, @"floats");

## If
    //if
    int resultado;
    int n = 3;
    if(n == 3){
        resultado = 0;
    }else if(n < 3){
        resultado = -1;
    }else{
        resultado = 1;
    }
    STAssertEquals(0, resultado, @"if");

## For
    //for
    int sum = 0;
    for(int i = 0; i < 10; i++){
        sum = sum + i;
    }
    STAssertEquals(45, sum, @"for");

## Strings
    NSString *str = @"Hola mundo";
    STAssertEqualObjects(@"Hola mundo", str, @"strings");

    int n2 = 2;
    NSString *str2 = [NSString stringWithFormat:@"Hola mundo %d", n2];
    STAssertEqualObjects(@"Hola mundo 2", str2, @"strings");

    NSString *strCmp1 = @"Hola mundo";
    NSString *strCmp2 = @"Hola mundo";
    NSString *strCmp3 = [NSString stringWithFormat:@"Hola mundo"];

    STAssertTrue(strCmp1 == strCmp2, nil);
    STAssertFalse(strCmp1 == strCmp3, nil);
    STAssertTrue([strCmp1 isEqualToString:strCmp3], nil);

## BOOL
    //booleans
    BOOL yep = YES;
    BOOL nop = NO;
    STAssertTrue(yep, @"yes");
    STAssertFalse(nop, @"yes");

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

En Objective-C al igual que en Smalltalk la invocación de métodos se realiza por paso de mensajes:

	[objeto metodo];
	[objeto metodoConParametro1:param1];
	returnValue = [objeto metodoConParametro1:param1 yParametro2:param2];

Ya vimos antes un ejemplo de uso 

	NSString *str = [NSString stringWithFormat:@"Hola mundo"];

El paso de mensajes se puede encadenar

	[obj mensaje1ConParametro:[obj2 mensaje2]]

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

	@property (strong, nonatomic) NSString *variable;

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
    
    #import "NSString-Utilities.h"

	NSString* string1 = @"http://pixar.com/";
	NSString* string2 = @"Pixar";
	if ( [string1 isURL] )
	    NSLog (@"string1 is a URL");
	if ( [string2 isURL] )
	    NSLog (@"string2 is a URL");  


# Ejercicios

Suma los números del 1 al 100

	-(void)testEj1 {
        ...
	    STAssertEquals(5050, sum, nil);
	}

Suma los números pares del 1 al 100 (Tip: El operador del resto entero es %)

	-(void)testEj2 {
	    ... 
	    STAssertEquals(2550, sum, nil);
	}

Crea un string con "hola", otro con "mundo" y otro más con la concatenación de los dos anteriores

	-(void)testEj3 {
	    ...
	    STAssertEqualObjects(@"Hola Mundo", holaMundo, nil);
	}

Crea un array con todos los números pares del 1 al 100

	- (void)testEj4 {
	    ...
	    STAssertEquals((NSUInteger)50, array.count, nil);
	    STAssertEquals(2, [[array objectAtIndex:0] intValue], nil);
	    STAssertEquals(4, [[array objectAtIndex:1] intValue], nil);
	    STAssertEquals(100, [[array objectAtIndex:49] intValue], nil);
	}

Dado un array con elementos repetidos, crea uno nuevo sin los elementos repetidos

	- (void)testEj5 {
	    NSArray *repeat = [NSArray arrayWithObjects:@"a", @"b", @"a", @"c", @"b", nil];
	    
        ...
	    
	    STAssertEquals((NSUInteger)3, noRepeat.count, nil);
	    NSArray *expected = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
	    STAssertEqualObjects(expected, noRepeat, nil);
	}

Crea una clase persona con una propiedad `nombre` y otra apellido `apellido` y con un método `nombreCompleto`.

    - (void)testEj6 {
        HZFPersona *persona = [[HZFPersona alloc] init];
        persona.nombre = @"Luke";
        persona.apellido = @"Skywalker";
        
        STAssertEqualObjects(@"Luke", persona.nombre, nil);
        STAssertEqualObjects(@"Skywalker", persona.apellido, nil);
        STAssertEqualObjects(@"Luke Skywalker", [persona nombreCompleto], nil);
    }

Crea una categoria para `NSString` que compruebe si un string es un email. Has una comprobación sencillamente de si la cadena contiene una @. Aunque si te atrevés con la expresión regular puedes probar con la clase [NSRegularExpression](https://developer.apple.com/library/ios/#documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html)

    - (void)testEj7 {
        NSString *email = @"chuck.norris@gmail.com";
        NSString *invalidEmail = @"chucknorris.com";
            
        STAssertTrue([email isEmail], nil);
        STAssertFalse([invalidEmail isEmail], nil);
    }

# Solución

    -(void)testEj1 {
        int sum = 0;
        for(int i = 1; i <= 100; i++){
            sum = sum + i;
        }
        STAssertEquals(5050, sum, nil);
    }

    -(void)testEj2 {
        int sum = 0;
        for(int i = 1; i <= 100; i++){
            if(i % 2 == 0){
                sum = sum + i;            
            }
        }    
        STAssertEquals(2550, sum, nil);
    }

    -(void)testEj3 {
        NSString *hola = @"Hola";
        NSString *mundo = @"Mundo";
        NSString *holaMundo = [NSString stringWithFormat:@"%@ %@", hola, mundo];
        STAssertEqualObjects(@"Hola Mundo", holaMundo, nil);
    }

    - (void)testEj4 {
        NSMutableArray *array = [NSMutableArray array];

        for(int i = 1; i <= 100; i++){
            if(i % 2 == 0){        
                NSNumber *number = [NSNumber numberWithInt:i];
                [array addObject: number];
            }
        }

        STAssertEquals((NSUInteger)50, array.count, nil);
        STAssertEquals(2, [[array objectAtIndex:0] intValue], nil);
        STAssertEquals(4, [[array objectAtIndex:1] intValue], nil);
        STAssertEquals(100, [[array objectAtIndex:49] intValue], nil);
    }

    - (void)testEj5 {
        NSArray *repeat = [NSArray arrayWithObjects:@"a", @"b", @"a", @"c", @"b", nil];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableArray *noRepeat = [NSMutableArray array];
        
        for(NSString *element in repeat){
            if([dict valueForKey:element] == nil){
                [dict setValue:@"" forKey:element];
                [noRepeat addObject:element];
            }
        }
        
        STAssertEquals((NSUInteger)3, noRepeat.count, nil);
        NSArray *expected = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
        STAssertEqualObjects(expected, noRepeat, nil);
    }

HZFPersona.h

    @interface HZFPersona : NSObject

    @property (strong, nonatomic) NSString *nombre;
    @property (strong, nonatomic) NSString *apellido;

    -(NSString *)nombreCompleto;

    @end

HZFPersona.m

    @implementation HZFPersona

    @synthesize nombre, apellido;

    -(NSString *)nombreCompleto {
        NSString *nombreCompleto = [NSString stringWithFormat:@"%@ %@", self.nombre, self.apellido];
        return nombreCompleto;
    }

    @end

test

    - (void)testEj6 {
        HZFPersona *persona = [[HZFPersona alloc] init];
        persona.nombre = @"Luke";
        persona.apellido = @"Skywalker";
        
        STAssertEqualObjects(@"Luke", persona.nombre, nil);
        STAssertEqualObjects(@"Skywalker", persona.apellido, nil);
        STAssertEqualObjects(@"Luke Skywalker", [persona nombreCompleto], nil);
    }

NSString+Utilities.h

    @interface NSString (Utilities)
    - (BOOL)isEmail;
    @end

NSString+Utilities.m

    @implementation NSString (Utilities)

    - (BOOL)isEmail {
        NSRange range = [self rangeOfString:@"@"];
        return range.location != NSNotFound;
    }

    @end

test

    - (void)testEj7 {
        NSString *email = @"chuck.norris@gmail.com";
        NSString *invalidEmail = @"chucknorris.com";
        STAssertTrue([email isEmail], nil);
        STAssertFalse([invalidEmail isEmail], nil);
    }

La solución con la expresión regular la puedes ver en 

[http://stackoverflow.com/questions/8198303/nsregularexpression-validate-email](http://stackoverflow.com/questions/8198303/nsregularexpression-validate-email)

# Conclusiones

Esto ha sido una introducción muy rápida a Objective-C. A medida que sigamos avanzando en el curso iremos viendo más características del lenguajes y estudiando más clases del SDK. 

Como con todo lenguaje de programación, hace falta práctica para acostumbrarse a las peculiaridades de la sintaxis del lenguaje y aprenderse las clases que se utilizan más frecuentemente.

Si quieres más información acerca de Objective-C puedes consultar el apartado de referencias, donde hay tutoriales más completos.

# Referencias
* [http://cocoadevcentral.com/d/learn_objectivec/](http://cocoadevcentral.com/d/learn_objectivec/)
* [http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html](http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html)
* [http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/OOP_ObjC/Introduction/Introduction.html](http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/OOP_ObjC/Introduction/Introduction.html)
* [http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/ObjC_classic/_index.html](http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/ObjC_classic/_index.html)