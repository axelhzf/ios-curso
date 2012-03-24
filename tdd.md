---
title : TDD en iOS
layout: default
---

# TDD

## ¿Qué es TDD?

Test-Driven Development (TDD) es una práctica de programación que se basa en dos principios básicos: Test First Development y Refactoring. En primer lugar se elige uno de los requisitos que tiene que implementar el código y se escribe una prueba que verifique que se cumple ese requisito. Se comprueba que la prueba falla. Escribimos el código necesario para que la prueba pase y cuando pase el test, refactorizamos el código.

## Ciclo de vida

* Elegir un requisito
* Escribir un test
* Verificar que la prueba falla
* Escribir la implementación lo más sencilla posible que garantice que se cumple la prueba
* Verificar que el código escrito pasa todo los tests
* Refactorizar
* Actualizar la lista de requisitos

## ¿Por qué utilizar TDD?

La ventaja del TDD es que nos permite avanzar en pequeños pasos. Permite que el programador se concentre en solucionar una tarea en concreto. Si aplicamos bien la metodología nos garantiza que nuestro código tendrá un buen "coverage", nuestro código tendrá un buen número de pruebas que garantiza el correcto funcionamiento. Esto es muy importante, para nuestra confianza en el código, en que funciona correctamente.

Además, como nos estamos introduciendo en un lenguaje de programación nuevo, nos permitirá ir dando pequeños pasos, aprendiendo la sintaxis junto con cómo escribir test unitarios.
