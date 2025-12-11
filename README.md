# pragma_design_system

Biblioteca Flutter enfocada en móviles que reúne los tokens de diseño, temas base y componentes reutilizables del Design System de Pragma.

## Características

- Tokens consistentes de color, tipografía y espaciado.
- `PragmaTheme` con variantes claro/oscuro y Material 3 habilitado.
- Componentes accesibles (`PragmaButton`, `PragmaCard`, `PragmaIconButton`).
- App de ejemplo lista para ejecutar y validar en dispositivos reales.

## Instalación

Agrega el paquete en tu `pubspec.yaml`:

```yaml
dependencies:
	pragma_design_system: ^0.0.1
```

Después ejecuta:

```sh
flutter pub get
```

## Uso rápido

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

## Tokens y componentes

- **Colores:** `PragmaColors` expone esquemas `ColorScheme` claro/oscuro y valores de marca.
- **Tipografía:** `PragmaTypography` define escalas responsivas basadas en Google Fonts.
- **Espaciado:** `PragmaSpacing` concentra valores de 4pt system y funciones utilitarias.
- **Componentes:** Widgets como `PragmaButton.icon` o `PragmaCard` incluyen estados y elevación consistentes.

Consulta el paquete para más utilidades (`lib/src`) o revisa la app de ejemplo.

## Ejemplo

```sh
cd example
flutter run
```

La app incluye una pantalla conmutando tema, tokens y componentes básicos.

## Desarrollo

- `flutter test` para ejecutar las pruebas.
- `dart format .` para mantener el estilo.
- `flutter analyze` para validar contra `analysis_options.yaml`.
