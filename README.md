# Compilación y Ejecución

¿Como se compila?  
En terminal >> ghci  
            >> :load Huffman.hs  

¿Como se ejecuta?  
En terminal >> "nombre de la funcion" "parametros requeridos"

# Descripción del Código

El código implementa el algoritmo de Huffman, que se utiliza para comprimir datos.  
Su función principal es generar una codificación de longitud variable basada en la frecuencia de los caracteres, optimizando así la representación de la información.

# Partes del Código

- **Definición de Estructuras de Datos**:  
  Se definen tipos y estructuras para representar los nodos del árbol de Huffman y la frecuencia de aparición de cada símbolo.

- **Construcción del Árbol de Huffman**:  
  Se implementa la lógica para construir el árbol de codificación a partir de una lista de frecuencias. Esta sección organiza y combina nodos de manera recursiva para formar el árbol.

- **Generación del Diccionario de Codificación**:  
  Se recorre el árbol para generar un diccionario que asocia cada símbolo con su código binario correspondiente.

- **Funciones Auxiliares y Manejo de Errores**:  
  Se incluyen funciones adicionales para el manejo de listas, validación de entrada y proporcionar mensajes de error claros al usuario.

Esta estructura modular facilita la lectura, mantenibilidad y extensión del código en caso de futuras mejoras o adaptaciones.


