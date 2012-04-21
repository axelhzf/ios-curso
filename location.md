---
layout : default
title : Location
---

# Localización

En la vista de nuevo checkin queda pendiente guardar la ubicación. Para
obtener la posición del usuario se utiliza una combinación de información (GPS,
 puntos wifis, celdas de teléfono). Para tener acceso desde el código se
 utiliza la librería `CoreLocation`.

Lo primero es añadir el framework como dependencia del proyecto y utilizar
el import en las clases donde vamos a utilizarla.

    #import <CoreLocation/CoreLocation.h>

La clase `CLLocationManager` es la que permite obtener la ubicación
actualizada del usuario. Para configurarla:

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = 100.0f;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;

El parámetro `distanceFilter` es la distancia mínima (en metros) que el dispositivo
se debe mover para que se lance el evento. El parámetro `desiredAccuracy` es la
precisión requerida de la medición. Cuanto mayor sea la precisión, mayor es el
tiempo que tarda y la batería necesaria. El delegate es un objeto que
debe implementar el protocolo `CLLocationManagerDelegate` y es el
que será notificado de las actualizaciones de la posición del usuario.

Para implementar el prótocolo:

    @interface HZFNewCheckinViewController : UITableViewController <CLLocationManagerDelegate>

Cuando la posición se actualice se invocará el método:

    - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

Para empezar el rastreo de la posición del usuario

        [locationManager startUpdatingLocation];

> Mientras estás depurando la aplicación puedes simular cambios de posición desde el menú `Depurar/Ubicación` pero es especialmente importante que toda aplicación que haga uso de sensores se pruebe en un dispositivo físico.

# Ejercicio

- Añade un CLLocationManager a la vista de nuevo checkin.
- Cuando se recibe una actualización se debe actualiza la información en la tabla
- Al añadir un nuevo checkin a la lista se debe asignar las últimas coordenadas

### Tip
- Escribiendo este código me encontré con un problema y es que la celda no se
actualizaba. Mi sospecha es que estaba actualizando la interfaz desde otro
thread. Para solucionarlo:

        [cell setNeedsLayout];

# Solución


        - (void)initLocationManager {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 100.0f;
        }

        - (void)viewDidLoad {
            ...

            [self initLocationManager];
        }

        - (void)viewWillAppear:(BOOL)animated {
            [super viewWillAppear:animated];
            [self.locationManager startUpdatingLocation];
        }

        - (void)setLastLocation:(CLLocation *)_lastLocation {
            lastLocation = _lastLocation;

            self.latitudeCell.detailTextLabel.text = [NSString stringWithFormat:@"%f", lastLocation.coordinate.latitude];
            [self.latitudeCell setNeedsLayout];

            self.longitudeCell.detailTextLabel.text = [NSString stringWithFormat:@"%f", lastLocation.coordinate.longitude];
            [self.longitudeCell setNeedsLayout];
        }

        - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
            self.lastLocation = newLocation;
        }