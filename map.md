---
layout: default
title : Map
---

# Mapa

Vamos a crear una nueva vista de mapa, para mostrar la posición de un checkin.El funcionamiento será que cuando un usuario seleccione un checkin de la lista se mostrará el mapa con su posición.

Lo primero que debemos hacer es como siempre, ir al StoryBoard y añadir un nuevo UIViewController y lo enlazamos con la selección de la celda de un checkin. Al nuevo viewController le vamos a añadir una vista demapa, lo hacemos arrastrando un MapView.

Si probamos el código en el simulador nos dará un error
`Could not instantiate class named MKMapView`. Esto es porque la vista de mapa está en un framework que no está incluida por defecto. Para añadir un nuevo framework. Pulsa en el archivo del proyecto, `Linked Frameworks and Libraries` y +. Añade `MapKit.framework`. Si vuelves a probar el código en el simulador, esta vez si deberías ver el mapa.

Crea el controlador para la vista. Este controlador va a implementar el protocolo `MKMapViewDelegate`. Los métodos de este protocolo nos van a permitir controlar el mapa.

    #import <UIKit/UIKit.h>
    #import <MapKit/MapKit.h>

    @interface HZFMapViewController : UIViewController <MKMapViewDelegate>

    @property (strong, nonatomic) IBOutlet MKMapView *mapView;

    @end

Asegúrate de asignar en el StoryBoard el Controlador a la vista y el delegate de la vista de mapa también al Controlador. Añade también un outlet para la vista de mapa. Una vez lo tengamos todo conectado. Ya estamos preparados para escribir el código del controlador.

# Añadir una anotación

Para añadir una nueva anotación tenemos que creer un `MKPointAnnotation`. Tenemos que asignarle unas
coordenadas con el struct `CLLocationCoordinate2D`.

        CLLocationCoordinate2D annotationCoord;
        annotationCoord.latitude = 28.268611;
        annotationCoord.longitude = -16.605556;

        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = @"Curso ios";
        annotationPoint.subtitle = @"Tenerife";
        [self.mapView addAnnotation:annotationPoint];


# Centrar el mapa en una región

Para centrar el mapa en una región debemos definir una región `MKCoordinateRegion`. Las regiones vienen definidas
por las coordenadas del centro y el tamaño de la región.

        CLLocationCoordinate2D center;
        center.latitude = 28.268611;
        center.longitude = -16.605556;

        MKCoordinateRegion region;
        region.center = center;
        region.span.latitudeDelta = 1;
        region.span.longitudeDelta = 1;

        [self.mapView setRegion:region animated:YES];

# Mostrar la posición actual del usuario

Si queremos mostrar la posición del usuario en el mapa, únicamente tenemos que

    self.mapView.showsUserLocation = YES;

# Personalizar las anotaciones

Si queremos personalizar la vista de las anotaciones, tenemos que implementar un método del `MKMapDelegate`,
`(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation`.

    - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
        MKAnnotationView *annotationView= nil;
        if(annotation != mapView.userLocation) {
            static NSString *annotationViewId = @"annotationViewId";
            annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewId];
            if (annotationView == nil) {
                annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewId];
            }
            annotationView.image = [UIImage imageNamed:@"bar.png"];
        }
        return annotationView;
    }

El método utiliza la misma técnica de reutilización de elementos que las tablas. Primero vemos si podemos reutilizar una vista, si no podemos creamos una nueva, y posteriormente la configuramos.

En este caso en concreto no se está personalizando la anotación que le indica al usuario donde está.


# Ejercicio

- Conecta la vista principal con la vista de mapa, de manera que al seleccionar una fila, se muestre el mapa con una anotación centrada en las coordenadas correspondientes.
- Personaliza la vista de las anotaciones para que se muestre la imagen según el tipo de checkin.
- Muestra la localización del usuario.

## Bonus

- Añade un botón a la barra de navegación que permita cambiar entre los diferentes tipos de mapa.

### Tips:

- Para cambiar el tipo de mapa busca documentación de la clase `MKMapView` y el método `mapType:`
- Para mostrar los diferentes tipos de mapa una buena opción podría ser utilizar `UIActionSheet`. Busca documentación de cómo se usa.

# Solución

Lo primero que vamos a hacer es comunicar la vista principal con la vista de la tabla. Para ello debemos asignarle un identificador al Segue y sobrescribir el método prepareForSegue:

    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if([segue.identifier isEqualToString:@"toMapView"]){
            HZFCheckinTableViewCell *cell = (HZFCheckinTableViewCell *)sender;
            id destination = segue.destinationViewController;
            SEL setCheckin = @selector(setCheckin:);
            if([destination respondsToSelector:setCheckin]){
                [destination performSelector:setCheckin withObject:cell.checkin];
            }
        }
    }

El sender del Segue será la propia tabla, donde tenemos almacenado el checkin que está mostrando y que será el que debemos pasarle a la vista de mapa. En la clase de mapa creamos una nueva property `checkin` que contendrá el checkin que debemos mostrar en el mapa. Para mostrar el checkin en el mapa:

    - (void)viewWillAppear:(BOOL)animated {
        [self showCheckinAnnotation];
        [self centerMapInCheckin];
    }

    - (CLLocationCoordinate2D) checkinCoordinate {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = self.checkin.latitud;
        coordinate.longitude = self.checkin.longitud;
        return coordinate;
    }

    - (void)showCheckinAnnotation {
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = [self checkinCoordinate];
        annotationPoint.title = self.checkin.nombre;
        annotationPoint.subtitle = self.checkin.categoria;
        [self.mapView addAnnotation:annotationPoint];
    }

    - (void)centerMapInCheckin {
        MKCoordinateRegion region;
        region.center = [self checkinCoordinate];
        region.span.latitudeDelta = 1;
        region.span.longitudeDelta = 1;

        [self.mapView setRegion:region animated:YES];
    }

Para personalizar la imagen de la anotación según la categoría nos basta con implementar el método
`(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation`

        NSString *img = [NSString stringWithFormat:@"%@.png", self.checkin.categoria];
        annotationView.image = [UIImage imageNamed:img];


Con esto ya tenemos lo básico, vamos a por el bonus ahora. Abre el storyboard y añade un botón a la barra de navegación, le ponemos un icono y lo asignamos a una acción de nuestro controlador.
La implementación de la acción debe mostrar el selector de los mapas.

    - (IBAction)showMapTypeSelector:(id)sender {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Tipo de mapa"
                                        delegate:self
                                        cancelButtonTitle:@"Cancelar"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:@"Standard", @"Hybrid", @"Satellite", nil];
        [actionSheet showInView:self.view];
    }

En el parámetro delegate debemos pasar un UIActionSheetDelegate que será el que se llame cuando el usuario haya pulsado alguno de los botones. En este caso, haremos que el propio controlador
implemente este protocolo.

    @interface HZFMapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>

Y la implementación del método debe asignar el tipo de mapa según el botón que pulse el usuario

    - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
        switch (buttonIndex) {
            case 0:
                self.mapView.mapType = MKMapTypeStandard;
                break;
            case 1:
                self.mapView.mapType = MKMapTypeHybrid;
                break;
            case 2:
                self.mapView.mapType = MKMapTypeSatellite;
                break;
            default:
                break;
        }