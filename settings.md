---
layout : default
---

# Preferencias

A la hora de definir las preferencias de la aplicación existen dos opciones: definirlas como un menú
propio de la aplicación o integrarlas dentro del panel de preferencias del sistema. En esta sección
se verá como hacer la segunda opción.

`Settings.app` es la aplicación de configuración del sistema y permite que aplicaciones de terceros
añadan sus preferencia. De esta forma tenemos las preferencias de todas nuestras aplicaciones centradas en un único
punto.

Las preferencias se representan con la clase `NSUserDefaults`. NSUserDefaults se accede de forma similar a un NSDictionary,
la diferencia principal es que se los datos se almacenan en disco en vez de en memoria.

Desde el punto de vista del programador, una de las ventajas de colocar las preferencias en `Settings.app` es que
no es necesario definir la interfaz gráfica que van a llevar las preferencia. Únicamente es necesario definir un
fichero de propiedades y `Settings.app` se encargará de definir la interfaz de forma automática.

Crea el fichero de preferencia `File/new File/Settings & bundle` y edita el fichero `Root.plist` que se acaba de
crear. El fichero se cero con unas preferencias por defecto, arranca el simulador para que puedas ver gráficamente
en qué se traduce esta definición. Dentro del simulador, en `Settings.app` se creo una nueva opción con nuestra aplicación
y dentro tiene la interfaz definida en el sistema de propiedades.

En la definición de propiedades el campo importante es el `identifier`. Es la clave por la que luego, desde nuestra
aplicación podemos recuperar ese valor.

Para leer las preferencias desde la aplicación, se utiliza la clase `NSUserDefaults`.

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

Esta implementado como un singleton, únicamente hay una instancia en la aplicación. Esta clase funciona
de forma muy similar a un diccionario. Por ejemplo tenemos el método `objectForKey:` para recuperar el valor
dado su identificador.

En el caso de que quieras escribir en las preferencias desde la aplicación, lo único que debes hacer es escribir
en el `NSUserDefaults` y sincronizar, para que los cambios realizados se guarden en disco.

    [defaults synchronize];


# Ejercicio

- Define la configuración para el nombre de usuario de la aplicación.
- Al crear nuevo checkin, asigna el nombre de usuario definido en las propiedades.

# Solución

La definición del fichero plist es bastante sencilla, únicamente nos hace falta simplificar la definición
que viene por defecto eliminando los items 2 y 3 y asignarle un identificador al textfield.

Desde la aplicación, en la clase `HZFNewCheckinViewController` :

    - (NSString *)usernameFromSettings {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        return [userDefaults objectForKey:@"username"];
    }

    - (IBAction)save:(UIBarButtonItem *)sender {
        HZFCheckin *checkin = [[HZFCheckin alloc] init];
        ..
        checkin.usuario = [self usernameFromSettings];
        ..
    }

