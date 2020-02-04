# mi_sueldo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Changelog:

V 1.0.0
-Primera versión estable.

V 1.0.1
-Se corrigió un error que actualizaba el horario de finalización del ultimo trabajo registrado cada vez que se abría la aplicación.
-Se muestra en la página principal la cantidad de horas y trabajadas y el salario acumulado.
-Los textos ahora se adaptan mejor a distintas pantallas.

V 1.0.2
-Corregido error visual en la ventana “Información”.
-Ahora la aplicación sigue contando, aunque sea cerrada.
-Ya no es necesario volver a la pagina principal para guardar los cambios.

V 1.1.0
-Ahora la página principal se actualiza sola cada 2 segundos.
-Ahora se colorea el "salario" que esta activo actualmente (desde la página principal)
-Si hay un contador activo, solo se puede acceder al salario que lo contiene, es decir el que se encuentra coloreado.
-Ya no se puede borrar un contador activo.

//Borrar: Cuando algún salario esta activo (sin contar el primero), el primero aun aumenta su sueldo, pero no su horario. No deberia alterarse
//Borrar: creo que el problema esta en Month, por como se lee el SharedPreference. Copiar lo de home.
