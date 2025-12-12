# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3] - 2025-12-12

### Added

- `PragmaAccordionWidget`, un acordeón con gestión interna del estado, compatibilidad con `IconData`, tamaños "block"/"default" y soporte de `Semantics`.
- Documentación `dartdoc` con ejemplo listo para copiar/pegar y export público en `pragma_design_system.dart`.
- `PragmaBorderRadiusTokens` y helpers `PragmaBorderRadius` para estandarizar los radios descritos en el spec.
- Pruebas widget para el acordeón y caso unitario que asegura los nuevos tokens.
- Actualización del `example/` mostrando acordiones activos y deshabilitados junto con la guía de componentes en README.
- Tokens de opacidad (`PragmaOpacityTokens`, `PragmaOpacity`) con documentación dedicada y migración del paquete a `Color.withValues` en todos los overlays.
- Nueva guía `doc/opacidad.md`, README enlazado y gradientes/control de estados migrados en `example/` y widgets para consumir los tokens de transparencia oficiales.

## [0.0.2] - 2025-12-11

### Added

- Tokens y utilitarios responsivos de grilla (`PragmaGridTokens`, `PragmaViewportEnum`, `getGridConfigFromWidth`/`Context`) con pruebas unitarias para validar los cálculos por breakpoint.
- `PragmaGridContainer`, un contenedor de depuración que pinta columnas, gutters y márgenes; incluye badge informativo con métricas del viewport.
- Página “Grid debugger” dentro del `example/` que muestra el overlay en vivo y expone casos de uso para distintos tamaños de pantalla.
- Documento en `doc/` con instrucciones para adoptar los utilitarios y el `PragmaGridContainer` en implementaciones de producto.
- `PragmaScaleBox`, widget para escalar composiciones fijas dentro del viewport con demo navegable desde la página Grid Debugger del `example/`.

## [0.0.1] - 2025-12-11

### Added

- Archivo de referencia con todos los tokens cromáticos oficiales y esquemas Material 3 claro/oscuro construidos desde ellos.
- Componentes iniciales (`PragmaButton`, `PragmaCard`, `PragmaIconButton`) más utilidades de `PragmaButtons`.
- App de ejemplo en `example/` que muestra tokens, tema y componentes, junto con prueba unitaria base.
- Tipografía Poppins completa con tokens (`PragmaTypographyTokens`) y `TextTheme` alineado al spec.
- Sistema de espaciados oficial con tokens reutilizables y helpers para `EdgeInsets`.
- Documentación sobre la licencia de Poppins y pasos para incluir un fallback offline, además del archivo `licenses/Poppins-OFL.txt`.
- Ejemplo con fuentes Poppins locales, `GoogleFonts` deshabilitado en tiempo de ejecución y fallback en `PragmaTypography` para respetar los assets registrados.

```

```
