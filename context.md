# Contexto del proyecto - Capilla San Juan Bautista

## 1) Objetivo del proyecto
Aplicacion Flutter multiplataforma para la Capilla San Juan Bautista.
El estado actual es una **maqueta UX funcional** con navegacion por `Drawer` + menu inferior, secciones pastorales y pagina de creditos.

## 2) Stack tecnico
- Framework: Flutter (Material 3)
- Lenguaje: Dart (SDK `^3.11.4`)
- App package: `capilla_san_juan_bautista`
- Dependencias principales:
  - `flutter`
  - `cupertino_icons`
- Testing:
  - `flutter_test`
  - `flutter_lints`

## 3) Estructura relevante
```text
lib/
  main.dart
  app.dart
  core/
    theme/
      app_colors.dart
      app_theme.dart
  features/
    home/
      presentation/
        home_shell.dart
        home_page.dart
        widgets/
          app_drawer.dart
    historia/presentation/historia_page.dart
    grupos/presentation/grupos_page.dart
    coordinacion/presentation/coordinacion_page.dart
    calendario/presentation/calendario_page.dart
    fotos/presentation/fotos_page.dart
    congregacion/presentation/congregacion_page.dart
    dimensiones_pastorales/presentation/dimensiones_pastorales_page.dart
    creditos/presentation/creditos_page.dart
  shared/
    widgets/
      section_placeholder.dart

test/
  widget_test.dart
```

## 4) Punto de entrada y bootstrap
- `lib/main.dart` ejecuta `CapillaApp`.
- `lib/app.dart` configura `MaterialApp` con:
  - `title: Capilla San Juan Bautista`
  - `theme: AppTheme.light`
  - `home: HomeShell`

## 5) Tema visual (decision clave)
En `lib/core/theme/app_colors.dart` se aplico la decision de permutar colores:
- `primary = #003B5C` (antes secundario visual del diseno)
- `secondary = #00ADEF`
- `tertiary = #E78D1B`
- `neutral = #F5F7F8`

En `lib/core/theme/app_theme.dart`:
- Material 3 habilitado
- `AppBar` global con fondo `colorScheme.primary`
- Cards redondeadas y estilo uniforme
- Drawer con bordes redondeados

## 6) Navegacion actual
### 6.1 HomeShell (`lib/features/home/presentation/home_shell.dart`)
Controla seccion actual mediante `AppSection` y renderiza pagina segun el enum.

Secciones registradas:
- Inicio
- Historia
- Congregacion Religiosa
- Dimensiones Pastorales
- Grupos
- Coordinacion
- Calendario
- Fotos
- Creditos

### 6.2 Drawer (`lib/features/home/presentation/widgets/app_drawer.dart`)
- Header con branding de capilla
- Lista de secciones del `AppSection`
- Incluye item `Creditos` con icono de corazon (`Icons.favorite`)
- Usa `ListView` para evitar overflow en pantallas bajas

### 6.3 Menu inferior
`NavigationBar` con accesos:
- Inicio
- Calendario
- Grupos
- Dimensiones

## 7) Estado de las pantallas
## 7.1 Inicio (`home_page.dart`)
Pantalla mas completa de maqueta, incluye:
- Foto principal (internet)
- Oracion del dia
- Accesos rapidos
- Slider de banners (internet)
- Horarios de misa
- Avisos parroquiales
- Servicios de la capilla
- Redes sociales

Notas tecnicas:
- Las imagenes de internet usan `errorBuilder` para no romper tests/widget rendering en entorno sin red.

## 7.2 Secciones de contenido (maqueta)
`historia`, `grupos`, `coordinacion`, `calendario`, `fotos`, `congregacion`, `dimensiones_pastorales` usan `SectionPlaceholder` para presentar:
- Titulo
- Descripcion
- Chips de highlights
- Tarjeta de confirmacion "Maqueta UX"

## 7.3 Creditos (`creditos_page.dart`)
Pagina independiente con:
- Bloque visual con icono de corazon
- Datos del desarrollador:
  - Ing. Software
  - Luis Fernando Mayta Campos
  - luisitomayta.com
- Bloque de tecnologia:
  - Flutter
  - Dart
  - Material 3 + arquitectura modular por features

## 8) Testing actual
Archivo: `test/widget_test.dart`

Cobertura principal:
- Render de Home
- Apertura de Drawer
- Navegacion a Creditos y validacion de contenido
- Navegacion a Dimensiones Pastorales y validacion de highlights
- Navegacion desde menu inferior

Comando base:
```bash
flutter test
```

## 9) Convenciones y decisiones de implementacion
- Arquitectura simple por `features` + `core` + `shared`.
- Pantallas en estado maqueta (sin backend).
- Textos mayormente en espanol.
- Se mantuvo compatibilidad con tests de widget y sin dependencias extra.

## 10) Pendientes recomendados (siguiente iteracion)
1. Unificar ortografia/acentos en labels UI (por ejemplo: Coordinacion/Coordinacion, Creditos/Creditos segun criterio final).
2. Hacer clickeable `luisitomayta.com` con `url_launcher`.
3. Extraer data mock a modelos/listas separadas para facilitar paso a backend.
4. Agregar tests dedicados por pantalla (no solo smoke test unico).
5. Registrar assets locales (logo/fotos reales de la capilla) para no depender de imagenes remotas.

## 11) Guia rapida para agentes que continen el proyecto
### Si agregas una nueva seccion:
1. Crear pagina en `lib/features/<seccion>/presentation/...`.
2. Registrar en `AppSection` de `home_shell.dart`.
3. Agregar label en extension `AppSectionX`.
4. Agregar caso en `_buildSection()`.
5. Incluir item en `app_drawer.dart`.
6. Si aplica, mapear en `NavigationBar` inferior.
7. Extender `test/widget_test.dart`.
8. Ejecutar `flutter test`.

### Si tocas Home:
- Mantener `ValueKey('inicio_page')` para estabilidad de pruebas.
- Conservar manejo de fallos de red en imagenes (`errorBuilder`).

---
Ultima actualizacion de este contexto: 2026-04-01.



