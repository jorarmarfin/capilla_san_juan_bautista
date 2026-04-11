# Contexto del proyecto - Capilla San Juan Bautista

## 1) Objetivo del proyecto
Aplicación Flutter multiplataforma para la Capilla San Juan Bautista.
Estado actual: **maqueta UX funcional** con navegación por `Drawer` + menú inferior, secciones pastorales y página de créditos.

## 2) Stack técnico
- Framework: Flutter (Material 3)
- Lenguaje: Dart (SDK `^3.11.4`)
- App package: `com.luisitomayta.capilla_san_juan_bautista`
- Dependencias principales:
  - `flutter`
  - `cupertino_icons`
  - `url_launcher: ^6.3.1`
  - `in_app_update: ^4.2.3` — fuerza actualización desde Google Play (solo Android)
  - `flutter_launcher_icons: ^0.14.4` (dev)
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
        home_shell.dart       ← enum AppSection + lógica de navegación + in_app_update
        home_page.dart        ← pantalla de inicio (la más completa)
        widgets/
          app_drawer.dart
    historia/presentation/historia_page.dart
    grupos/presentation/grupos_page.dart
    coordinacion/presentation/coordinacion_page.dart
    calendario/presentation/calendario_page.dart
    fotos/presentation/fotos_page.dart
    congregacion/presentation/congregacion_page.dart
    dimensiones_pastorales/presentation/dimensiones_pastorales_page.dart
    sacramentos/presentation/sacramentos_page.dart  ← página completa con cards expandibles
    evangelio/presentation/evangelio_page.dart      ← página lista, SIN acceso en UI (pendiente API litúrgica)
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

## 5) Tema visual
En `lib/core/theme/app_colors.dart`:
- `primary = #003B5C`
- `secondary = #00ADEF`
- `tertiary = #E78D1B`
- `neutral = #F5F7F8`

En `lib/core/theme/app_theme.dart`:
- Material 3 habilitado
- `AppBar` global con fondo `colorScheme.primary`
- Cards redondeadas y estilo uniforme
- Drawer con bordes redondeados

## 6) Navegación actual

### 6.1 HomeShell (`lib/features/home/presentation/home_shell.dart`)
Controla sección actual mediante `AppSection` y renderiza página según el enum.

**`in_app_update` integrado aquí:** en `initState`, si la plataforma es Android (no web), llama
`InAppUpdate.checkForUpdate()` y si hay actualización disponible ejecuta `performImmediateUpdate()`
(flujo obligatorio de Google Play). Falla silenciosa en emuladores/sideload.

Secciones registradas en `AppSection`:
- `inicio`
- `sacramentos`
- `historia`
- `congregacion`
- `dimensionesPastorales`
- `grupos`
- `coordinacion`
- `calendario`
- `fotos`
- `creditos`

> `evangelio` fue **removido del enum y de la navegación** intencionalmente; la página existe
> y está lista para reconectarse cuando se integre la API litúrgica real.

### 6.2 Drawer (`lib/features/home/presentation/widgets/app_drawer.dart`)
- Header con branding de capilla
- Lista de secciones del `AppSection` (sin Evangelio)
- Item `Créditos` con icono de corazón (`Icons.favorite`)
- Usa `ListView` para evitar overflow en pantallas bajas

### 6.3 Menú inferior
`NavigationBar` con accesos:
- Inicio
- Calendario
- Grupos
- Dimensiones

## 7) Estado de las pantallas

### 7.1 Inicio (`home_page.dart`)
Pantalla más completa. Incluye:
- Foto principal (internet, con `errorBuilder`)
- Oración del día
- Accesos rápidos (Grupos, Fotos, Sacramentos, Calendario, Historia, Dimensiones — sin Evangelio)
- Slider de banners (internet)
- Horarios de misa
- Avisos parroquiales
- Servicios de la capilla
- Redes sociales

### 7.2 Sacramentos (`sacramentos_page.dart`)
Página **completa** (no maqueta). Contiene:
- Header descriptivo
- Card de contacto/solicitud
- 6 sacramentos (Bautismo, Primera Comunión, Confirmación, Matrimonio, Confesión, Unción de Enfermos)
- Cada sacramento es una card expandible con descripción, requisitos y horario de contacto
- `ValueKey('sacramentos_page')`

### 7.3 Evangelio (`evangelio_page.dart`)
Página **completa** (no maqueta), pero **sin acceso desde la UI**. Contiene:
- Cabecera litúrgica con día y tiempo litúrgico
- Texto del evangelio (mock estático — Jn 14, 1-6)
- Reflexión
- Oración final
- Próximas lecturas (3 días)
- Nota: "Las lecturas se actualizarán con la API litúrgica."
- `ValueKey('evangelio_page')`
- **Para reactivar:** agregar `evangelio` al enum `AppSection`, label, `_buildSection()`,
  item en `app_drawer.dart` y acceso rápido en `home_page.dart`.

### 7.4 Secciones de contenido (maqueta)
`historia`, `grupos`, `coordinacion`, `calendario`, `fotos`, `congregacion`, `dimensiones_pastorales`
usan `SectionPlaceholder` para presentar título, descripción, chips de highlights y tarjeta "Maqueta UX".

### 7.5 Créditos (`creditos_page.dart`)
- Bloque visual con icono de corazón
- Desarrollador: Ing. Luis Fernando Mayta Campos / luisitomayta.com
- Stack: Flutter · Dart · Material 3 · arquitectura modular por features

## 8) Android — configuración de paquete
- **applicationId / namespace:** `com.luisitomayta.capilla_san_juan_bautista`
- **MainActivity.kt:** ubicado en
  `android/app/src/main/kotlin/com/luisitomayta/capilla_san_juan_bautista/MainActivity.kt`
  con `package com.luisitomayta.capilla_san_juan_bautista` ← fue corregido (antes decía `com.example...`)
- Signing release configurado vía `key.properties` (no versionado)
- `minSdk` / `targetSdk` / `compileSdk` tomados de `flutter.*` vars

## 9) Testing actual
Archivo: `test/widget_test.dart`

Cobertura principal:
- Render de Home
- Apertura de Drawer
- Navegación a Créditos y validación de contenido
- Navegación a Dimensiones Pastorales y validación de highlights
- Navegación desde menú inferior

Comando base:
```bash
flutter test
```

## 10) Convenciones y decisiones de implementación
- Arquitectura simple por `features` + `core` + `shared`.
- Pantallas en estado maqueta salvo Inicio, Sacramentos y Evangelio (estas tres son completas).
- Textos en español.
- Compatibilidad con tests de widget y sin dependencias extra.
- `ValueKey` en cada página raíz para estabilidad de pruebas y `AnimatedSwitcher`.
- Imágenes de internet siempre con `errorBuilder`.

## 11) Pendientes recomendados
1. Reactivar Evangelio cuando esté lista la API litúrgica (ver sección 7.3 para pasos exactos).
2. Hacer clickeable `luisitomayta.com` con `url_launcher` (ya está en dependencias).
3. Extraer data mock a modelos/listas separadas para facilitar paso a backend.
4. Agregar tests dedicados por pantalla (especialmente Sacramentos).
5. Registrar assets locales (logo/fotos reales de la capilla).
6. `in_app_update` solo actúa con APKs distribuidas por Google Play; en debug/emulador no muestra diálogo.

## 12) Guía rápida para agregar una nueva sección
1. Crear página en `lib/features/<seccion>/presentation/...`
2. Agregar valor en enum `AppSection` en `home_shell.dart`
3. Agregar label en extensión `AppSectionX`
4. Agregar caso en `_buildSection()`
5. Agregar item en `app_drawer.dart`
6. Si aplica, mapear en `NavigationBar` inferior
7. Extender `test/widget_test.dart`
8. Ejecutar `flutter test`

### Si tocas Home:
- Mantener `ValueKey('inicio_page')` para estabilidad de pruebas
- Conservar manejo de fallos de red en imágenes (`errorBuilder`)

---
Última actualización: 2026-04-02
