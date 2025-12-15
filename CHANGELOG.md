# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
