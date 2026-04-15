# English Verbs App — Guía Completa de Instalación y Uso

## ÍNDICE
1. Estructura del proyecto
2. Instalación de Flutter
3. Instalación de Android Studio
4. Configurar tu celular Android
5. Crear el proyecto y copiar el código
6. Correr la app en tu celular
7. Compilar el APK para instalar sin cable
8. Descripción de cada archivo
9. Comandos de referencia rápida

---

## 1. ESTRUCTURA DEL PROYECTO

```
english_verbs/
├── pubspec.yaml                    ← dependencias del proyecto
└── lib/
    ├── main.dart                   ← punto de entrada + navegación
    ├── models/
    │   └── verb.dart               ← clase Verb (estructura de datos)
    ├── database/
    │   └── database_helper.dart    ← SQLite: crear, leer, guardar verbos
    ├── providers/
    │   └── verb_provider.dart      ← manejo de estado (lista, búsqueda)
    ├── theme/
    │   └── app_theme.dart          ← colores, tipografía, estilos globales
    ├── screens/
    │   ├── verb_list_screen.dart   ← pantalla principal con lista
    │   ├── verb_detail_screen.dart ← detalle de un verbo
    │   ├── practice_screen.dart    ← modo práctica / flashcards
    │   └── stats_screen.dart       ← estadísticas
    └── widgets/
        ├── verb_card.dart          ← tarjeta de verbo en la lista
        └── verb_form_sheet.dart    ← formulario agregar/editar
```

---

## 2. INSTALACIÓN DE FLUTTER

### En Windows:

1. Ve a https://flutter.dev/docs/get-started/install/windows
2. Descarga el archivo .zip de Flutter SDK
3. Extrae en C:\flutter  (NO en C:\Program Files, sin espacios en la ruta)
4. Agrega C:\flutter\bin al PATH:
   - Busca "Variables de entorno" en el buscador de Windows
   - En "Variables del sistema" → Path → Editar → Nuevo → C:\flutter\bin
5. Abre una nueva terminal (cmd o PowerShell) y ejecuta:
   flutter doctor

### En Mac:

1. Instala Homebrew si no lo tienes: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
2. En terminal:
   brew install flutter
3. Verifica:
   flutter doctor

Flutter doctor te dirá qué falta instalar. Sigue sus instrucciones.

---

## 3. INSTALACIÓN DE ANDROID STUDIO

1. Descarga en https://developer.android.com/studio
2. Instala normalmente
3. Al abrirlo por primera vez, completa el "Setup Wizard" → instala Android SDK
4. En Android Studio: Tools → SDK Manager → SDK Tools → marca "Android SDK Command-line Tools" → Apply

Luego en terminal ejecuta:
   flutter doctor --android-licenses
   (acepta todas las licencias escribiendo 'y')

---

## 4. CONFIGURAR TU CELULAR ANDROID

### Activar opciones de desarrollador:
1. Ve a Configuración → Acerca del teléfono
2. Toca 7 veces sobre "Número de compilación" hasta ver "Eres desarrollador"
3. Ve a Configuración → Sistema → Opciones de desarrollador
4. Activa "Depuración USB"

### Conectar al PC:
1. Conecta tu celular con cable USB
2. En tu celular aparecerá un diálogo "¿Permitir depuración USB?" → toca "Permitir"
3. En terminal escribe: flutter devices
   Debe aparecer tu celular en la lista

### Paso 5: Instalar dependencias
   flutter pub get

---

## 6. CORRER LA APP EN TU CELULAR

Con el celular conectado por USB:

   flutter run

La primera vez tarda 2-3 minutos en compilar. Las siguientes veces es mucho más rápido.

Si tienes varios dispositivos conectados, usa:
   flutter run -d <device-id>
   (el device-id lo ves con "flutter devices")

### Durante el desarrollo (hot reload):
- Presiona R en la terminal para recargar cambios instantáneamente
- Presiona Shift+R para reiniciar completamente
- Presiona Q para salir

---

## 7. COMPILAR EL APK PARA INSTALAR SIN CABLE

Para tener la app instalada permanentemente en tu celular:

   flutter build apk --release

El archivo APK quedará en:
   build/app/outputs/flutter-apk/app-release.apk

Copia ese archivo a tu celular (por USB, WhatsApp, Google Drive, etc.) y ábrelo para instalarlo.

IMPORTANTE: En tu celular debes activar "Instalar apps de fuentes desconocidas":
   Configuración → Seguridad → Instalar apps desconocidas

---

## 8. DESCRIPCIÓN DE CADA ARCHIVO

### main.dart
Punto de entrada de la app. Configura el Provider (manejo de estado), el tema visual, y la navegación inferior con tres pestañas.

### models/verb.dart
Define la clase Verb con todos sus campos: baseForm, pastSimple, pastParticiple, meaning, example, notes, isFavorite, isIrregular, createdAt. Incluye métodos toMap() y fromMap() para guardar/leer de SQLite.

### database/database_helper.dart
Maneja la base de datos SQLite local. Crea la tabla al instalar la app, y viene pre-cargada con 20 verbos irregulares comunes. Métodos: insertVerb, updateVerb, deleteVerb, getAllVerbs, searchVerbs, getFavorites, toggleFavorite.

### providers/verb_provider.dart
Maneja el estado de la lista de verbos. Se encarga de cargar, filtrar por búsqueda, ordenar, y notificar a las pantallas cuando algo cambia.

### theme/app_theme.dart
Define todos los colores de la app, tipografía (DM Sans de Google Fonts), y estilos de componentes (tarjetas, inputs, botones, etc.).

### screens/verb_list_screen.dart
Pantalla principal. Muestra la lista de verbos con búsqueda en tiempo real, chips de ordenamiento (A-Z, Reciente, Favoritos), y botón flotante para agregar. Deslizar una tarjeta revela opciones de editar y eliminar.

### screens/verb_detail_screen.dart
Muestra todos los detalles de un verbo: las tres formas, significado, ejemplo y notas. Permite editar o marcar como favorito.

### screens/practice_screen.dart
Modo práctica con 10 verbos aleatorios. Muestra el verbo base y pide escribir el pasado simple y participio pasado. Al terminar muestra el porcentaje de aciertos.

### screens/stats_screen.dart
Estadísticas: total de verbos, favoritos, regulares vs irregulares, y lista de los últimos agregados.

### widgets/verb_card.dart
Tarjeta individual en la lista. Muestra el verbo base, las pills de pasado y participio, el significado, y el ícono de favorito. Con gesto deslizar muestra editar/eliminar.

### widgets/verb_form_sheet.dart
Formulario que aparece desde abajo para agregar o editar un verbo. Valida que los campos obligatorios estén llenos.

---

Desarrollado con Flutter · SQLite · Provider · Google Fonts (DM Sans)
