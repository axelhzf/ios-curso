---
layout: default
title : Outlets y Actions
---

# Outlets y Actions

## Preparación

Ahora que ya sabemos un poco de objetiveC, vamos a a continuar trabajando sobre nuestra aplicación `Hello World`. Si no pudiste terminarla a tiempo puedes descargar el código para que tengas una base sobre la que trabajar:

[https://github.com/axelhzf/ios-curso/tree/6652a7aded7ccdd46567cda671e89f6373908faf/HelloWorld2]()


## Patrón MVC

Modelo Vista Controlador (MVC) es un patrón de arquitectura de software que separa los datos de una aplicación, la interfaz de usuario y la lógica de negocio en tres componentes distintos:

- Model: Clases que almacen los datos de la aplicación.
- View: Interfaz de usuario.
- Controller: Clases que conectan las vista con los modelos. Contiene la lógica de la aplicación.

MVC permite maximizar la reusabilidad. Por ejemplo, la clase que pinta un botón en la pantalla, se podría reutilizar en todos los botones que tiene la aplicación siempre y cuando esa sea su única responsabilidad. Si además de pintar un botón en la pantalla tuviese una lógica que se debe ejecutar al pulsar el botón no se podría reutilizar. Obligandonos a repetir el código que pinta un botón en la pantalla para cada uno de los botones de nuestra aplicación.

En el desarrollo de aplicaciones para iOS se ve claramente cómo se utiliza este patrón:

- El Modelo serán normalmente clases siemples que extiendan de NSObject
- La Vista normalmente se definirá mediante el Interface Builder. También escribirlas directamente en código.
- Los controladores puedes ser clases cualquiera que extienden de NSObject, pero a menudo son clases que extienden de controladores genéricos del UIKit, como por ejemplo UIViewController.


Para conectar las vistas con los controladores se utilizan unas propiedades especiales que se llaman `Outlet`. De forma que puedes conectar los elementos de la vista a elementos en el código. En el otro sentido, las interacción con los elementos de la vista puede disparar ciertos métodos llamados `Actions`. Por ejemplo se puede configurar de manera que cuando se pulse un botón, se llame a un método.

# Analizando el UIViewController

El controlador por defecto que nos crea la plantilla que utilizamos extiende de UIViewController y tiene los métodos

* `(void)viewDidLoad` : Este método se llama cuando se ha terminado de cargar el fichero nib
* `(void)viewDidUnload` : Este método se llama cuando la vista del controlador va a ser liberada de la memoria. Aquí es importante que pongamos a null las propiedades que tenga nuestro controlador para que no se produzcan fugas de memoria.
* `(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation` : Este método es que le indica a la vista si se debe de rotar cuando el usuario mueva el dispositivo


## Restringiendo el cambio de orientación

Vamos a hacer unas pruebas con el método `shouldAutorotateToInterfaceOrientation`.

Arrancamos la aplicación en el simulador y probamos a rotar el dispositivo desde el menú `Hardawre/Rotar Izquierda o Derecha`.

Ahora modifica el método haciendo que devuelva `false` y vuelve a hacer la prueba de la rotación.

Busca en la documentación el enumerado `UIInterfaceOrientation` desde el menu `Help/Documentation and Api Reference` y prueba a restringir la rotación únicamente a algunas orientaciones.

# Outlets

Son properties especiales declaradas con la palabra clave `IBOutlet`.

    @property (nonatomic, retain) IBOutlet UIButton *miBoton;

IBOutlet es una palabra clave para indicarle a Xcode que vamos a conectar esa property con un objeto de un fichero nib.

# Actions

Las acciones son métodos que devuelve `IBAction`. En realidad es un sinonimo de void, es decir, estos métodos no devuelven nada. La palabra `IBAction` le indica a Interface Builder que el método puede ser disparado desde un evento lanzado por un elemento gráfico de un fichero nib.

Normalmente la definición de estos métodos es

- (IBAction)doSomething:(id)sender;
- (IBAction)doSomeething;


La primera definición recibe como parámetro el elemento que lanzó el evento que produjo que se invocase al método. Esta definición es útil cuando tenemos varios elementos que pueden llamar a la misma acción y desde la acción tenemos que distinguir quien realizó la llamada.


# Añadiendo interacción

Vamos a añadir un botón en nuestra aplicación que va a cambiar el texto de hola mundo por otro.

Lo primero que debes hacer es abrir el fichero de la interfaz gráfica y selecciona el `Assistant Editor` en la parte de arriba a la derecha. Con esta vista vamos a tener en la pantalla por un lado la vista y por otro lado la interfaz o la implementación de su controlador. Es una vista muy útil cuando estamos trabajando en conectar una cosa con la otra.

Los siguientes pasos son:

- Arrastra un botón **Round Rect Button** dentro de la vista y ponle el texto **Cambiar texto**
- Pulsa Ctrl y Arrastra desde un botón hasta dentro del @Interface
- Saldra un popup: Crea un Action, de nombre **cambiarTexto**, type **UIButton**, event **Touch Up Inside**, arguments **None**
- Xcode creará la cabecera del método en el .h y el método en el .m
- Crea un IBOutlet para la etiqueta arrastrando de la misma forma que hicimos antes, pero esta vez seleccionando IBOutlet en vez de action. Esto va a crear código en la interfaz y la implementación implementación. Añadirá un @synthesize, y pondrá a nil la property en el método viewDidUnload. Todo esto automáticamente. 
- Abre el fichero de la implementación y revisa los cambios que ha hecho Xcode automáticamente.
- En la función **cambiarTexto** añade el siguiente código

<br/>
	
	- (IBAction)cambiarTexto {
		label.text = @"Hola curso iOS";
	}

# Ejercicio

Añade ahora un segundo botón. Conecta los dos botones a la **misma** acción. Escribe la acción de forma que cuando se pulse un botón se escriba un texto y cuando se pulse el otro botón se escriba otro texto.

Pista: Utiliza la definición de acción con un parámetro.

# Solución

Para poder distinguir entre los dos botones dentro de la misma acción, vamos a declarr un outlet para cada uno de ellos. Lo llamaremos boton1 y boton2.

De manera que desde la acción vamos a poder comparar el sender y saber qué botón fué pulsado:

	- (IBAction)cambiarTexto:(id)sender {
	    if(sender == boton1){
	        label.text = @"Se pulsó el botón 1";
	    }else if(sender == boton2){
	        label.text = @"Se pulsó el botón 2";        
	    }
	}

Puedes descargar la solución del ejercicio desde 

[https://github.com/axelhzf/ios-curso/tree/1d54949128bfc286ed1f3716c84032d72c476ec7/HelloWorld2]()