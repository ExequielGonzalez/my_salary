final String version = '1.1.0';

final String changelog = '''
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
-Ahora se muestran ayudas sobre como utilizar la aplicación la primera vez que abrís la misma.
-Este historial de cambios es accesible al usuario.
''';

final String homeHelpTitle = 'Bienvenido a “Mi Sueldo”. ';

final String homeHelp = '''

¡Si tu sueldo depende de cuantas horas trabajes, esta aplicación es para vos!

Con el botón “+” en la esquina inferior derecha podes crear un nuevo salario. Esto puede ser un mes, un trabajo particular, etc. ¡Cualquier salario que dependa de la cantidad de horas trabajadas!

Una vez creado un nuevo salario podes acceder al mismo clickeando sobre él.

Si lo deseas, podes eliminar un salario presionando prolongadamente sobre el mismo.

Espero que encuentres esta aplicación útil.

''';

final String monthHelpTitle = '¡Excelente, ya creaste tu primer salario!';

final String monthHelp = '''
Acá podes registrar cada uno de tus periodos de trabajo. Para eso solo debes ingresar un salario por hora y presionar “Empezar”. Esto registrara el horario de comienzo, el de finalización y la fecha en que se realizó.

Para finalizar un periodo de trabajo debes presionar “Finalizar”.

En la esquina superior izquierda verás un resumen con el salario total acumulado de todos los periodos de trabajo.

El campo “monto fijo” es opcional, y solo debería ser usado si tu sueldo tiene una parte fija y una variable. Por ejemplo, colocar tu sueldo mensual, y con la aplicación registrar las horas extras.

''';
