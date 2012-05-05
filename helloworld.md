---
layout: default
title : Hello world
---

# Hello world

En esta sección aprenderemos como crear un proyecto básico y será nuestra primera toma de contacto con Xcode (el IDE de desarrollo de Objective-C). Aprenderemos la estructura de un proyecto, a utilizar el editor de interfaces gráficas y cómo ejecutar aplicaciones en el simulador.

## Instalación

Lo primero que debemos hacer es descargar el SDK para iOS. En los ordenadores del curso ya está descargado e instalado para adelantar tiempo.

Para descargar el SDK tenemos que ir iOS Dev Center (hace falta tener un Apple ID, pero es un registro gratuito).

[https://developer.apple.com/devcenter/ios/index.action]()

En esta página se encuentran enlaces a la documentación, a códigos de ejemplo y a diversos recursos que son muy útiles para el desarrollo de aplicaciones. También hay un enlace a la página de descarga de Xcode 4 que redirige a la App Store donde se puede descargar la última versión de Xcode completamente gratis. El único requesito es tener OS X Lion instalado en el equipo.

Para hacer el tutorial se utilizó la versión 4.3 de Xcode (la última versión hasta el momento de preparar el material).

El paquete de instalación incluye Xcode, Instruments (herramienta para depurar y hacer profiles de aplicaciones) y el SDK de desarrollo de aplicaciones para Mac OS X y para iOS.

La versión gratuita incluye un simulador donde podremos ejecutar aplicaciones de iPhone y iPad. El simulador no soporta componentes que dependen de hardware como el acelerómetro o la cámara. Con la versión gratuita no se puede probar aplicaciones en un dispositivo físico ni distribuir las aplicaciones en la App Store. Para ello es necesario tener una cuenta de desarrollador. Los precios de estas cuentas son:

- Standard program $99/año [https://developer.apple.com/programs/ios/](https://developer.apple.com/programs/ios/)
- Enterprise prpogram $299/año [https://developer.apple.com/programs/ios/enterprise/](https://developer.apple.com/programs/ios/enterprise/)


## Simulador

Una de las principales diferencia entre el SDK de iOS y el de Android es que el de iOS cuenta con un simulador del dispositivo mientras que Android cuenta con un emulador. La principal diferencia es que un emulador imita tanto el software como el hardware mientras que el simulador de iOS se limita a imitar el software. La primera impresión es que la aproximación de Android es la adecuada porque tenemos un entorno de pruebas más similar al real. Pero en la práctica es una muy mala idea. El emulador es extremadamente lento, consume muchos recursos y hace el proceso de desarrollo más lento. 

## Creación del proyecto

Abre el Xcode y pulsa `File/New Project`.

Se mostrará una ventana con una serie de plantillas de proyectos. Selecciona la plantilla más simple de todas, la `Single View Application` y rellena los datos

- Product Name: `HelloWorld`
- Company Identifier : `com.axelhzf`
- Class Prefix : `HZF`
- Device Family: `iPhone`
- Marca `Automatic Reference Count`

Objective-C no tiene el concepto de paquetes como Java. Para evitar posibles conflictos en los nombres de las clases al utilizar librerías de terceros se utilizan prefijos en los nombres de los ficheros. El prefijo que suelo utilizar para mis clases es HZF. Apple se reserva el uso de todos los prefijos de 2 letras, como por ejemplo `NS` (NSString) o `UI` (UIButton).

## Estructura del proyecto

* `Hello World` : Proyecto
   * `HZFAppDelegate.h` : Interfaz del AppDelegate
   * `HZFAppDelegate.m` : Implementación del AppDelegate
   * `HZFViewController.h` : Interfaz del Controlador
   * `HZFViewController.m` : Implementación del Controlador
   * `HZFViewController.xib` : Vista de interfaz de usuario
   * `Supporting Files` : Código fuente y recursos que no son Objective-C
	   * `HelloWorld-Info.plist` - fichero de properties con información de la aplicación
	   * `InfoPlist.strings` - Properties localizables
	   * `main.m` - método main() . Normalmente no tendrás que cambiar esto
	   * `HelloWorld-Prefix.pch` - lista de .h from external frameworks pch (precompiled header).
* `Frameworks` : Librerías
* `Products` : Resultado de las compilación

## Interfaz gráfica de Xcode

Toolbar :

- Run/Stop
- Scheme : Target + Build Settings
- Toggle breakpoints
- Activity View : Muestra la acción que se está procesando
- Editor
  - Standard View : Un único panel
  - Assistant View : Panel dividido en dos
  - Editor de diferencias
- View
- Organizer : Devices/Repositories/Projects/Archives/Documentation

Navigator View:

- Project Navigator
- Symbol Navigator
- Search Navigator
- Issues Navigator
- Debug Navigator
- Breakpoint Navigator
- Log Navigator : Recent  build result and run lugs

JumpBar:

- Related files
- Previous/Next file
- Ruta del fichero con respecto al proyecto. Al final del todo, un ménu con la lista de métodos y otros símbolos definidos en el fichero.

## Atajos de teclado

Para ver los atajos de teclado y para cambiarlos ir a Preferences (Cmd + ,) / Key Bindings

- Cmd + B : Compila la aplicación
- Cmd + N : New File
- Cmd + Shift + O : Open quickly
- Cmd + 1, 2, 3, 4, 5, 6, 7 : Cambia entre cada una de las Navigator Views
- Cmd + Alt + 1, 2 , 3, 4, 5, 6 : Cambia entre la parte de arriba
- Cmd + Alt + Ctrl + 3 : Buscar elementos gráficos
- Cmd + R : Compilar y ejecuta la aplicación
- Ctrl + Cmd + Up : Cambiar entre .h y .m

## Interfaz de usuario

La interfaz de usuario de la aplicación podemos codificarla a mano o podemos utilizar el Interface Builder para hacerlo de forma gráfica. A partir de la interfaz gráfica, Interface Builder crea objetos de Objective-C igual que si se escribiera el código a mano y serializa esos objetos en los ficheros xib para que puedan ser cargados directamente en memoria.

Abre el fichero `HZFHelloWorld.xib` que contiene la interfaz de usuario y se abrirá el Interface Builder. En versiones anterior de Xcode era una aplicación separada que se llamaba Interface Builder, pero a partir de Xcode 4 viene integrado.

> Las extensiones de los ficheros son \*.xib (moderno) y \*.nib (antiguo). Se ha quedado como costumbre llamar los ficheros nib files. En muchos sitios de la documentación de la propia Apple se nombran como nib files.

En este editor, la barra de la izquierda contiene la jerarquia de los elementos que están en la vista:

- File's Owners : Representa el objeto que cargó el fichero nib
- First Responder : Es el elemento con el que el usuario está interactuando. Por ejemplo si el usuario esta introduciendo texto, el first responder será el campo de texto. El first responder va cambiando a medida que el usuario interactura con la aplicación. 
- El terecer icono `View` representa un objeto de la clase `UIView`. Los elementos como botones y campos de texto que añadamos, serán hijos de esta vista.

Para acceder a la Librería de elementos gráficos que podemos utilizar dentro de la interfaz vamos a `View/Utilities/Show Utilities`. Con esto se marcará la 3º pestaña del panel derecho inferior.

Selecciona una etiqueta (UILabel) y arrastrala dentro de la view. Es importante que en la vista jerarquica aparezca como hija de la View principal. Para modificar el texto de la etiqueta haz doble clic.

Para ejecutar la aplicación en el simulador puedes utilizar el atajo de teclado `CMD + R`.

Para personalizar las propiedades de los elementos utiliza la pestaña Inspector. Por ejemplo prueba a cambiar el color de fondo de la vista y color del texto de la etiqueta.

![Hello World](assets/img/helloWorld.png)

## Ejercicio completo

Puedes descargarte el código complete desde 

[https://github.com/axelhzf/ios-curso/tree/6652a7aded7ccdd46567cda671e89f6373908faf/HelloWorld2]()

# Conclusiones

Ya tenemos nuestra primera aplicación creada y ya sabemos cómo probarla en simulador. Para poder seguir antes tenemos que saber un poco más de Objective-C, el lenguaje de programación con el que se programa en iOS. Así que ese será nuestro siguiente paso.
