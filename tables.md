---
layout: default
title: Tables
---

# Tablas

Las tablas son uno de los componentes más ampliamente utilizados en la mayoría de aplicaciones. Es un elemento muy importante en la interfaz de las aplicación. En twosquare la vamos a utilizar para mostrar la lista de checkins.

Las clases que intervienen a la hora de representar una tabla son:

- UITableView : La tabla en si
- UITableViewCell : Cada una de las celdas de una tabla

Para empezar a trabajar con las tablas, vamos a crear un nuevo controlador que llamaremos `HZFCheckinsControllerView` y haremos que sea una subclase de UITableViewController.

Viendo la implementación que nos creó por defecto Xcode, vemos que hay muchos métodos propios de un controlador de tabla. Estos métodos en realidad son de los protocolos `UITableViewDelegate`, `UITableViewDataSource`. El delegate tiene información de cómo se tiene que comportar la tabla, por ejemplo el tamaño de las celdas, el evento de que se seleccionó una celda, etc. Por otro lado el datasource tiene información del contenido que tiene que mostrar la tabla, por ejemplpo el número de celdas, el número de grupos, el contenido de las celdas, etc. Revisa la documentación de las documentación de las dos clases para que veas los métodos que tienen.

Observando la documentación vemos que los únicos métodos que son requeridos son:

* `tableView:cellForRowAtIndexPath` : Devuelve la celda configurada.

* `tableView:numberOfRowsInSection` : Devuelve el número de celdas que hay en cada sección. Por defecto hay una única sección.

Ya que estos métodos son los únicos requeridos, vamos a implementarlos.

**HZFCheckinsViewController.h**

	@property (nonatomic, strong) HZFCheckins *checkins;

**HZFCheckinsViewController.m**

Creamos la instancia de `HZFCheckins` y la cargamos con datos de prueba.

	@synthesize checkins;
    
	- (id)initWithStyle:(UITableViewStyle)style
	{
	    self = [super initWithStyle:style];
	    if (self) {
	        self.checkins = [HZFCheckins checkinsWithFakeData];
	    }
	    return self;
	}

Implementamos los métodos del `UITableViewDataSource`:

	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	    
	    return [self.checkins.data count];
	}
  
En este método tenemos que devolver el número de celdas que va a tener nuestra tabla, que vendrá dado por el número de elementos que hay en el array de checkins.  

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	    static NSString *CellIdentifier = @"Cell";
	    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	    
	    if(cell == nil){
	        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	    }
	    
	    HZFCheckin *checkin = [checkins.data objectAtIndex: indexPath.row];    
	    cell.textLabel.text = checkin.nombre;
	    
	    return cell;
	}

En este método se configura el contenido de la celda. Usa un patrón muy interesante, y es el que se implementa el método `dequeueReusableCellWithIdentifier:`. Para hacer más eficiente el scroll, las celdas se reutilizan. Supón que tienes una tabla con 2000 elementos pero en la pantalla del iPhone únicamente se pueden mostrar a la vez unas 10 celdas. No tiene sentido crear una instancia de UITableViewCell que es bastante costosa para cada uno de los elementos. Lo que se hace es tener un pool de celdas y la tabla se encarga de gestionar las que se van a mostrar y las que se van a ocultar. Lo único que nosotros debemos hacer es obtener una celda del pool y configurarla correctamente.

El identificador de la celda permite distinguir el tipo de celda. En nuestro caso tenemos un único tipo de celda.

En el caso de que el método `dequeueReusableCellWithIdentifier:` devuelve nil, tenemos que crear una nueva instancia de celda.

Cuando ya estamos seguros de que tenemos una instancia de `UITableViewCell` lo único que tenemos que hacer es configurarla correctamente. Para ellos buscamos el elemento que tenemos que representar a partir del indexPath (section + row) y configuramos la textLabel.

> Los `\#pragma mark -` sirven para separar secciones del código. Cuando ves la lista de métodos que tiene la clase aparecen por secciones.

Con esto ya tenemos nuestra vista configurada. Ahora lo que nos falta hacer es configurar el App Delegate para que muestre esta vista cuando la aplicación se inicia.

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	    self.window.rootViewController = [[HZFCheckinsViewController alloc] initWithStyle:UITableViewStylePlain];
	    self.window.backgroundColor = [UIColor whiteColor];
	    [self.window makeKeyAndVisible];
	    return YES;
	}

Prueba la aplicación en el simulador y comprueba que se muestra correctamente la tabla con los datos de prueba.

# Personalización de las celdas