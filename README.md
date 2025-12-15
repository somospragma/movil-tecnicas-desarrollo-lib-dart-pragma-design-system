# pragma_design_system

Flutter library focused on mobile experiences that bundles Pragma's design tokens, base themes, and reusable UI components.

## Features

- Consistent color, typography, spacing, and **responsive grid** tokens.
- `PragmaTheme` with light/dark variants and Material 3 enabled by default.
- Accessible components (`PragmaButton`, `PragmaCard`, `PragmaIconButtonWidget`, `PragmaInputWidget`, `PragmaAccordionWidget`).
- `PragmaGridTokens`, viewport helpers, and the `PragmaGridContainer` widget to debug layouts.
- Component modeling (`ModelPragmaComponent`, `ModelAnatomyAttribute`) to sync documentation and showcases from JSON.
- Example app ready to run and validate (includes a "Grid debugger" page).

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
	pragma_design_system: ^0.1.3
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
- **Domain models:** `ModelPragmaComponent`, `ModelAnatomyAttribute`, and `ModelFieldState` serialize the documentation sourced from Figma, power the input widgets, and guarantee JSON roundtrips.
- **Grid:** `PragmaGridTokens`, `getGridConfigFromContext`, `PragmaGridContainer`, and `PragmaScaleBox` help replicate the official grid, respect gutters, and scale full mockups.
- **Components:** Widgets such as `PragmaPrimaryButton`, `PragmaSecondaryButton`, `PragmaButton.icon`, `PragmaCard`, `PragmaCardWidget`, `PragmaDropdownWidget`, `PragmaInputWidget`, `PragmaAvatarWidget`, `PragmaBreadcrumbWidget`, or `PragmaAccordionWidget` ship consistent states and elevation.

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

### Button quick sample

```dart
PragmaPrimaryButton(
	label: 'Guardar cambios',
	one: PragmaButtonTone.brand,
	onPressed: () {},
)

PragmaButton.icon(
	label: 'Ver detalles',
	icon: Icons.open_in_new,
	hierarchy: PragmaButtonHierarchy.tertiary,
	onPressed: () {},
)
```

### Icon button quick sample

```dart
PragmaIconButtonWidget(
	icon: Icons.add,
	style: PragmaIconButtonStyle.filledLight,
	onPressed: () {},
)

PragmaIconButtonWidget(
	icon: Icons.close,
	style: PragmaIconButtonStyle.outlinedDark,
	size: PragmaIconButtonSize.compact,
	onPressed: () {},
)
```

### Input quick sample

```dart
final PragmaInputController controller = PragmaInputController(
	ModelFieldState(
		suggestions: <String>['Discovery Lab', 'Growth', 'Mobile Core'],
	),
);

PragmaInputWidget(
	label: 'Nombre del squad',
	controller: controller,
	placeholder: 'Escribe un equipo',
	helperText: 'Filtramos sugerencias automáticamente',
	enablePasswordToggle: true,
	obscureText: true,
	onChanged: (String value) {
		controller
			..setValidation(isDirty: true, isValid: value.isNotEmpty)
			..setError(value.isEmpty ? 'Dato requerido' : null);
	},
);
```

### Breadcrumb quick sample

```dart
PragmaBreadcrumbWidget(
	items: const <PragmaBreadcrumbItem>[
		PragmaBreadcrumbItem(label: 'Home', onTap: _navigateHome),
		PragmaBreadcrumbItem(label: 'Components', onTap: _goToComponents),
		PragmaBreadcrumbItem(label: 'Breadcrumb', isCurrent: true),
	],
	type: PragmaBreadcrumbType.underline,
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

### Card quick sample

```
PragmaCardWidget(
	title: 'Funnel weekly',
	subtitle: 'Actualizado hace 5 min',
	body: Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: const <Widget>[
			Text('Sesiones: 18.4K'),
			SizedBox(height: PragmaSpacing.xs),
			Text('CTR: 4.1% vs semana anterior'),
		],
	),
	variant: PragmaCardVariant.tonal,
	actions: <Widget>[
		PragmaButton.icon(
			label: 'Ver dashboard',
			icon: Icons.open_in_new,
			hierarchy: PragmaButtonHierarchy.tertiary,
			onPressed: () {},
		),
	],
)
```

### Dropdown quick sample

```
PragmaDropdownWidget<String>(
	label: 'Rol asignado',
	placeholder: 'Selecciona un rol',
	helperText: 'Usaremos este rol en los tableros',
	options: const <PragmaDropdownOption<String>>[
		PragmaDropdownOption(label: 'Product Designer', value: 'ux'),
		PragmaDropdownOption(label: 'Product Manager', value: 'pm'),
		PragmaDropdownOption(label: 'iOS Engineer', value: 'ios'),
	],
	onChanged: (String? value) {
		debugPrint('Role: $value');
	},
)
```

- `flutter test` to run the tests.

### Dropdown list quick sample

```
PragmaDropdownListWidget<String>(
	label: 'Equipo colaborador',
	placeholder: 'Selecciona perfiles',
	options: const <PragmaDropdownOption<String>>[
		PragmaDropdownOption(label: 'UX Research', value: 'research'),
		PragmaDropdownOption(label: 'Mobile iOS', value: 'ios'),
		PragmaDropdownOption(label: 'Mobile Android', value: 'android'),
	],
	initialSelectedValues: const <String>['ios'],
	onSelectionChanged: (List<String> roles) {
		debugPrint('Seleccionados: $roles');
	},
	onItemRemoved: (String value) {
		debugPrint('Eliminado: $value');
	},
)
- `dart format .` to keep formatting consistent.
- `flutter analyze` to validate against `analysis_options.yaml`.
```
