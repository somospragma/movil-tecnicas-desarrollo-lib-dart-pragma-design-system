# Ensuring offline Poppins

This document explains how to make the official typeface (Poppins) available from the very first run of any app that depends on `pragma_design_system`.

## Minimum recommended weights

The design manual primarily leverages Regular (400), SemiBold (600), and Bold (700). Download the individual files from the official Google Fonts repository:

- [Poppins-Regular.ttf](https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf)
- [Poppins-SemiBold.ttf](https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-SemiBold.ttf)
- [Poppins-Bold.ttf](https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf)

Store them inside your project's `assets/fonts/` folder. If your product needs to support _every_ weight, download the complete package from [https://fonts.google.com/specimen/Poppins](https://fonts.google.com/specimen/Poppins) and copy the corresponding `.ttf` files.

## Declare the assets

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
        # Add extra weights here if you need them
```

## Disable runtime fetching

`PragmaTypography` automatically uses the registered family when `GoogleFonts.config.allowRuntimeFetching` is `false`. Configure it before invoking `runApp`:

```dart
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const PragmaApp());
}
```

The sample app (`example/` folder) already implements these steps, so feel free to use it as a reference.
