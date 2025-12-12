# pragma_design_system

Flutter library focused on mobile experiences that bundles Pragma's design tokens, base themes, and reusable UI components.

## Features

- Consistent color, typography, spacing, and **responsive grid** tokens.
- `PragmaTheme` with light/dark variants and Material 3 enabled by default.
- Accessible components (`PragmaButton`, `PragmaCard`, `PragmaIconButton`, `PragmaAccordionWidget`).
- `PragmaGridTokens`, viewport helpers, and the `PragmaGridContainer` widget to debug layouts.
- Component modeling (`ModelPragmaComponent`, `ModelAnatomyAttribute`) to sync documentation and showcases from JSON.
- Example app ready to run and validate (includes a "Grid debugger" page).

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
	pragma_design_system: ^0.0.6
```

Then run:

```sh
flutter pub get
```

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class PragmaApp extends StatelessWidget {
	const PragmaApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Pragma Design System',
			theme: PragmaTheme.light(),
			darkTheme: PragmaTheme.dark(),
			home: const PragmaHome(),
		);
	}
}
```

## Tokens and components

- **Colors:** `PragmaColors` exposes brand-aware `ColorScheme` definitions for light and dark modes.
- **Typography:** `PragmaTypography` defines responsive scales built on top of Google Fonts.
- **Spacing:** `PragmaSpacing` concentrates 4pt-system values and handy utilities.
- **Radius:** `PragmaBorderRadiusTokens` and `PragmaBorderRadius` keep rounded corners consistent in 4/8dp steps.
- **Opacity:** `PragmaOpacityTokens` and `PragmaOpacity` constrain overlays to 8/30/60 intervals using `Color.withValues` for Flutter 3.22+.
- **Domain models:** `ModelPragmaComponent` and `ModelAnatomyAttribute` serialize the documentation sourced from Figma and guarantee JSON roundtrips.
- **Grid:** `PragmaGridTokens`, `getGridConfigFromContext`, `PragmaGridContainer`, and `PragmaScaleBox` help replicate the official grid, respect gutters, and scale full mockups.
- **Components:** Widgets such as `PragmaButton.icon`, `PragmaCard`, `PragmaAvatarWidget`, or `PragmaAccordionWidget` ship consistent states and elevation.

### Avatar quick sample

```dart
PragmaAvatarWidget(
	radius: 28,
	initials: 'PD',
	imageUrl: 'https://cdn.pragma.co/avatar.jpg',
	style: PragmaAvatarStyle.primary,
	tooltip: 'Pragma Designer',
)
```

See [doc/opacity_tokens.md](doc/opacity_tokens.md) for the full opacity table and `Color.withValues` examples.

Read [doc/component_modeling.md](doc/component_modeling.md) to structure JSON payloads and reuse them in showcases.

Explore `lib/src` for additional utilities, run the example app, and check [doc/grid_utilities.md](doc/grid_utilities.md) to adopt the grid helpers.

## Typography and license

- The official typeface is [Poppins](https://fonts.google.com/specimen/Poppins) and `PragmaTypography` applies it through `GoogleFonts.poppins`.
- The family ships under the **SIL Open Font License 1.1**; see the full text in [licenses/Poppins-OFL.txt](licenses/Poppins-OFL.txt).
- If your app must work offline on first launch, bundle the `.ttf` files in your assets and disable runtime fetching.
- Follow [doc/poppins_offline.md](doc/poppins_offline.md) for the step-by-step guide and download links.

### How to prepare an offline fallback

1. Download the weights you use (for example Regular, SemiBold, and Bold) from Google Fonts and store them inside `assets/fonts/`.
2. Declare them in `pubspec.yaml`:

   ```yaml
   flutter:
   	 fonts:
   		 - family: Poppins
   			 fonts:
   				 - asset: assets/fonts/Poppins-Regular.ttf
   				 - asset: assets/fonts/Poppins-SemiBold.ttf
   				 - asset: assets/fonts/Poppins-Bold.ttf
   ```

3. Disable runtime fetching during startup:

   ```dart
   void main() {
   	 GoogleFonts.config.allowRuntimeFetching = false;
   	 runApp(const PragmaApp());
   }
   ```

   Remember to import `package:google_fonts/google_fonts.dart`.

If you skip bundling the files, the responsibility of providing the typeface falls on the app that consumes this package.

## Example

```sh
cd example
flutter run
```

The sample app toggles themes, tokens, and staple components.

## Development

- `flutter test` to run the tests.
- `dart format .` to keep formatting consistent.
- `flutter analyze` to validate against `analysis_options.yaml`.
