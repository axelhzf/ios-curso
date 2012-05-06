---
layout: default
title : Outlets y Actions
---
{% assign solucion = false %}

# Outlets y Actions

## Preparación

Ahora que ya sabemos un poco de Objetive-C, vamos a a continuar trabajando sobre nuestra aplicación `Hello World`. Si no pudiste terminarla a tiempo puedes descargar el código para que tengas una base sobre la que trabajar:

[https://github.com/axelhzf/ios-curso/tree/6652a7aded7ccdd46567cda671e89f6373908faf/HelloWorld2](https://github.com/axelhzf/ios-curso/tree/6652a7aded7ccdd46567cda671e89f6373908faf/HelloWorld2)

## Patrón MVC

Modelo Vista Controlador (MVC) es un patrón de arquitectura de software que separa los componentes de una aplicación: datos, interfaz de usuario y lógica de negocio.

- `Model` : Datos de la aplicación.
- `View` : Interfaz de usuario.
- `Controller` : Lógica de negocio, conecta el modelo con la vista.

MVC permite maximizar la reusabilidad. Por ejemplo, la clase que pinta un botón en la pantalla, se podría reutilizar en todos los botones que tiene la aplicación siempre y cuando esa sea su única responsabilidad. Si además de pintar un botón en la pantalla tuviese una lógica que se debe ejecutar al pulsar el botón no se podría reutilizar. Obligándonos a repetir el código que pinta un botón en la pantalla para cada uno de los botones de nuestra aplicación.

En términos de una aplicación iOS:

- El Modelo serán normalmente clases simples que extiendan de NSObject o entidades de Core Data (ORM).
- La Vista, la interfaz de usuario, se puede definir utilizando el Interface Builder o directamente en código.
- Los controladores pueden ser cualquier clase. UIKit provee algunos controladores genéricos como por ejemplo el `UIViewController` o `UITableViewController`.

Si definimos la interfaz de usuario mediante el Interface Builder debemos conectarla a el código del controlador. Para conectar la vista con el controlador se utilizan unas propiedades especiales que se llaman `Outlets`. En el otro sentido, las interacción del usuario con los elementos de la vista puede disparar la ejecución ciertos métodos llamados `Actions`. Por ejemplo se puede configurar una `Action` para que se ejecute cuando el usuario pulsa un botón.

## Analizando el UIViewController

El controlador por defecto que crea la plantilla extiende de `UIViewController` y tiene los métodos:

* `viewDidLoad` : Este método se llama cuando se ha terminado de cargar el fichero nib
* `viewDidUnload` : Este método se llama cuando la vista del controlador va a ser liberada de la memoria. Aquí es importante que pongamos a null las propiedades que tenga el controlador para que no se produzcan fugas de memoria.
* `shouldAutorotateToInterfaceOrientation:` : Este método es que le indica a la vista si debe de rotar cuando el usuario rote el dispositivo.


## Restringiendo el cambio de orientación

Vamos a hacer unas pruebas con el método `shouldAutorotateToInterfaceOrientation`.

Arrancamos la aplicación en el simulador y prueba a rotar el dispositivo desde el menú `Hardawre/Rotar Izquierda o Derecha`.

Ahora modifica el método haciendo que devuelva `false` y vuelve a hacer la prueba de la rotación.

Busca en la documentación el enumerado `UIInterfaceOrientation` desde el menu `Help/Documentation and Api Reference` y prueba a restringir la rotación únicamente a algunas orientaciones.

## Outlets

Son properties especiales declaradas con la palabra clave `IBOutlet`.

    @property (nonatomic, retain) IBOutlet UIButton *miBoton;

IBOutlet le indica Xcode que vamos a conectar esa property con un objeto de un fichero nib.

## Actions

Las acciones son métodos que devuelve `IBAction`. En realidad es un sinónimo de void, es decir, estos métodos no devuelven nada. La palabra `IBAction` le indica a Interface Builder que el método puede ser disparado desde un evento lanzado por un elemento gráfico de un fichero nib.

Normalmente la definición de estos métodos es

	- (IBAction)doSomething:(id)sender;
	- (IBAction)doSomeething;


La primera definición recibe como parámetro el elemento que lanzó el evento que produjo que se invocase al método. Esta definición es útil cuando tenemos varios elementos que pueden llamar a la misma acción y desde la acción tenemos que distinguir quien realizó la llamada.

## Añadiendo interacción

Vamos a añadir un botón en nuestra aplicación que va a cambiar el texto de hola mundo por otro.

Lo primero que debes hacer es abrir el fichero de la interfaz gráfica y selecciona el `Assistant Editor` en la parte de arriba a la derecha. Con esta vista vamos a tener en la pantalla por un lado la vista y por otro lado la interfaz o la implementación de su controlador. Es una vista muy útil cuando estamos conectando las dos cosas.

Los siguientes pasos son:

- Arrastra un botón `Round Rect Button` dentro de la vista y ponle el texto **Cambiar texto**
- Pulsa Ctrl y Arrastra desde un botón hacia el código, dentro de `@Interface`
- Aparecerá un popup: Crea un Action, con nombre **cambiarTexto**, type `UIButton`, event `Touch Up Inside` y arguments **None**
- Xcode creará la cabecera del método en el .h y el cuerpo del método en el .m
- Crea un `IBOutlet` para la etiqueta arrastrando de la misma forma que hicimos antes, pero esta vez seleccionando IBOutlet en vez de IBAction. Esto va a crear código en la interfaz y la implementación. Añadirá un @synthesize, y pondrá a nil la property en el método viewDidUnload. Todo esto automágicamente. Abre el fichero de la implementación y revisa los cambios que ha hecho Xcode automáticamente.
- En la función **cambiarTexto** añade el siguiente código

<br/>
	
	- (IBAction)cambiarTexto {
		label.text = @"Hola curso iOS";
	}

## Ejercicio

Añade un segundo botón. Conecta los dos botones a la **misma** acción. Escribe la acción de forma que cuando se pulse un botón se escriba un texto y cuando se pulse el otro botón se escriba otro texto distinto.

Pista: Utiliza la definición de acción con un parámetro.

{% if solucion %}
## Solución

Para poder distinguir entre los dos botones dentro de la misma acción, vamos a declarar un outlet para cada uno de ellos. Los llamaremos boton1 y boton2.

De manera que desde la acción vamos a poder comparar el sender y saber qué botón fue pulsado:

	- (IBAction)cambiarTexto:(id)sender {
	    if(sender == boton1){
	        label.text = @"Se pulsó el botón 1";
	    }else if(sender == boton2){
	        label.text = @"Se pulsó el botón 2";        
	    }
	}

Puedes descargar la solución del ejercicio desde 

[https://github.com/axelhzf/ios-curso/tree/1d54949128bfc286ed1f3716c84032d72c476ec7/HelloWorld2](https://github.com/axelhzf/ios-curso/tree/1d54949128bfc286ed1f3716c84032d72c476ec7/HelloWorld2)

{% endif %}