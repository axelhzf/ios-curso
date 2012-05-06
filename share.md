---
layout : default
title : Compartir
---

{% assign solucion = false %}

## Compartir vía twitter

A partir de iOS 5 twitter viene integrado directamente con el sistema y se puso a disposición de los usuarios una API con la que es muy sencillo enviar tweets desde cualquier aplicación.

La librería es `Twitter.framework` y debemos incluirla para utilizarla en nuestra aplicación. Es muy sencilla de utilizar

    #import <Twitter/Twitter.h>

    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:@"texto inicial"];
    [self presentModalViewController:twitter animated:YES];


> Para realizar las pruebas cree una cuenta de twitter, puedes utilizarla o utilizar tu propia cuenta si lo prefieres. Las credenciales son:  iostwosquare / twosquare

## Compartir vía email

En este caso la librería está disponible a partir de iOS 3 y se llama `MessageUI.framework`.

    #import <MessageUI/MFMailComposeViewController.h>


    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:NO]; 
    [self presentModalViewController:controller animated:YES];

    
Nuestra clase debe implementar el protocolo `MFMailComposeViewControllerDelegate`:
             
    - (void)mailComposeController:(MFMailComposeViewController*)controller  
              didFinishWithResult:(MFMailComposeResult)result 
                            error:(NSError*)error; {
        [self dismissModalViewControllerAnimated:YES];
    }

## Ejercicio

Añade una pantalla que permita compartir checkins vía twitter y vía email

{% if solucion %}

## Solución

El código es el explicado anteriormente. Para no repetirlo dejo únicamente el enlace al código.

[https://github.com/axelhzf/ios-curso/commit/00416c084e1734667eac67913ff5f4758bd61f85](https://github.com/axelhzf/ios-curso/commit/00416c084e1734667eac67913ff5f4758bd61f85)

{% endif %}