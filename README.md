# Elementals

Juego 2D tipo puzzle-acción desarrollado en Godot utilizando GDScript.

Actualmente el juego ya cuenta con un prototipo funcional completamente jugable.

---

# Tecnologías

- Motor: Godot
- Lenguaje: GDScript

---

# Estado actual del proyecto

- Movimiento completo del jugador.
- Sistema de grilla.
- Sistema de bloques dinámicos.
- Múltiples enemigos.
- Diferentes comportamientos de enemigos.
- Sistema de objetivos.
- Game Over.
- Progresión entre niveles.

---

# Sistema de movimiento

El movimiento del jugador fue desarrollado utilizando un sistema basado en celdas de 32x32 píxeles.
Para mejorar la sensación del movimiento se implementó:

- Movimiento continuo al mantener una tecla presionada.
- Cambio de dirección sin movimiento inmediato.
- Delay de entrada (`hold_delay`) para evitar cambios bruscos de dirección.
- Sistema de `move_toward()` para suavizar el desplazamiento entre celdas.

Correciones que se hicieron:

- Desalineación entre posiciones.
- Movimiento demasiado rápido al mantener teclas.
- Problemas al cambiar de dirección mientras el personaje aún se desplazaba.

---

# Sistema de bloques

Se implementó un sistema que permite crear y destruir bloques dinámicamente utilizando la tecla SPACE.
El bloque aparece siempre en la celda siguiente respecto a la última dirección del jugador.
Inicialmente hubo problemas donde algunos bloques podían destruirse y otros no, 
Esto fue corregido utilizando posiciones alineadas al grid y grupos de nodos.
Los bloques fueron agregados al grupo:`blocks`

---

# Sistema de enemigos

## Enemy normal
- Movimiento aleatorio cuando el jugador está lejos.
- Persecución del jugador cuando entra dentro de cierto rango.
- Sistema de Game Over al entrar en contacto con el jugador.

## Enemy destroy

Se implementó un segundo tipo de enemigo con comportamiento distinto.

Características:
- Color amarillo
- Capacidad de destruir bloques creados por el jugador.
---

# Correcciones en IA y colisiones

Uno de los principales problemas encontrados fue que los enemigos podían quedarse congelados al intentar ocupar la misma celda.
se implementó un sistema de:
- Reservación de celdas (`reserved_cells`).

Tambi
Los enemigos fueron organizados mediante el grupo:
"enemies"

---

# Sistema de objetivos

Cada Goal fue implementado usando:
- `Area2D`
- `CollisionShape2D`
- `Polygon2D`

Los goals fueron organizados usando el grupo:
- `goals`

---

# Sistema de niveles

Actualmente existen tres niveles:

- `game.tscn`
- `game_level2.tscn`
- `game_level3.tscn`

Cada nivel aumenta progresivamente la dificultad.

## Nivel 1

- Un enemigo básico.
- Goals coleccionables.

## Nivel 2

- Mayor cantidad de enemigos.

## Nivel 3

- Introducción del enemigo destroy.

---

# Sistema de progresión

- al recolectar todos los Goals de un nivel,
- el jugador avanza automáticamente al siguiente escenario.

También se añadieron controles manuales para pruebas:
- Tecla 1 → Nivel 1
- Tecla 2 → Nivel 2
- Tecla 3 → Nivel 3

---

# Sistema de Game Over

Se añadió una interfaz básica utilizando:
- `CanvasLayer`
- `Label`

Cuando un enemigo alcanza al jugador:

- aparece el mensaje de Game Over.
- el juego se pausa automáticamente.

Durante el desarrollo surgieron errores relacionados con pausas persistentes entre escenas y congelamientos al cambiar niveles, los cuales fueron corregidos ajustando el manejo de:
get_tree().paused

---

# Controles

## Movimiento

- Flechas direccionales

## Crear / destruir bloques

- SPACE

---

# Estado actual

El proyecto ya cuenta con:

- Movimiento funcional.
- Sistema de grilla estable.
- Colisiones funcionales.
- Creación y destrucción de bloques.
- Enemigos funcionales.
- Diferentes comportamientos de enemigos.
- Objetivos coleccionables.
- Progresión entre niveles.
