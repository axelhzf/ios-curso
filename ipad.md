---
layout : default
title : iPad
---

{% assign solucion = true %}

# iPad

Todas las aplicaciones creadas para iPhone son compatibles con el iPad. El problema es que no se ajustan a toda la pantalla, se ven con la resolución de un iPhone. Para probar cómo se vería nuestra aplicación de iPhone en un iPad únicamente tienes que cambiar el Scheme (Al lado del botón de Run en la parte superior de XCode) a iPad simulator.


Este no es el efecto que queremos conseguir, queremos hacer nuestra aplicación sea totalmente compatible con el iPad. Lo ideal es crear una aplicación Universal. Esto quiere decir que nuestra aplicación funcionará tanto en un iPhone como en un iPad. Esta es la opción correcta cuando quieres que tu aplicación se pueda utilizar en los dos dispositivos. Otra opción es sacar dos versiones distintas de tu aplicación. Es una práctica que suelen llevar a cabo algunos desarrolladores en la App Store y es realmente molesta para los usuarios. Supón que ya has pagado por una aplicación para tu iPhone y tienes que volver a pagar para poder utilizar en el iPad.

Para convertir la aplicación en Universal abre la configuración configuración del proyecto y cambia la opción Devices a Universal. Si volvemos a ejecutar el simulador del iPad veremos que el resultado que obtenemos ahora es mucho mejor. Tenemos suerte porque nuestro interfaz utiliza elementos estándar, tablas, mapas. Son vistas que están preparadas para funcionar con el iPad. En caso de que hubiéramos diseñado vistas propias, quizás hubiéramos tenido problemas al especificar las dimensiones de las cosas.

## Interfaz específica da iPad

Ya tenemos una interfaz compatible con el iPad que es muy distinto a una interfaz específica para el iPad. El iPad tiene una pantalla mucho mayor que un iPhone y tenemos que aprovecharla. Hay elementos de interfaz de usuario específicos para el iPad como son las SplitViews y los Popovers. Vamos a modificar twosquare para incorporar estos elementos. Para conseguirlo, tendremos 2 Storyboars distintos, uno para la interfaz del iPhone y otro para la interfaz del iPad. Es importante que a medida que vayamos haciendo los cambios para hacer una interfaz específica para iPad sigamos probando nuestra aplicación en el iPhone, para comprobar que no hemos roto nada y todo sigue funcionando correctamente.

Crea un nuevo Storyboard `File/New/File/Storyboard` y selecciona iPad en device Family. Ponle de nombre `twoSquare_iPad`. En la configuración del proyecto, en la sección `iPad Deployment Info` selecciona como `Main Storyboard` el Storyboard que acabas de crear.

## SplitViewController

En el nuevo StoryBoard añadimos un `SplitViewController`. En nuestro caso la vista máster será el listado de checkins y el detalle será el mapa. Debemos copiar la interfaz que tenemos en nuestro Storyboard para iPhone. Copia el prototipo de celda de la lista de checkins y añade un mapView a la vista de detalle.

Si necesitamos escribir código específico para un dispositivo podemos utilizar

	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    	// Código para iPhone
	    }else{
	    	// código para iPad
	    }

Por ejemplo, en el caso de la orientación de la vistas. Las guías de interfaz de usuario recomiendan que en iPad permita todas las orientaciones y en iPhone todas menos PortraitUpsideDown. Configura todas las vistas para que se adapten a la recomendación

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	    } else {
	        return YES;
	    }
	}


La vista de detalle, en nuestro caso la vista de mapa, va a ser el delegate del `UISplitViewController`. Este delegate tiene dos métodos que se llamarán cuando la orientación sea horizontal y se vayan a mostrar las dos vistas y otro cuando la orientación sea vertical y únicamente se muestre la vista de detalle y en un popover la vista master.

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

Al seleccionar una celda, asignamos el checkin en la vista de mapa

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	        HZFCheckin *checkin = [checkins.data objectAtIndex: indexPath.row]; 
	        self.mapViewController.checkin = checkin;
	    }
	}

El iPhone seguirá ejecutándose por el Segue que teníamos definido.


## Pull Request no se alinea bien

Creo que encontré un bug en la librería y es que las etiquetas no se alinean correctamente. Para solucionarlo fue suficiente con modificar en el fichero `SVPullToRefresh`.

	58  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ceil(self.scrollView.contentSize.width*0.21+44), 20, 150, 20)];
	86  arrow.frame = CGRectMake(ceil(self.scrollView.contentSize.width*0.21), 6, 22, 48);

## Añadir un nuevo checkin

Para el código de nuevo checkin añadiremos un nuevo TableViewController. Copia la interfaz que teníamos preparada en la vista de iPhone y asigna la clase de HZFNewChekinViewController. Añade un botón con un `+` al listado de checkins y conecta la dos vistas mediante un Segue. En este caso el tipo de Segue que vamos a utilizar es un Modal Form. A la vista de nuevo checkin le pondremos los botones de guardar y cancelar.

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


Añade también un tableViewController para el listado de categorías igual que teníamos anteriormente.

Asegúrate de conectar todos los outlets correctamente para que la interfaz funcione correctamente.


## Ejercicio

Añade la vista para compartir un checkin en twitter y por email. Una posible opción para hacer esto es poner un botón en la parte derecha de la barra de navegación y que la vista se muestre como un popover.

{% if solucion %}

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

{% endif %}	