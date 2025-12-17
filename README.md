# pragma_design_system

Flutter library focused on mobile experiences that bundles Pragma's design tokens, base themes, and reusable UI components.

## Features

- Consistent color, typography, spacing, and **responsive grid** tokens.
- `PragmaTheme` with light/dark variants and Material 3 enabled by default.
- Glow-based loading components (`PragmaLoadingWidget`) with circular and linear variants.
- Multi-state tables (`PragmaTableWidget`) with hover glow, tone presets, and compact density.
- Search-first input (`PragmaSearchWidget`) with neon glow, tone presets, size options, and dropdown-ready callbacks.
- Rich text areas (`PragmaTextAreaWidget`) with multi-line support, focus glow, validation states, and optional character counter.
- Neon tags (`PragmaTagWidget`) with gradient capsules, avatar slot, hover/pressed glow, and removable actions.
- Radio pills (`PragmaRadioButtonWidget`) with neon stroke, optional helper text, hover/pressed glow, and disabled styling.
- Glow checkboxes (`PragmaCheckboxWidget`) with multi-select support, indeterminate state, dense mode, and hover/pressed neon outline.
- Status badges (`PragmaBadgeWidget`) with light/dark palettes, icon slot, tone presets, and compact padding.
- Accessible components (`PragmaButton`, `PragmaCard`, `PragmaIconButtonWidget`, `PragmaInputWidget`, `PragmaToastWidget`, `PragmaAccordionWidget`, `PragmaColorTokenRowWidget`, `PragmaThemeEditorWidget`, `PragmaLogoWidget`).
- Theme lab sample that lets you edit colors/typography in real time and export a JSON payload backed by `ModelThemePragma`.
- `PragmaGridTokens`, viewport helpers, and the `PragmaGridContainer` widget to debug layouts.
- Component modeling (`ModelPragmaComponent`, `ModelAnatomyAttribute`) to sync documentation and showcases from JSON.
- Example app ready to run and validate (includes a "Grid debugger" page).

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
	pragma_design_system: ^1.2.4
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
- Rounded-corner guidance lives in [doc/rounded_corners.md](doc/rounded_corners.md), covering increments, implementation, and heuristics per component size.
- Glow search guidance vive en [doc/search.md](doc/search.md), explicando anatomia, estados y patrones con dropdown list.
- Text area guidance vive en [doc/textarea.md](doc/textarea.md), detallando anatomía, estados focus/error/success y mejores prácticas para copy largo.
- Tag guidance vive en [doc/tags.md](doc/tags.md), cubriendo anatomía, estados active/hover/pressed/disabled y flujos para remover participantes.
- Radio guidance vive en [doc/radio_button.md](doc/radio_button.md), describiendo anatomía, tokens y combinaciones unselected/hover/disabled para grupos exclusivos.
- Checkbox guidance vive en [doc/checkbox.md](doc/checkbox.md), explicando estados unchecked/checked/indeterminate, glow morado y patrones de "seleccionar todos".
- Badge guidance vive en [doc/badge.md](doc/badge.md), detallando tonos light/dark, anatomía y casos de uso informativos.
- **Opacity:** `PragmaOpacityTokens` and `PragmaOpacity` constrain overlays to 8/30/60 intervals using `Color.withValues` for Flutter 3.22+.
- **Domain models:** `ModelPragmaComponent`, `ModelAnatomyAttribute`, `ModelFieldState`, `ModelColorToken`, and `ModelThemePragma` serialize the documentation sourced from Figma, power the input widgets, and guarantee JSON roundtrips.
- **Grid:** `PragmaGridTokens`, `getGridConfigFromContext`, `PragmaGridContainer`, and `PragmaScaleBox` help replicate the official grid, respect gutters, and scale full mockups.
- **Components:** Widgets such as `PragmaPrimaryButton`, `PragmaSecondaryButton`, `PragmaButton.icon`, `PragmaCard`, `PragmaCardWidget`, `PragmaDropdownWidget`, `PragmaInputWidget`, `PragmaToastWidget`, `PragmaAvatarWidget`, `PragmaBreadcrumbWidget`, `PragmaAccordionWidget`, `PragmaColorTokenRowWidget`, `PragmaThemeEditorWidget`, `PragmaLogoWidget`, `PragmaCalendarWidget`, `PragmaLoadingWidget`, or `PragmaTableWidget` ship consistent states and elevation.

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

### Search quick sample

```dart
final TextEditingController searchController = TextEditingController();

PragmaSearchWidget(
	controller: searchController,
	placeholder: 'Busca squads o features',
	tone: PragmaSearchTone.dark,
	size: PragmaSearchSize.large,
	infoText: 'Escribe una palabra clave o abre el dropdown list',
	onChanged: (String value) {
		// Actualiza sugerencias o dropdown list
	},
	onSubmitted: (String value) {
		debugPrint('Buscar: $value');
	},
	onClear: () {
		debugPrint('Busqueda reiniciada');
	},
);
```

### Text area quick sample

```dart
final TextEditingController notesController = TextEditingController();

PragmaTextAreaWidget(
	label: 'Notas del requerimiento',
	controller: notesController,
	placeholder: 'Describe alcance, riesgos y pendientes...',
	description: 'Ideal para copy largo o acuerdos del squad.',
	maxLength: 320,
	minLines: 4,
	successText: 'Notas listas para compartir con el squad.',
);
```

### Tag quick sample

```dart
PragmaTagWidget(
	label: 'eugenia.sarmiento@pragma.com.co',
	leading: SizedBox(
		width: 28,
		height: 28,
		child: CircleAvatar(
			backgroundColor: Colors.white.withOpacity(0.2),
			child: const Text('ES'),
		),
	),
	onPressed: () {
		debugPrint('Abrir perfil de Eugenia');
	},
	onRemove: () {
		debugPrint('Eliminar tag de Eugenia');
	},
);
```

### Radio button quick sample

```dart
class _AccessLevelField extends StatelessWidget {
	const _AccessLevelField({required this.value, required this.onChanged});

	final String value;
	final ValueChanged<String?> onChanged;

	@override
	Widget build(BuildContext context) {
		return Column(
			children: <Widget>[
				PragmaRadioButtonWidget<String>(
					value: 'full',
					groupValue: value,
					label: 'Acceso total',
					description: 'Puede editar entregables y aprobar despliegues.',
					onChanged: onChanged,
				),
				PragmaRadioButtonWidget<String>(
					value: 'readonly',
					groupValue: value,
					label: 'Solo lectura',
					description: 'Ideal para stakeholders o clientes.',
					onChanged: onChanged,
				),
			],
		);
	}
}
```

### Checkbox quick sample

```dart
class _ScopeChecklist extends StatefulWidget {
	const _ScopeChecklist({super.key});

	@override
	State<_ScopeChecklist> createState() => _ScopeChecklistState();
}

class _ScopeChecklistState extends State<_ScopeChecklist> {
	bool design = true;
	bool qa = false;

	bool? get selectAll {
		if (design && qa) return true;
		if (!design && !qa) return false;
		return null;
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			children: <Widget>[
				PragmaCheckboxWidget(
					value: selectAll,
					tristate: true,
					label: 'Seleccionar todo',
					onChanged: (bool? value) {
						final bool shouldSelect = value ?? false;
						setState(() {
							design = shouldSelect;
							qa = shouldSelect;
						});
					},
				),
				PragmaCheckboxWidget(
					value: design,
					label: 'Diseño listo',
					description: 'Entregables revisados y compartidos.',
					onChanged: (bool? value) {
						setState(() => design = value ?? false);
					},
				),
				PragmaCheckboxWidget(
					value: qa,
					label: 'QA finalizado',
					onChanged: (bool? value) {
						setState(() => qa = value ?? false);
					},
				),
			],
		);
	}
}
```

### Badge quick sample

```dart
Wrap(
	spacing: PragmaSpacing.xs,
	runSpacing: PragmaSpacing.xs,
	children: <Widget>[
		PragmaBadgeWidget(
			label: 'Nuevo',
			icon: Icons.bolt,
		),
		PragmaBadgeWidget(
			label: 'QA',
			tone: PragmaBadgeTone.success,
			brightness: PragmaBadgeBrightness.dark,
		),
		PragmaBadgeWidget(
			label: 'Alert',
			tone: PragmaBadgeTone.warning,
		),
	],
);
```

### Color token row quick sample

```dart
ModelColorToken token = ModelColorToken(
	label: 'Primary',
	color: '#6750A4',
);

PragmaColorTokenRowWidget(
	token: token,
	onChanged: (ModelColorToken updated) {
		token = updated;
	},
);
```

### Logo quick sample

```dart
PragmaLogoWidget(
	width: 200,
	variant: PragmaLogoVariant.wordmark,
);

PragmaLogoWidget(
	width: 96,
	variant: PragmaLogoVariant.isotypeCircle,
);
```

### Calendar quick sample

```dart
final PragmaCalendarController controller = PragmaCalendarController(
	initialMonth: DateTime.now(),
);

PragmaCalendarWidget(
	controller: controller,
	selectionMode: PragmaCalendarSelectionMode.range,
	onSelectionChanged: (PragmaCalendarSelection value) {
		debugPrint('Rango: ${value.start} -> ${value.end}');
	},
);
```

### Loading quick sample

```dart
PragmaLoadingWidget(
	value: 0.75,
	caption: 'Circular',
);

PragmaLoadingWidget(
	variant: PragmaLoadingVariant.linear,
	value: 0.5,
	linearWidth: 280,
	caption: 'Progress bar',
);
```

### Table quick sample

```dart
final List<PragmaTableColumn> columns = <PragmaTableColumn>[
	const PragmaTableColumn(label: 'Nombre', flex: 3),
	const PragmaTableColumn(label: 'Proyecto', flex: 2),
	const PragmaTableColumn(
		label: 'Acción',
		flex: 1,
		alignment: Alignment.centerRight,
	),
];

PragmaTableWidget(
	columns: columns,
	rows: <PragmaTableRowData>[
		PragmaTableRowData(
			cells: <Widget>[
				const Text('Andreina Yajaira Francesca Serrano'),
				const Text('Discovery Lab'),
				PragmaTertiaryButton(
					label: 'Abrir',
					size: PragmaButtonSize.small,
					onPressed: () => debugPrint('Abrir ficha'),
				),
			],
		),
	],
);
```

### Theme editor quick sample

```dart
ModelThemePragma theme = ModelThemePragma();

PragmaThemeEditorWidget(
	theme: theme,
	onChanged: (ModelThemePragma updated) {
		theme = updated;
		final ThemeData data = PragmaThemeBuilder.buildTheme(updated);
		// Usa [data] para recargar tu MaterialApp o persistir el JSON generado.
	},
);
```

### Theme Lab workflow

1. Ejecuta el `example/` y presiona el botón **Theme lab** del `AppBar` (junto al Grid debugger) para abrir la página dedicada.
2. Ajusta la tipografía, el modo (claro/oscuro) y cada `ModelColorToken` desde los `PragmaColorTokenRowWidget` dentro del panel izquierdo.
3. Observa los cambios en vivo en el panel derecho: los botones, tarjetas (`PragmaCardWidget`) y gradientes usan el `ThemeData` generado por `PragmaThemeBuilder`.
4. Copia el JSON resultante desde la sección _"JSON listo para exportar"_ para versionarlo o compartirlo con tu squad.
5. Carga el JSON dentro de tu app (`ModelThemePragma.fromJson(payload)`) y construye un `ThemeData` con `PragmaThemeBuilder.buildTheme` para aplicar el tema en caliente o persistirlo como configuración.

### Toast quick sample

```dart
PragmaToastService.showToast(
	context: context,
	title: 'Operación exitosa',
	message: 'Synced con Discovery Lab hace 10 segundos.',
	variant: PragmaToastVariant.success,
	duration: const Duration(milliseconds: 4500),
	alignment: PragmaToastAlignment.topRight,
	actionLabel: 'Ver log',
	onActionPressed: () {
		debugPrint('Mostrar detalles');
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

Review [doc/logo.md](doc/logo.md) for asset usage guidelines and [doc/fonts.md](doc/fonts.md) for typography, licensing, and offline distribution tips.
Check [doc/loading.md](doc/loading.md) for anatomy, gradients, and scenarios for `PragmaLoadingWidget`.
Conoce la guía de filas, estados hover y casos de uso del componente en [doc/tables.md](doc/tables.md).

## Typography and license

- See [doc/fonts.md](doc/fonts.md) for the complete typography contract plus license highlights.
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
