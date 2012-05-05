//
//  objintroTests.m
//  objintroTests
//
//  Created by Axel Hernández Ferrera on 05/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "objintroTests.h"
#import "HZFPersona.h"
#import "NSString+Utilities.h"

@implementation objintroTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {    
    [super tearDown];
}

- (void)testBasicSintax {
    
    //numbers
    int a = 1;
    STAssertEquals(1, a, @"ints");
    
    float f = 1.45f;
    STAssertEquals(1.45f, f, @"floats");
    
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
    
    //for
    int sum = 0;
    for(int i = 0; i < 10; i++){
        sum = sum + i;
    }
    STAssertEquals(45, sum, @"for");
    

    //Strings
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

    //booleans
    BOOL yep = YES;
    BOOL nop = NO;
    STAssertTrue(yep, @"yes");
    STAssertFalse(nop, @"yes");
    
    //id
    id weakType = @"hola";
    STAssertEqualObjects(@"hola",weakType, nil);
    weakType = [NSNumber numberWithInt:3];
    STAssertEqualObjects([NSNumber numberWithInt:3],weakType, nil);
}

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

- (void)testEj6 {
    HZFPersona *persona = [[HZFPersona alloc] init];
    persona.nombre = @"Luke";
    persona.apellido = @"Skywalker";
    
    STAssertEqualObjects(@"Luke", persona.nombre, nil);
    STAssertEqualObjects(@"Skywalker", persona.apellido, nil);
    STAssertEqualObjects(@"Luke Skywalker", [persona nombreCompleto], nil);
}

- (void)testEj7 {
    NSString *email = @"chuck.norris@gmail.com";
    NSString *invalidEmail = @"chucknorris.com";
        
    STAssertTrue([email isEmail], nil);
    STAssertFalse([invalidEmail isEmail], nil);
}

@end
