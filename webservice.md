---
layout : default
title : Webservice
---

## Persistencia

A la hora de persistir los datos de la aplicación existen varias alternativas:

* Fichero de propiedades
* Escritura en fichero
* SQLite3
* Core Data (ORM de Apple)
* Web Service

Es común que estos sistemas se combinen entre sí:
Por ejemplo, utilizar web service para sincronizar los datos entre distintos usuario y cuando el usuario no tiene conectividad utilizar los últimos datos almacenados en base de datos.

Para el tipo de aplicación que estamos haciendo, lo más conveniente es utilizar un web service. De manera que tengamos la información de los checkins de todos los usuarios sincronizada y que un usuario pueda ver los checkins de los demás. El objetivo es que los alumnos del curso puedan compartir los checkins
cada uno desde su aplicación. 

Si estás interesado en ver cómo funcionan el resto de sistemas, dejo algunos enlaces a tutoriales.

* [http://www.raywenderlich.com/11944/core-data-tutorial-updated-for-ios-5](http://www.raywenderlich.com/11944/core-data-tutorial-updated-for-ios-5)
* [http://developer.apple.com/library/ios/#referencelibrary/GettingStarted/GettingStartedWithCoreData/_index.html](http://developer.apple.com/library/ios/#referencelibrary/GettingStarted/GettingStartedWithCoreData/_index.html)
* [http://kurrytran.blogspot.com.es/2011/08/ios-5-tutorial-part-i-sqlite.html](http://kurrytran.blogspot.com.es/2011/08/ios-5-tutorial-part-i-sqlite.html)

## Web service

El webservice que vamos a utilizar va a ser REST y el formato de comunicación de los datos va a ser JSON. Está escrito en Java utilizando en Play!Framework y el código fuente está disponible
en el repositorio:

[https://github.com/axelhzf/ios-curso/tree/master/webservice](https://github.com/axelhzf/ios-curso/tree/master/webservice)

El webservice está desplegado en [heroku](http://www.heroku.com/) en la dirección:

[http://axelhzf-ios-tut.herokuapp.com/](http://axelhzf-ios-tut.herokuapp.com/)

Desde esta pantalla podemos gestionar los checkins que tenemos almacenados en la base de datos.

Los métodos de la API JSON son:

**Obtener lista de checkins**

GET  [http://axelhzf-ios-tut.herokuapp.com/api/checkins](http://axelhzf-ios-tut.herokuapp.com/api/checkins)

**Crear nuevo checkin**

POST [http://axelhzf-ios-tut.herokuapp.com/api/checkins](http://axelhzf-ios-tut.herokuapp.com/api/checkins)

## Consumir un servicio web

Para consumir el servicio web debemos hacer una petición HTTP a la URL del servicio web. Esta petición la debemos hacer de forma asíncrona si no queremos que la aplicación se quede congelada
hasta que el servidor responda o hasta que se produzca un timeout. Para ello vamos a tener que trabajar con un hilo independiente, que va a estar pendiente de la respuesta del servidor.

Para esto tenemos varias alternativas:

* NSURLConnection [http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html](http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html)
* ASIHTTPRequest [http://allseeing-i.com/ASIHTTPRequest/](http://allseeing-i.com/ASIHTTPRequest/) (descontinuaada)

Y la última opción que es la que vamos a utilizar: Realizar una petición síncrona, pero no en el hilo principal. Para ello vamos a utilizar Grand Central Dispatch.

## Grand Central Dispathc (GCD)

[Grand Central Dispatch (GCD)](https://developer.apple.com/library/mac/#featuredarticles/BlocksGCD/_index.html).
está disponible desde la versión 10.6 de OS X y iOS 4. GCD es una tecnología para optimizar el uso de procesadores multinúcleo. El sistema operativo es el que se encarga de gestionar los hilos de ejecución de las aplicaciones.
Ya vimos algo de de GCD con la implementación de Singleton que hicimos.
Grand Central Dispatch se basa en:

* block objects
* dispatch queues
* synchronization
* event sources

Los `blocks` son funciones anónimas que pueden definirse inline. Los bloques capturan copias de solo lectura de las variables definidas en el ámbito donde fue definido el bloque. De
forma similar a una `closure` en otros lenguajes. La sintaxis para definir un bloque es:

    my_block = ^(void){ printf("hello world\n"); };

Los bloques realizan una copia de las variables definidas en el ámbito

    typedef void (^blockWithString)(char*);
    char *greeting = “hello”;
    blockWithString b = ^(char* place){ printf("%s %s\n", greeting, place); };
    greeting = "goodbye";
    b("world"); // prints "hello world\n"

Los bloques se ejecutan en colas, la forma utilizada por el GCD para definir la concurrencia.

<blockquote class="twitter-tweet tw-align-center"><p>Xcode needs achievements: "You've successfully typed the block declaration syntax from memory 10 times in a row!"</p>&mdash; Zach Waugh (@zachwaugh) <a href="https://twitter.com/zachwaugh/status/193717205119148033" data-datetime="2012-04-21T15:05:55+00:00">April 21, 2012</a></blockquote>

Para definir una cola

    dispatch_queue_t a_queue;

Para ejecutar un trabajo en una cola

    dispatch_async(a_queue, ^{ do_not_wait_for_me(); });

Cuando dentro de un bloque queremos invocar un método en el thread principal podemos utilizar el método

    [self performSelectorOnMainThread:@selector(method:) withObject:param waitUntilDone:NO];


## HTTP Request y Json Parser

Para realizar una petición de forma síncrona podemos utilizar el método

    NSData* data = [NSData dataWithContentsOfURL: @"http://......"];

La respuesta que obtengamos del servidor la debemos parsear. Para ello, a partir de la versión 5 de iOS se introdujo la clase NSJSONSerialization.

    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

Con este método se convierte el JSON en un NSDictionary o un NSArray (dependiente de la estructura con la que venga el JSON).

## Ejercicio

- Crea una `dispatch_queue_t`
- Crea un bloque asíncrono que realice la petición al servidor
- Convierte el JSON de respuesta en un array de objetos de la clase Checkin
- Actualiza la tabla principal con los datos devueltos por el servidor.

### Tips

- El formato en el que viene la fecha es ddMMMyyyy HH:mm:ss

## Solución

Definición de la cola global

    #define kHZFQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

Definición del bloque

    - (void)fetch{
        dispatch_async(kHZFQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://axelhzf-ios-tut.herokuapp.com/api/checkins"]];
            NSError* error;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            NSMutableArray *jsonCheckins = [NSMutableArray array];
            for(NSDictionary *jsonElement in jsonArray){
                HZFCheckin *checkin = [HZFCheckin checkinFromDictionary:jsonElement];
                [jsonCheckins addObject:checkin];
            }
            [self performSelectorOnMainThread:@selector(fetchedCheckins:) withObject:jsonCheckins waitUntilDone:NO];
        });
    }

    - (void)fetchedCheckins:(NSMutableArray *)fetchedCheckins {
        self.checkins.data = fetchedCheckins;
        [self.tableView reloadData];
    }

Es importante que los cambios de la interfaz gráfica los realicemos en el
hilo principal, para ello utilizamos el método `performSelectorOnMainThread:`
En la clase HZFCheckin añadi un nuevo método que transforma de un NSDictionary al objeto

    + (HZFCheckin *)checkinFromDictionary:(NSDictionary *)dictionary {

        static NSDateFormatter* dateFormatter = nil;
        if(dateFormatter == nil){
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"ddMMMyyyy HH:mm:ss";
        }

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

Por último falta realizar la llamada a recuperar los datos del servidor

    - (void)viewWillAppear:(BOOL)animated {
        [self fetch];
    }

## Creando un nuevo checkin en el servidor

Siguiendo los principios REST, para crear un nuevo checkin se realiza una petición POST. El body de la petición son los datos en formato JSON.

Para transformar un objeto en un string JSON utilizamos el método inverso al anterior

    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];

Para realizar una petición POST de forma síncrona

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: data];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];


## Ejercicio

- Cuando se cree un nuevo checkin realiza una petición al servidor para que se almacene el nuevo checkin

## Solución

Añade un método en la clase checkin que transforma el objeto a formato JSON

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

El método que realiza la petición al servidor

    - (void)addCheckin:(HZFCheckin *)checkin {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://axelhzf-ios-tut.herokuapp.com/api/checkins"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[checkin toJson]];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
        [data addObject:checkin];
    }
    
    

Código:

[https://github.com/axelhzf/ios-curso/commit/3dccf9074cade2d951ab8619499f7553ff0f3ae6](https://github.com/axelhzf/ios-curso/commit/3dccf9074cade2d951ab8619499f7553ff0f3ae6)