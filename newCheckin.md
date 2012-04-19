---
layout: default
---

# Nuevos checkins

Vamos a añadir la vista que nos va a permitir nuevos checkins. También va a ser una tabla, pero en este caso, las celdas de la tabla se podrán editar, para insertar los datos.

# Navigation Controller

Como vamos a tener varias vistas, necesitaremos una forma de navegar entre la vistas, ir hacia delante, hacia detras. La forma más extendida de hacer esto es utilizando un Navigation Controller. Este controlador permite navegar de una forma sencilla entre datos jerarquicos. Añade una barra en la parte superior permitiendo volver a la vista anterior.

Para añadir un controlador de este tipo, vamos al Storyboard y añadimos un `Navigation Controller`. Por defecto te añade también un UITableView como rootController. Tenemos que borrarlo y asignar como rootController la tabla que ya tenemos creada. Ahora podemos ponerle un título en la barra de navegación. Añade una nueva vista, un `UITableViewController`. Añade un botón a la barra de navegación con el Identifier `Add`. Enlaza el botón a el nuevo `UITableViewController`. Al enlazarlo aparecerán varias opciones, push y modal. Deberías utilizar push para seguir la jerarquia de la información y modal, cuando la navegación rompe la jerarquía. En este caso vamos a utilizar push.

Ejecuta la aplicación en el simulador y veras como al pulsar el botón se meustra la nueva tabla vacía y que automáticamente en la segunda tabla aparece un botón de navegación hacía detrás con el nombre de la primera tabla.

# Diseño de la vista de nuevo TableView

Para esta vista vamos a utilizar un diseño estático porque sabémos el número de celdas que debemos mostrar. Crea cuatro celdas con el estilo Left Detail para mostrar el nombre, la categoría, la latitud y la longitud. En el caso del nombre no valdrá el estilo por defecto, porque nos hace falta que el usuario pueda editar el nombre. Añade un TextField para esa celda.

## Text field

Un text field permite al usuario introducir datos. Al seleccionar el text field se muestra el teclado virtual dodne el usuario podrá introducir texto. Este control tiene opciones que permite controlar el tipo de teclado que se muestra, en nuestro caso con el teclado completo que es la opción por defecto nos servirá.

### Usabilidad

Para que el text field tenga el foco cuando se muestra la vista, tenemos que asignar el firstResponder. El firstResponder es el elemento con el que estamos interactuando actualmente.

	- (void)viewDidLoad {
	    [super viewDidLoad];
	    [self.fieldNombre becomeFirstResponder];
	}

Para que cuando termine de editar se cierre el teclado debemos asignar el evento `Did on exit` del textField.

	- (IBAction)endEditingName:(id)sender {
	    [sender resignFirstResponder];
	}

Una de las opciones que tiene el textField es el tipo de tecla para terminar que tiene. En nuestro caso, `Done` nos vendrá bien.

Hemos mejorado la usabilidad, pero lo podríamos hacer mejor aún. Muchas aplicación hacen que cuando el el usuario pulsa en una zona de la pantalla, distinta del textfield que está editando, el teclado desaparece. Para ello vamos a trabajar con los gestos. El código que tenemos que poner es

	- (void)viewDidLoad {
	    [super viewDidLoad];
    
	    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	    self.gestureRecognizer.cancelsTouchesInView = NO;
	    [self.tableView addGestureRecognizer:gestureRecognizer];
	}
    
	- (void)viewDidUnload{
	    [self.tableView removeGestureRecognizer:self.gestureRecognizer];
	    
	    self.fieldNombre = nil;
	    self.gestureRecognizer = nil;
	    
	    [super viewDidUnload];
	}
    
	- (IBAction)hideKeyboard {
    	[self.fieldNombre resignFirstResponder];
	}

TapGesture es el equivalente a un evento onClick, pero en este caso se llaman tap.

En el método viewDidLoad estamos iniciando un `UITapGestureRecognizer` y añadiendolo a la vista, para escuchar el evento. El parámetro action es el callback, el método que se ejecutará cuando se produzca el evento.

# Categorias

El usuario va a poder seleccionar de entre una lista de categorias. Para ello, vamos a crear una nueva vista de tabla en el storyboard. Crea el ViewController correspondiente que muestre una celda por cada una de las categorias. Conecta las dos vistas en el story board con el estilo push. Prueba en el simulador que todo funciona correctamente.

El usuario únicamente va a poder seleccionar una categoria de la lista.
Por un lado vamos a tener la property `selectRow` que nos indicará el número de la fila que está seleccionada actualmente y por
otro lado tendremos `selectedCategory` que tendrá el string asociado a esa fila.

	@interface HZFNewCheckinCategoryViewController : UITableViewController
    ...
    @property (strong, nonatomic) NSArray *categories;
	@property (strong, nonatomic) NSNumber *selectedRow;
	@property NSString *selectedCategory;
	- (void)setSelectedCategory:(NSString*)category;
    ...
	@end

Como vamos a implementar los accesors de forma manual, no es neceasrio añadir los parámetros a `selectedCategory`
ni añadirla en la lista de @synthetized.

    @implementation HZFNewCheckinCategoryViewController

    - (NSString *)selectedCategory {
        return [self.categories objectAtIndex:self.selectedRow.intValue];
    }

    - (void)setSelectedCategory:(NSString*)category {
        self.selectedRow = nil;
        for(int i = 0; i < self.categories.count; i++){
            if([[self.categories objectAtIndex:i] isEqualToString:category]){
                self.selectedRow = [NSNumber numberWithInt:i];
                break;
            }
        }
    }

    @end

Al mostrar las filas tenemos que averiguar si la fila es la que está seleccionada para ponerle una marca.
Para ello tenemos el accesoryType.

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *CellIdentifier = @"CategoryCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        NSString *category = [self.categories objectAtIndex:indexPath.row];
        cell.textLabel.text = category;

        if(self.selectedRow){
            if(indexPath.row == [self.selectedRow intValue]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }

        return cell;
    }

Falta que el usuario pueda modificar la selección de la categoria. Para ello tenemos que implementar un método del
`UITableViewDelegate`.

    #pragma mark - Table view delegate
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        if(selectedRow){
            NSUInteger oldRow = self.selectedRow.intValue;
            NSUInteger newRow = indexPath.row;
            if(oldRow != newRow){
                NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:0];
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
                oldCell.accessoryType = UITableViewCellAccessoryNone;
            }
        }

        self.selectedRow = [NSNumber numberWithInt:indexPath.row];
    }

Cuando el usuario selecciona una celda, le asigna el accesory type y desmarca la celda (Las celdas marcadas por defecto
tienen un color azul. Si había otra celda seleccionada le elimina el accesory type.

Prueba que el código funciona correctamente en el simulador.

# Segues

Ahora mismo tenemos las dos tablas pero están separadas, no comparten la información. Cuando el usuario selecciona una
categoria ese cambio no se refleja en la primera tabla. Para comunicar las vistas dentro de un storyboards se utilizan
los segues. Para editar las propiedades del segue selecciona en el storyboard la unión entre las dos vistas,
el icono que tiene una flecha. Asignale el identificador `selectCategory`.

La clase `UIViewController` tiene un método que se llama justo cuando se va a producir una transición mediante un segue.

    - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        UIViewController *destination = segue.destinationViewController;
        if ([[segue identifier] isEqualToString:@"selectCategory"]){

            if ([destination respondsToSelector:@selector(setDelegate:)]) {
                [destination setValue:self forKey:@"delegate"];

            }

            if([destination respondsToSelector:@selector(setSelectedCategory:)]){
                [destination performSelector:@selector(setSelectedCategory:) withObject:self.category];
            }

        }
    }

El segue contiene información de cual va a ser el UIViewController de destino. Mediante el identificador que le pusimos
al segue podemos separar el código que tenemos que ejecutar en uno u otro caso.

Para hacer nuestra vistas más independientes las unas de las otras estamos utilizando un mecanismo que se denomina
[Key-Value Coding (KVC)](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Overview.html#//apple_ref/doc/uid/20001838-SW1)
que consiste en acceder a las propiedades de un objeto de forma indirectame, mediante strings
en lugar de invocar directamente al accesor. De esta forma no tenemos que conocer la implementación concreta del
controlador al que vamos a ir, si tiene un método con una signature concreta, la invocamos.

* `respondsToSelector:` - Comprueba si un método tiene una signature concreta
* `setValue:forKey:` - Asigna el valor a una property
* `performSelector:withObject:` - Inova un método pasandole un arámetro

Para llamadas a métodos con más parámetros utilizar la clase `NSInvocation`.

Asegurate de comprobar primero si la instancia que estas invocando contiene ese método o se producirá una
excepción `NSInvalidArgumentException`


Volviendo a nuestro código, lo que estamos haciendo es asignando a la segunda vista la property delegate
y la selectedCategory. La property delegate va a manter una referencia de la vista 1 en la vista 2 ¿Por qué
nos hace falta esta referencia? Porque la comunicación tiene que ser en las dos direcciones. Cuando en
la segunda vista el usuario seleccione una categoria, debe enviarle esta información a la vista 1. Es importante
definir este tipo de properties como weak

    @property (weak, nonatomic) id delegate;

Como tenemos un ciclo de dependencias, si no definieramos una de las relaciones weak tendriamos una fuga
de memoria, porque ninguna de las dos vistas podría liberarse nunca. Siempre tendrían el contador de
referencias a al menos 1.

El código anterior nos define la comunicación de la vista 1 a la vista 2. Ahora nos falta la inversa, la
comunicación de la 2 a la 1.

    - (void)viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];
        if([delegate respondsToSelector:@selector(setCategory:)]){
            [delegate setValue:[self selectedCategory] forKey:@"category"];
        }
    }

Como su propio nombre indica, el método `viewWillDisappear` se ejecuta cuando la vista va a desaparecer. Lo
que estamos haciendo es asignando la propiedad categoria de la primera vista. De esta forma ya está cerrado
el ciclo y tenemos las vistas conectadas en las dos direcciones.

Ahora lo único que falta es que al actualizar la property category en la vista1 también se actualice la celda.
A estas alturas del curso ese código debería ser trivial.


# Guardando el nuevo checkin

Nos queda pendiente ver cómo vamos a obtener la geolocalización del usuario. Lo veremos más adelante
cuando entremos con los detalles del mapa. Así que lo único que nos queda para terminar esta vista es guardar
el nuevo checkin para que se añada a vista principal.

Al igual que hicimos antes para para mover la información de la categoría de una vista a otra, podríamos mover
 la información del nuevo checkin a la lista de checkins. Para ver algo de código distinto, vamos a convertir
 la lista de checkins en un Singleton y así vemos la forma de implementarlos.

Existen varias formas de implementar el patron Singleton. En este post
[http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html](http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html)
se comentan varias y explican la versión que vamos a utilizar.

Cambiando la implementación de la lista de checkins y añadimos el método estático sharedInstance. Este método
nos va a devolver la instancia única del objeto cada vez que lo llamemos.

     + (id)sharedInstance {
         static dispatch_once_t pred = 0;
         __strong static id _sharedObject = nil;
         dispatch_once(&pred, ^{
             _sharedObject = [[self alloc] init];
         });
         return _sharedObject;
     }

El método save de la vista quedaría de la siguiente forma

    - (IBAction)save:(UIBarButtonItem *)sender {
        HZFCheckin *checkin = [[HZFCheckin alloc] init];
        checkin.nombre = self.fieldNombre.text;
        checkin.fechaCreacion = [NSDate date];
        checkin.categoria = self.category;

        HZFCheckins *checkins = [HZFCheckins sharedInstance];
        [checkins.data addObject:checkin];

        [self.navigationController popViewControllerAnimated:YES];
    }

Si probamos este código veremos un comportamiento extraño. Cuando añadimos un elemento y volvemos a la tabla
principal, este elemento no aparece. Esto es porque debemos decirle a la tabla que recargue sus datos.

    - (void)viewWillAppear:(BOOL)animated {
        [self.tableView reloadData];
    }

De esta forma cada vez que la vista vaya a aparecer, recargará los datos porque es posible que la lista
de checkins haya cambiado.
