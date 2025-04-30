import Text.ParserCombinators.ReadP (string)
import Data.Time.Format.ISO8601 (yearFormat)
data Huffman = Hoja Int Char | Nodo Int Huffman Huffman deriving (Eq,Ord)


--Función que sirve para obtener el valor de un nodo de Huffman, independientemende de si es de tipo Hoja o Nodo
valor::Huffman -> Int
valor (Hoja i _) = i
valor (Nodo i _ _) = i

{-
Del mismo modo que indicamos la instancia de Eq y Ord, podríamos instancias la clase Show; que sirve para que Haskell
sepa cómo mostrar automáticamente los tipos. Alternativamente decidimos usar la palabra reservada "instance" para
que manualmente indiquemos la forma en que queremos que represente el tipo en una cadena.
Esto es similar a la manera en que funciona el método toString en P.O.O.
-}
instance Show Huffman where
  show (Hoja i c) = "(Hoja "++ show(i) ++" "++[c]++")"
  show (Nodo i izq der) = "{Nodo "++show(i) ++ " 0:"++show(izq) ++ " 1:"++show(der)++"}"

--Función que recibe una cadena y cuenta las repeticiones de cada caracter
repeticiones :: String -> [(Int,Char)]
repeticiones [] = [] 
repeticiones (x:xs) = (longitud (filter(==x) (x:xs)), x): repeticiones(filter(/=x) xs)

-- Funcion que obtiene las repeticiones de cada caracter despues de convertirlo a Huffmann
repeticionesEnHuffman :: Huffman -> Int
repeticionesEnHuffman (Hoja i _) = i
repeticionesEnHuffman (Nodo i _ _) = i
    

-- Funcion que recibe una cadena y cuenta su longitud
longitud :: String -> Int
longitud string = longitudAux string 0
  where
    longitudAux [] n = n
    longitudAux (x:xs) n = longitudAux xs (n+1)


--Función que toma una lista de pares que representan repeticiones de caracteres (numeroRepeticiones, caracter)
-- y convierte cada par a una Hoja de Huffman y los devuelve en una lista.

aHojas :: [(Int,Char)] -> [Huffman]
aHojas = map (\(n,c) -> Hoja n c)

-- Algoritmo quicksort para ordenar una lista

quicksort :: Ord a => [a] -> [a]
quicksort []     = []
quicksort (z:xs) = (quicksort menores) ++ [z] ++ (quicksort mayores)
    where
        menores  = [y | y <- xs, y < z]
        mayores = [y | y <- xs, y >= z]
-- Funcion analoga a quicksort que ordena los elementos de una lista de tuplas (Int,Char)
ordenaTuplas :: [(Int, Char)] -> [(Int, Char)]
ordenaTuplas []     = []
ordenaTuplas ((z,q):xs) = (ordenaTuplas menores) ++ [(z,q)] ++ (ordenaTuplas mayores)
    where
        menores  = [(a, b) | (a, b) <- xs, a < z]
        mayores = [(a, b) | (a, b) <- xs, a >= z]

--Función que recibe una lista de pares (Int,Char) con las repeticiones de un alfabeto
--devuelve el árbol de Huffmann correspondiente

huffman :: String -> Huffman
huffman string = huffmanAux (aHojas(ordenaTuplas (repeticiones (string))))
  where
-- Funcion auxiliar que crea el "arbol de huffman" de cualquier lista
    huffmanAux [x] = x
    huffmanAux (x:y:ys) = huffmanAux (ys ++ [unirNodos x y])
-- Funcion que crea un nodo cuyos hijos son otros dos nodos
    unirNodos :: Huffman -> Huffman -> Huffman
    unirNodos x y = Nodo (repeticionesEnHuffman x + repeticionesEnHuffman y) x y

-- Funcion que agrega un caracter a la segunda entrada de una lista
agregarChar :: Char -> [(Char, String)] -> [(Char, String)]
agregarChar char string = [(x, char:y) | (x, y) <- string]

--Funcion que obtiene el alfabeto en codigo Huffman de cada caracter en una lista de tuplas (Char,String)
alfabeto :: Huffman -> [(Char,String)] 
alfabeto (Hoja i x) = [(x,"")]
alfabeto (Nodo j x y) = (agregarChar '0' (alfabeto x)) ++ (agregarChar '1' (alfabeto y))

--Funcion que concatena los codigos de cada elemento (Char, String)
concatenarCodigos :: [(Char, String)] -> String
concatenarCodigos [] = ""
concatenarCodigos ((x, y):ys) = y ++ concatenarCodigos ys


-- Funcion que codifica un string en su codigo Huffman
codifica :: String -> String
codifica x = concatenarCodigos(alfabeto(huffman x)) 

--Función que recibe una cadena de bits (0 y 1), un árbol de Huffman y decodifica la cadena según ese árbol.
decodifica :: String -> Huffman -> String
decodifica bits arbolito = decodificaAux bits arbolito
  where
    decodificaAux :: String -> Huffman -> String
    decodificaAux [] _ = ""  -- Cuando no quedan bits para decodificar, devuelve una cadena vacía
    decodificaAux [z] (Nodo j x (Hoja i char)) = char : decodificaAux [] arbolito -- Cuando hay solo un elemento toma el caracter de la derecha del ultimo nodo
    decodificaAux (bit:resto) (Hoja i char) = char : decodificaAux (bit:resto) arbolito  -- Si llegamos a una hoja, añade el carácter y continúa con el resto de la cadena de bits
    decodificaAux (bit:resto) (Nodo j x y) =
      if bit == '0'
        then decodificaAux resto x  -- Si el bit es '0', vamos hacia la izquierda en el árbol
        else decodificaAux resto y -- Si el bit es '1', vamos hacia la derecha en el árbol 
 
