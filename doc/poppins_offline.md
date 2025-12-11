# Asegurar Poppins sin conexión

Este documento describe cómo garantizar que la tipografía oficial (Poppins) esté disponible desde la primera ejecución de cualquier app que consuma `pragma_design_system`.

## Variantes mínimas recomendadas

El manual de diseño utiliza principalmente las variantes Regular (400), SemiBold (600) y Bold (700). Puedes descargar los archivos individuales desde el repositorio oficial de Google Fonts:

- [Poppins-Regular.ttf](https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf)
- [Poppins-SemiBold.ttf](https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-SemiBold.ttf)
- [Poppins-Bold.ttf](https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf)

Guárdalos en la carpeta `assets/fonts/` de tu proyecto. Si tu producto necesita soportar _todas_ las variantes, descarga el paquete completo desde [https://fonts.google.com/specimen/Poppins](https://fonts.google.com/specimen/Poppins) y copia los archivos `.ttf` correspondientes.

## Declarar los assets

```yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
          weight: 400
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        # Agrega aquí las variantes adicionales si las necesitas
```

## Deshabilitar la descarga en tiempo de ejecución

`PragmaTypography` usará automáticamente la familia registrada cuando `GoogleFonts.config.allowRuntimeFetching` sea `false`. Configúralo antes de invocar `runApp`:

```dart
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const PragmaApp());
}
```

La app de ejemplo (carpeta `example/`) ya tiene estos pasos implementados para que puedas usarlos como referencia.
