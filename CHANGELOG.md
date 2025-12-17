# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.6] - 2025-12-17

### Added

- `PragmaPaginationWidget`, componente de paginación con cápsula glow, flechas numeradas, summary accesible y dropdown de "por página" listo para tablas extensas.
- Showcase `_PaginationShowcase` con slider de registros, alternancia light/dark y vista previa integrada a badges.
- Guía `doc/pagination.md` más snippet/feature en README para documentar anatomía y patrones del componente.

### Changed

- README y catálogo documentado actualizados para listar el nuevo componente y sincronizar la dependencia `^1.2.6`.

## [1.2.5] - 2025-12-17

### Added

- `PragmaFilterWidget`, filtro mejorado con overlay multi-select, helper text, contador y resumen de tags activos.
- Showcase `_FilterShowcase` enlazado a una tabla real para alternar tono, helper text, tags y estados enabled.
- Guía `doc/filter.md` más snippet/feature en README para documentar anatomía y patrones.

### Changed

- README y ejemplo sincronizados para resaltar el nuevo widget, incluyendo la entrada en el catálogo documentado.

## [1.2.4] - 2025-12-17

### Added

- `PragmaBadgeWidget`, cápsula informativa con tonos brand/success/warning/info/neutral, soporte light/dark, modo denso e ícono opcional para etiquetar estados.
- Showcase `_BadgeShowcase` en la app de ejemplo que permite alternar tono, brillo, densidad, íconos y textos personalizados junto a un catálogo listo para copiar.
- Guía `doc/badge.md` y snippet en el README documentando anatomía, estados y buenas prácticas para integrar badges.

### Changed

- `pubspec.yaml`, README y exports sincronizados para publicar la versión `1.2.4` con el nuevo componente.

## [1.2.3] - 2025-12-17

### Added

- `PragmaCheckboxWidget`, checkbox con bordes de 2dp, glow morado, modo denso, soporte para estados indeterminados y etiquetado accesible.
- Showcase `_CheckboxShowcase` en la app de ejemplo para combinar "Seleccionar todos", densidades y estados disabled.
- Guía `doc/checkbox.md` y snippet en el README que documentan anatomía, estados y patrones de selección múltiple.

### Changed

- Biblioteca pública y README actualizados para exponer `PragmaCheckboxWidget`, además de bump general a la versión `1.2.3` para su publicación.

## [1.2.2] - 2025-12-17

### Added

- `PragmaRadioButtonWidget`, control circular con glow morado, soporte para descripciones, modo denso y estados hover/pressed/disabled.
- Showcase `_RadioButtonShowcase` en la app de ejemplo que alterna densidad, helper text y la selección actual.
- Guía `doc/radio_button.md` y snippet en el README para acelerar la implementación en formularios.

### Changed

- Biblioteca pública actualizada para exportar el nuevo widget y versión del paquete incrementada a `1.2.2` para su publicación.

## [1.2.1] - 2025-12-17

### Added

- `PragmaTagWidget`, cápsula con gradiente morado, avatar opcional y botón de cerrado accesible que replica los estados active/hover/pressed/disabled del spec.
- Showcase `_TagShowcase` en la app de ejemplo para alternar avatar, remove y disabled, más la guía dedicada `doc/tags.md` y snippet en el README.

### Changed

- Biblioteca pública actualizada para exportar `PragmaTagWidget` y habilitar el uso directo desde `pragma_design_system.dart`.
- Versión del paquete adelantada a `1.2.1` para publicar la nueva funcionalidad en pub.dev.

## [1.2.0] - 2025-12-17

### Added

- `PragmaTextAreaWidget`, un campo multi-línea con label superior, estados helper/error/success, contador opcional y degradado morado que replica el spec. Incluye guía dedicada (`doc/textarea.md`), snippet en el README y un showcase dentro de la app de ejemplo.
- Nuevos controles en `_TextAreaShowcase` para validar disabled, contadores, densidades y mensajes de validación directamente en `example/lib/main.dart`.

### Changed

- `PragmaSearchWidget` recibió un refresh visual: hover glow más notorio, gradiente dinámico, ranuras `leading`/`trailing`, etiquetas de accesibilidad y manejo robusto de controladores/focus nodes para integrarlo en flujos complejos.
- README y exports sincronizados para exponer el nuevo widget desde `pragma_design_system.dart`, además de alinear la versión publicada (`1.2.0`).

## [1.1.5] - 2025-12-17

### Added

- `PragmaTextAreaWidget`, un campo multi-línea con label superior, focos con glow, estados error/success y contador opcional, alineado al spec de text area.
- Showcase `_TextAreaShowcase` en la app de ejemplo con controles para disabled, error, success, contador y densidades.
- Guía `doc/textarea.md` y snippet en el README para documentar anatomía, estados y uso.

### Changed

- Biblioteca pública y README actualizados para exportar y referenciar `PragmaTextAreaWidget` dentro de la versión `1.1.5`.

## [1.1.4] - 2025-12-17

### Added

- `PragmaSearchWidget`, un campo de busqueda con glow morado, tonos light/dark, tamanos small/large, texto informativo y acciones personalizadas que replica la variante mobile del spec.
- Playground en la app de ejemplo (_SearchShowcase_) que alterna tamano, tono, disabled, texto informativo y muestra un panel de sugerencias tipo dropdown.
- Guia dedicada en `doc/search.md` con anatomia, estados e integracion con dropdown list.

### Changed

- README actualizado con el snippet de `PragmaSearchWidget`, referencia a la guia y seccion de features sincronizada con la version `1.1.4`.

## [1.1.3] - 2025-12-17

### Added

- `PragmaTableWidget`, una tabla responsiva que acepta cualquier widget por celda, alterna tonos claros/oscuros y replica los estados hover/selected del sistema.
- Playground en la app de ejemplo con toggles para tono, densidad y simulación de hover, más selección de filas.
- Guía `doc/tables.md` que detalla anatomía, componentes compatibles y casos de uso.

### Changed

- Versión del paquete actualizada a `1.1.3` y referencias en el README alineadas con el nuevo componente.

## [1.1.2] - 2025-12-17

### Added

- `PragmaStepperWidget`, un componente horizontal que combina estados success/current/fail, conectores con glow y tamaños `big`/`small` para narrar flujos multi-paso.
- Playground en la app de ejemplo con controles para alternar el tamaño y simular un fallo en el último paso, validando estilos compactos y extendidos.

### Changed

- Versión del paquete actualizada a `1.1.2` y referencias internas sincronizadas con el nuevo componente.

## [1.1.1] - 2025-12-17

### Added

- `PragmaLoadingWidget`, un indicador determinístico con modos circular y lineal que aplica degradados morados y resplandor neón configurable.
- Playground en la app de ejemplo que conecta slider + switch para validar el relleno y las etiquetas en tiempo real.
- Documentación en `doc/loading.md` y snippet en el README para acelerar la adopción del componente.

### Changed

- Versión del paquete actualizada a `1.1.1` y referencias de instalación sincronizadas.

## [1.1.0] - 2025-12-17

### Added

- `PragmaCalendarWidget`, un calendario con selección única o por rangos, navegación por mes/año/década, límites configurables y resumen accesible alineado con los tokens del sistema.
- Demo dedicada en la app de ejemplo (`CalendarDemoPage`) con atajos, límites dinámicos y copiado de rangos para validar el componente visualmente.
- Documentación detallada en `doc/calendar.md` que cubre enfoque, casos de uso y patrones de implementación para consumidores del design system.

## [1.0.2] - 2025-12-17

### Fixed

- Resolved the static-analysis warning pointing to the wildcard callback in `PragmaToastService.contains`. The helper now uses a typed variable (`(_ActiveToast value) => value.id == id`), keeping the toast handle API the same while silencing the lints flagged during publishing.

## [1.0.1] - 2025-12-17

### Changed

- Bumped the published version to `1.0.1` and registered the package under the `pragma.co` publisher on pub.dev so it inherits the organization’s ownership and verification badge.

## [1.0.0] - 2025-12-17

### Added

- Documentation drop for the 1.0.0 release: `doc/logo.md` compiles all official asset variants, usage rules, and `PragmaLogoWidget` guidance, while `doc/fonts.md` captures typography expectations, licensing, and offline bundling steps.
- Rounded-corner guide (`doc/rounded_corners.md`) detailing each border-radius token, design references, and implementation shortcuts through `PragmaBorderRadius`.
- README updated with the new references plus refreshed dependency instructions pointing to the stable 1.0.0 tag.

## [0.1.7] - 2025-12-16

### Added

- `PragmaLogoWidget`, a projector-style logo renderer powered by `PragmaScaleBox` that automatically selects the light/dark asset, scales from a configurable width, and keeps margins proportional to each variant.
- Logo assets registered in `pubspec.yaml`, README quick samples, unit/widget tests, and an example showcase block at the top of the main screen.

## [0.1.6] - 2025-12-15

### Added

- `ModelColorToken`, an immutable model with JSON helpers plus unit tests that guarantee the roundtrip of label and hexadecimal values.
- `PragmaColorTokenRowWidget`, a row-based editor that previews the color on both sides, exposes a sanitized hex input, and is showcased inside the example app together with README docs.
- `ModelThemePragma`, `PragmaThemeBuilder`, and `PragmaThemeEditorWidget`, which allow squads to craft custom themes, preview them with live components, export JSON, and explore everything inside the new Theme Lab screen on the example app.

## [0.1.5] - 2025-12-15

### Fixed

- `PragmaDropdownListWidget` now wraps the remove-action icon with `Semantics` instead of a tooltip overlay, eliminating the `RenderFollower` crash that occurred when hovering the remove button while keeping the action accessible. Full Flutter widget tests were rerun successfully to guard against regressions.

## [0.1.4] - 2025-12-15

### Added

- `PragmaToastWidget` plus the global `PragmaToastService`, delivering animated neon toasts with success/error/alert/info palettes, top alignments, optional action buttons, and manual dismissal handles.
- Toast playground in the example app together with README documentation and a quick sample to help squads adopt the service quickly.

## [0.1.3] - 2025-12-15

### Added

- `ModelFieldState`, an immutable value object with JSON helpers to keep field values, validation flags, and autocomplete suggestions in sync across widgets.
- `PragmaInputWidget` plus the `PragmaInputController`, a ValueNotifier-driven text field with Pragma variants, density presets, password toggle, and an overlay that filters suggestions in real time.
- Example playground, README quick sample, and widget tests that validate controller synchronization, error rendering, suggestion selection, and the obscure-text toggle.

## [0.1.2] - 2025-12-15

### Added

- `PragmaIconButtonWidget`, a spec-driven icon button with filled/outlined variants, light/dark tones, and regular/compact sizes plus hover/pressed/disabled states.
- Example playground and README quick sample that showcase the new widget while encouraging migration away from the legacy `PragmaIconButton` (now deprecated).
- Widget tests that validate palette resolution, disabled styling, and tap callbacks for the new component.

## [0.1.1] - 2025-12-15

### Added

- `PragmaDropdownListWidget`, a multi-select dropdown that mirrors the tone-on-tone overlay from `PragmaDropdownWidget` while adding checkboxes, optional icons, removable rows, and custom option builders.
- Shared `PragmaDropdownOption` file plus a new dropdown-list showcase, README section, and widget tests that validate selection callbacks and removal gestures.

## [0.1.0] - 2025-12-15

### Added

- `PragmaDropdownWidget` and `PragmaDropdownOption` to present themed dropdowns with helper text, error states, icons per option, and tone-aware menu surfaces driven by the active `ColorScheme`.
- Dropdown showcase in the example app plus reusable option data to demonstrate helper/error/disabled scenarios.
- README quick sample, public exports, and widget tests that validate rendering, callbacks, and error decorations.

## [0.0.9] - 2025-12-15

### Added

- `PragmaCardWidget`, a themable card surface with tonal, outlined, and elevated variants plus media/header/supporting actions that default to the active `ColorScheme`.
- `PragmaCardVariant` and `PragmaCardSize` helpers, along with widget tests that lock the color and padding behaviors.
- Showcase and README snippets covering the new widget so teams can adopt it quickly.

## [0.0.8] - 2025-12-12

### Changed

- Rebuilt `PragmaButton` with primary/secondary/tertiary hierarchies, brand/inverse tones, and medium/small sizes driven by the active `ColorScheme`.
- Introduced helper classes (`PragmaPrimaryButton`, `PragmaSecondaryButton`, `PragmaTertiaryButton`) plus enhanced `PragmaButton.icon` for icon-only scenarios.
- Updated the example showcase, README quick samples, and added `pragma_button_test.dart` to cover the new behaviors.

## [0.0.7] - 2025-12-12

### Added

- `PragmaBreadcrumbWidget`, including underline and standard variants driven by the theme plus tooltip/semantics support.
- Example showcase with a playground that toggles variants, disabled state, and active page, plus a compact sample in the components wrap.
- README quick sample, public exports, and widget tests covering rendering, interaction, and disabled behaviors.

## [0.0.6] - 2025-12-12

### Added

- `PragmaAvatarWidget`, a radius-driven avatar surface with fallbacks for image/icon/initials, palette styles, tooltips, and tap support.
- Example playground demonstrating avatar radius, style, and data bindings, plus README snippet for quick adoption.
- Widget tests covering initials/icon rendering, radius clamping, and semantics (goldens left as tech debt).

## [0.0.5] - 2025-12-12

### Changed

- Standardized the project language to English across README, documentation, and in-code comments.
- Documented the anatomy value contract (0.0–1.0 range) and clarified the DartDoc examples for `ModelPragmaComponent`.
- Promoted the package to version `0.0.5` to reflect the documentation overhaul.

## [0.0.4] - 2025-12-12

### Added

- Domain models `ModelPragmaComponent` and `ModelAnatomyAttribute` under `lib/src/domain/models`, exported through the public library.
- Unit tests plus JSON fixtures that validate the roundtrip for both models, ensuring consistent showcase data.
- Documentation in `doc/component_modeling.md` with property tables, JSON examples, and best practices.
- Example app updated to render documented components powered by the new models.
- README, version (`0.0.4`), and changelog aligned with the JSON-driven flow.

## [0.0.3] - 2025-12-12

### Added

- `PragmaAccordionWidget`, an accordion with internal state management, `IconData` support, block/default sizes, and `Semantics` wiring.
- `dartdoc` comments with copy/paste-ready examples plus public exports in `pragma_design_system.dart`.
- `PragmaBorderRadiusTokens` and `PragmaBorderRadius` helpers to standardize the radii defined in the spec.
- Widget tests for the accordion and unit tests that cover the new tokens.
- Example app updated to showcase enabled/disabled accordions and highlight the component guide in the README.
- Opacity tokens (`PragmaOpacityTokens`, `PragmaOpacity`) with dedicated documentation and a migration to `Color.withValues` across overlays.
- New guide `doc/opacity_tokens.md`, README link, and gradient/state control migrations in both the example app and widgets consuming the official transparency tokens.

## [0.0.2] - 2025-12-11

### Added

- Responsive grid tokens and utilities (`PragmaGridTokens`, `PragmaViewportEnum`, `getGridConfigFromWidth`/`Context`) with unit tests covering every breakpoint.
- `PragmaGridContainer`, a debug overlay that paints columns, gutters, and margins, plus an informative badge with viewport metrics.
- "Grid debugger" page inside the example app that renders the overlay live and showcases use cases per screen size.
- Documentation in `doc/` describing how to adopt the utilities and `PragmaGridContainer` in product implementations.
- `PragmaScaleBox`, a widget that scales fixed compositions inside the viewport with a demo linked from the Grid Debugger page.

## [0.0.1] - 2025-12-11

### Added

- Reference file with all official chromatic tokens plus Material 3 light/dark schemes built from them.
- Initial components (`PragmaButton`, `PragmaCard`, `PragmaIconButton`) and `PragmaButtons` utilities.
- Example app under `example/` that showcases tokens, theming, and components along with a base unit test.
- Full Poppins typography tokens (`PragmaTypographyTokens`) and a `TextTheme` aligned with the spec.
- Official spacing system with reusable tokens and `EdgeInsets` helpers.
- Documentation about the Poppins license, steps to include an offline fallback, and the `licenses/Poppins-OFL.txt` file.
- Example setup with bundled Poppins fonts, runtime `GoogleFonts` disabled, and a fallback in `PragmaTypography` that honors the registered assets.

## [0.0.5] - 2025-12-12

### Changed

- Standardized the project language to English across README, documentation, and in-code comments.
- Documented the anatomy value contract (0.0–1.0 range) and clarified the DartDoc examples for `ModelPragmaComponent`.
- Promoted the package to version `0.0.5` to reflect the documentation overhaul.

```

```
