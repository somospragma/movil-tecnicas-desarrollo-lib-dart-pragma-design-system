# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
