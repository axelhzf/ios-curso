---
layout : default
title : iPad
---

# iPad

Todas las aplicaciones creadas para iPhone son compatibles con el iPad. El problema es que no se ajustan a toda la pantalla, se ven con la resolución de un iPhone. Para probar cómo se vería nuestra aplicación de iPhone en un iPad únicamente tienes que cambiar el Scheme (Al lado del botón de Run en la parte superior de XCode) a iPad simulator.

Este no es el efecto que queremos conseguir, queremos hacer nuestra aplicación totalmente compatible con el iPad. Para ello vamos a ir a la configuración del proyecto y vamos a cambiar el Devices a Universal, que quiere decir que nuestra aplicación es compatible tanto con iPhone como con iPad. Si volvemos a ejecutar el simulador del iPad veremos que el resultado que obtenemos ahora es mucho mejor. Tenemos suerte porque nuestro interfaz utiliza elementos estandar, tablas, mapas. Son vistas vistas que están preparadas para funcionar con el iPad. En caso de que hubieramos diseñado vistas propias, quizás hubieramos tenido problema al especificar las dimensiones de las cosas.

## Interfaz específica da iPad

Con el paso anterior tenemos una interfaz compatible con el iPad, que es muy distinto a una interfaz específica para el iPad. El iPad tiene una pantalla mucho mayor que un iPhone y tenemos que aprovecharla. Hay elementos de interfaz de usuario específicos para el iPad como son la SplitViews y los Popovers. Vamos a modificar twosquare para incorporar estos elementos. Para conseguirlo, tendremos 2 storyboars diferentes, uno para la interfaz del iPhone y otro para la interfaz del iPad. Es importante que a medida que vayamos haciendo los cambios para trabajar con el iPad sigamos probando nuestra aplicación en el iPhone, para comprobar que no hemos roto nada y nuestra aplicación sigue funcionando correctamente.

Creamos un storyboard nuevo `File/New/File/Storyboard` y selecciona iPad en device Family. Le pondremos de nombre `twoSquare_iPad`. En la configuración del proyecto, en la sección `iPad Deployment Info` debemos seleccionar como `Main Storyboard` el nuevo storyboard que acabamos de crear.

## SplitViewController

En el nuevo StoryBoard añadimos un `SplitViewController`. En nuestro caso la vista máster será el listado de checkins y el detaille será el mapa. Debemos copiar la interfaz que tenemos en nuestro storyboard para iPhone. Copia el prototipo de celda de la lista de checkins. Añade un mapView a la vista de detalle.

Si necesitamos escribir código específico para un dispositivo podemos utilizar

	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    	// Código para iPhone
	    }else{
	    	// código para iPad
	    }

Por ejemplo, en el caso de la orientación de la vistas. Las guías de interfaz de usuario recomiendan que en iPad se permitación todas las orientaciones y en iPhone todas menos PortraitUpsideDown. Asigna esta orientación a todas las vistas.

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	    } else {
	        return YES;
	    }
	}


La vista de detalle, en nuestro caso la vista de mapa va a ser el delegate del `UISplitViewController`. Este delegate tiene dos métodos que se llamarán cuando la orientación sea horizontal y se vayan a mostrar las dos vistas y otro cuando la orientación sea vertical y únicamente se muestre la vista de detalle y en un popover la vista master.

Implementa el protocolo

	@interface HZFMapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate>

Implementa los métodos del protocolo

	- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
	    barButtonItem.title = NSLocalizedString(@"Checkins", @"Checkins");
	    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
	    self.masterPopoverController = popoverController;
	}

	- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	    // Called when the view is shown again in the split view, invalidating the button and popover controller.
	    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
	    self.masterPopoverController = nil;
	}


En la master View nos hace falta tener una referencia a la vista de detalle. Para que al seleccionar un elemento de la tabla podamos hacer un checkin en la vista de detalle, se añada la anotación al mapa y se centre el mapa en ese punto.

	@property (nonatomic, strong) HZFMapViewController *mapViewController;

Para asignar esta referencia, lo hacemos a través de la referencia al splitViewController

	- (void)viewDidLoad {
		...    
	    self.mapViewController = (HZFMapViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	}

Al selecionar una celda, asignamos el checkin en la vista de mapa

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	        HZFCheckin *checkin = [checkins.data objectAtIndex: indexPath.row]; 
	        self.mapViewController.checkin = checkin;
	    }
	}

El iPhone seguirá ejecutandose por el segue que teníamos puesto, así que en este caso no tendremos problemas.


## Pull Request no alinea bien

Creo que encontré un bug en la librería y es que las etiquetas no se alinean correctamente. Para solucionarlo fue suficiente con modificar en el fichero `SVPullToRefresh`.

	58  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ceil(self.scrollView.contentSize.width*0.21+44), 20, 150, 20)];
	86  arrow.frame = CGRectMake(ceil(self.scrollView.contentSize.width*0.21), 6, 22, 48);

## Añadir un nuevo checkin

Para el código de nuevo checkin añadirmos un nuevo TableViewController. Copia la interfaz que teníamos preparada en la vista de iPhone y asigna la clase de HZFNewChekinViewController. Añade un botón con un `+` al listado de checkins y conecta la dos vistas mediante un Segue. En este caso el tipo de segue que vamos a utilizar es un Modal Form. A la vista de nuevo checkin le pondremos los botones de guardar y cancelar.

El código del botón de cancelar tendrá que ocultar el ModalViewController

	- (IBAction)cancelButton:(id)sender {
	    [self dismissModalViewControllerAnimated:YES];
	}

El código del botón de guardar, reutilizaremos el código que ya teníamos y nos hará falta poner algo de código específico

	- (IBAction)save:(UIBarButtonItem *)sender {    
	 	...
	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
	        [self.navigationController popViewControllerAnimated:YES];
	    }else{
	        [self dismissModalViewControllerAnimated:YES];        
	    }
	}


Añade también un tableViewController para el listado de categorias igual que teníamos anteriormente.

Asegurate de conectar todos los outlets correctamente para que la interfaz funcione correctamente.


## Ejercicio

Añade la vista para compartir un checkin en twitter y por email. Una posible opción para hacer esto es poner un botón en la parte derecha de la barra de navegación y que la vista se muestre como un popover.


## Solución

Añade el botón de compartir en la parte derecha de la barra de navegación.

Añade un nuevo tableViewController con celdas estáticas. Asigna la clase HZFCheckinView.

Añade el segue de popover desde la vista de mapa, en el botón de compartir al nuevo tableViewController. Prueba en el simulador y se debería abrir el popover. Asigna un identificador al segue.

Tenemos un problema y es que en la versión de iPhone, la sección 0 es la que tiene un enlace a los mapas y la 1 es la sección con los enlaces para compartir.

Lo podemos solucionar fácilmente poniendo la condición según dispositivo

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	    int shareSection;
	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
	        shareSection = 1;
	    }else{
	        shareSection = 0;
	    }
	    
	    if(indexPath.section == shareSection){
	        if(indexPath.row == 0){
	            [self twitterShare];
	        }else if(indexPath.row == 1){
	            [self emailShare];
	        }
	    }
	    
	    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	}

Falta pasarle la información del checkin seleccionado desde la vista de mapa a la vista para compartir. Igual que hemos anteriormente, en el método prepareForSegue. Comprobamos si el controlador tiene una property checkin y si es así la asignamos.

	- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	    id destination = segue.destinationViewController;
	    SEL selector = @selector(setCheckin:);
	    if([destination respondsToSelector:selector]){
	        [destination performSelector:selector withObject:self.checkin];
	    }
	}

Con esto ya nos deberían funcionar correctamente los botones de compartir.

Hay un pequeño problema con el popover. Cada vez que pulsamos el botón de compartir, se crea un nuevo popover que se superpone al anterior. Se nota porque la sombra cada vez va siendo más oscura. La solución a este problema, como siempre en stackoverflow:

[http://stackoverflow.com/questions/8287242/how-to-dismiss-a-storyboard-popover](http://stackoverflow.com/questions/8287242/how-to-dismiss-a-storyboard-popover)

En resumen, dice que debemos asignar el segue al controlador directamente en vez de al botón de compartir y al botón de compartir asignarle una acción que sea la encargada de decidir si se debe ocultar el popover o si se debe enviar el segue. En código esto se traduce a:

Guarda una referencia del popover abierto

	@interface HZFMapViewController ()
	@property (weak, nonatomic) UIPopoverController *sharePopover;
	@end

El código de la acción del botón es

	- (IBAction)showPopover:(id)sender {
	    if(self.sharePopover){
	        [self.sharePopover dismissPopoverAnimated:YES];
	    }else{
	        [self performSegueWithIdentifier:@"showPopover" sender:sender];
	    }
	}

Por último, al enviar el segue tenemos que guardar la referencia al popover

	- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	    ...
	    self.sharePopover = [(UIStoryboardPopoverSegue *)segue popoverController];
	}