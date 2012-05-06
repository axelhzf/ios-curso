---
layout : default
title : Pull to refresh
---

## Pull to refresh

Pull to refresh es un recurso de interfaz de usuario. Se aplica principalmente en tablas y sirve para actualizar el contenido. El creador de la interfaz es el autor de Tweetie, una cliente de twitter para iOS que posteriormente fue comprado por Twitter.

![Pull to refresh](http://also.kottke.org/misc/images/pull-to-refresh.jpg)

[http://kottke.org/12/03/twitter-has-patent-for-pull-to-refresh](http://kottke.org/12/03/twitter-has-patent-for-pull-to-refresh)

La utilización de esta interfaz se extendió en numerosas aplicaciones como por ejemplo facebook. Ninguna de las aplicaciones creadas por Apple tiene este elemento de interfaz para evitar posibles problemas con las patentes.

Para añadir este comportamiento a nuestra aplicación vamos a utilizar la librería `SVPullToRefresh`.

* Documentación : [http://samvermette.com/314](http://samvermette.com/314)
* Código fuente : [https://github.com/samvermette/SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)

## Uso de SVPullToRefresh

Los pasos para utilizar la librería son:

* Descargar la librería e incluir la carpeta SVPullToRefresh en el proyecto
* Incluir la librería `QuartzCore`
* Importar la cabecera `#import "SVPullToRefresh.h"`


Lo único que falta es definir qué método se va a ejecutar.

	[self.tableView addPullToRefreshWithActionHandler:^{        
	    // Acción a realizar
	    //Por último llamar
	    [tableView.pullToRefreshView stopAnimating];
	}];


## Capturing 'self' strongly in this block is likely to lead to a retain cycle

Implementando el método me encontré con este problema. Los bloques hacen una referencia strong de las variables que utilizan, por lo tanto, normalmente cuando se utilizan variables del exterior dentro del bloque, tendremos un warning del tipo "Capturing 'self' strongly in this block is likely to lead to a retain cycle”. Puedes leer más acerca del tema en:

[http://stackoverflow.com/questions/7853915/how-do-i-avoid-capturing-self-in-blocks-when-implementing-an-api/7854315#7854315](http://stackoverflow.com/questions/7853915/how-do-i-avoid-capturing-self-in-blocks-when-implementing-an-api/7854315#7854315)

La solución que recomienda es hacer una referencia weak:

	 __weak HZFCheckinsViewController *weakSelf = self;
	[self.tableView addPullToRefreshWithActionHandler:^{
		// Aqui se puede acceder a weakSelf sin warning
	}];


## Ejercicio

Añade el comportamiento pull to refresh a la tabla de checkins

**Tip**

Si el método que se ejecuta es demasiado rápido y no consigues ver la animación, puedes poner un delay


	[weakSelf performSelector:@selector(...) withObject:nil afterDelay:1];

El parámetro del delay viene dado en segundo.

## Bonus

Puedes probar las opciones de personalización de la librería

	tableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
	tableView.pullToRefreshView.textColor = [UIColor whiteColor];
	tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;


## Solución

En el método viewDidLoad asigna el Action Handler. El código que se ejecuta en el action handler debe ser asíncrono, ya que se ejecuta en el hilo principal. Puedes comprobarlo porque si pones un código que tarde mucho tiempo, el spinner no dará vueltas. En este caso lo único que debe hacer el método es llamar a fetch. Este método ya se encarga de realizar la petición de forma asíncrona. 

Le estamos añadiendo un delay de 2 segundos para poder ver que la animación funciona correctamente. Como es obvio, en la aplicación real debemos quitar el delay

	- (void)viewDidLoad {
	  	.....

	    __weak HZFCheckinsViewController *weakSelf = self;
	    [self.tableView addPullToRefreshWithActionHandler:^{                        
	        [weakSelf performSelector:@selector(fetch) withObject:nil afterDelay:2];
	    }];
	}

Por último debemos detener la animación cuando se haya terminado de procesar la información.

	- (void)fetchedCheckins:(NSMutableArray *)fetchedCheckins {
		self.checkins.data = fetchedCheckins;
		[self.tableView reloadData];
		[self.tableView.pullToRefreshView stopAnimating];
	}
