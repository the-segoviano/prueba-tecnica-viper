# Prueba Técnica - Perfil de Usuario con Gráficas

Este proyecto es una aplicación iOS nativa desarrollada en Swift que demuestra una arquitectura limpia  basada en VIPER, la integración con servicios de backend como Firebase y la visualización de datos locales mediante SwiftUI Charts en un entorno de UIKit.

## Características Principales

*   **Creación de Perfil de Usuario:** Permite al usuario introducir un nombre y seleccionar una imagen de avatar.
*   **Persistencia en la Nube:** Guarda y recupera la información del perfil utilizando **Firebase Firestore**.
*   **Visualización de Datos:** Lee un archivo `test.json` local y renderiza múltiples gráficas de pastel utilizando el framework **SwiftUI Charts** integrado en una vista de UIKit.
*   **Actualización de UI en Tiempo Real:** Utiliza **Firebase Realtime Database** para escuchar cambios de color y actualizar dinámicamente el fondo de la aplicación.
*   **Arquitectura Limpia:** Implementa la arquitectura **VIPER** para una máxima separación de responsabilidades, mantenibilidad y testeabilidad.
*   **Suite de Pruebas Unitarias:** Incluye un conjunto de pruebas unitarias con **XCTest** que validan la lógica de negocio y de presentación.

## Stack Tecnológico

*   **Lenguaje:** Swift
*   **Framework UI:** UIKit (con integración de SwiftUI para gráficas)
*   **Base de Datos:**
    *   **Firestore:** Para persistencia de datos de perfiles.
    *   **Realtime Database:** Para la funcionalidad de cambio de color en tiempo real.
*   **Arquitectura:** **VIPER** (View, Interactor, Presenter, Entity, Router)
*   **Framework de Pruebas:** XCTest
*   iOS mínimo **17**: Debido a la compatibilidad que requiere **SwiftUI** para el uso del Framework **Charts**

## Estructura del Proyecto

El código fuente está organizado siguiendo los principios de la arquitectura VIPER, separando cada funcionalidad principal en su propio "Módulo".

```
prueba-tecnica-viper/
│
├─── Modules/
│    │
│    ├─── Profile/
│    │    ├─── View/           (ViewController, Celdas de la tabla, etc.)
│    │    ├─── Interactor/     (Lógica de negocio, llamadas a Firebase)
│    │    ├─── Presenter/      (Lógica de presentación, formato de datos)
│    │    ├─── Entity/         (Structs de modelo de datos, ej: Profile)
│    │    └─── Router/         (Navegación y ensamblaje del módulo)
│    │
│    └─── ChartsDetail/
│         ├─── View/           (GraphDetailViewController, PieChartView)
│         ├─── Interactor/     (Lógica de carga del JSON)
│         ├─── Presenter/      (Lógica de presentación de las gráficas)
│         ├─── Entity/         (Structs para los datos del JSON)
│         └─── Router/         (Ensamblaje del módulo)
│
├─── Resources/
│    ├─── BaseViews/          (Componentes de UI reutilizables)
│    ├─── Extensions/         (Extensiones de clases de Foundation/UIKit)
│    └─── Utils/              (Helpers, Constantes, etc.)
│
├─── AppDelegates/             (AppDelegate, SceneDelegate)
│
└─── prueba_tecnica_viperTests/  (Carpeta con todas las pruebas unitarias)
```

## Recomendaciones

### Imágenes de Prueba

*   **Límite de Tamaño:** Firestore tiene un límite de 1MB por documento. El Interactor del módulo `Profile` implementa una validación que impide guardar imágenes que superen este tamaño. Se recomienda usar imágenes de prueba **inferiores a 1MB**.
*   **Formato:** La aplicación utiliza `UIImage` y convierte la imagen a `jpegData`. Se recomienda usar formatos estándar como **JPEG** o **PNG**.

### Ejecución de Pruebas

*   El proyecto incluye una suite de pruebas unitarias que se puede ejecutar desde Xcode usando el atajo **Cmd+U**.
*   Las pruebas están diseñadas para ser completamente independientes y no requieren conexión a internet, ya que simulan ("mockean") las dependencias externas como la Vista, el Router y los servicios de red.

### Adopción de la Arquitectura VIPER

*   **Nuevas Funcionalidades:** Para añadir una nueva pantalla, se recomienda crear un nuevo Módulo dentro de la carpeta `Modules/`, siguiendo la estructura de carpetas y componentes existente.
*   **Flujo de Datos:** Respetar el flujo de comunicación unidireccional (`View -> Presenter -> Interactor` y `Interactor -> Presenter -> View`) es clave para mantener el código desacoplado.
*   **Responsabilidad Única:** Cada componente tiene un propósito claro. Evitar añadir lógica de negocio en la Vista o lógica de UI en el Interactor.
