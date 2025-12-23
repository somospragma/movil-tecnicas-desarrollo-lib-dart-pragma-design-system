import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../pragma_design_system.dart';

/// Builds [ThemeData] instances from [ModelThemePragma].
class PragmaThemeBuilder {
  const PragmaThemeBuilder._();

  /// Generates a Material 3 [ThemeData] honoring the color tokens defined in
  /// [theme].
  ///
  /// Key behavior:
  /// - Starts from Flutter's default `ColorScheme.light()` / `ColorScheme.dark()`.
  /// - Overrides ONLY the keys explicitly provided in [theme.colorTokens].
  /// - This guarantees every missing color role remains covered by a known,
  ///   deterministic default scheme (not `#000000`).
  static ThemeData buildTheme(ModelThemePragma theme) {
    final bool isDark = theme.brightness == ThemeBrightness.dark;

    final ColorScheme scheme = _colorSchemeFromTokens(theme);

    // Build a base ThemeData from defaults (light/dark) and then override
    // only what we need. This gives you sensible fallbacks for components.
    final ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
    );

    final TextTheme googleFontsTheme = GoogleFonts.getTextTheme(
      theme.typographyFamily,
      baseTheme.textTheme,
    );

    final Color bodyColor = _colorFromHex(theme.textColorFor('body').color);
    final Color displayColor =
        _colorFromHex(theme.textColorFor('display').color);
    final Color labelColor = _colorFromHex(theme.textColorFor('label').color);

    final TextTheme appliedTheme = googleFontsTheme.apply(
      bodyColor: bodyColor,
      displayColor: displayColor,
    );

    final TextTheme coloredTextTheme = appliedTheme.copyWith(
      labelLarge: appliedTheme.labelLarge?.copyWith(color: labelColor),
      labelMedium: appliedTheme.labelMedium?.copyWith(color: labelColor),
      labelSmall: appliedTheme.labelSmall?.copyWith(color: labelColor),
    );

    // Use copyWith so any properties we didn't set keep base defaults.
    return baseTheme.copyWith(
      textTheme: coloredTextTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
    );
  }

  static ColorScheme _colorSchemeFromTokens(ModelThemePragma theme) {
    final bool isDark = theme.brightness == ThemeBrightness.dark;

    // Deterministic fallbacks: Flutter defaults.
    final ColorScheme base =
        isDark ? const ColorScheme.dark() : const ColorScheme.light();

    // Helper: apply token only if provided.
    ColorScheme apply(
      ColorScheme scheme,
      String key,
      ColorScheme Function(ColorScheme s, Color c) setter,
    ) {
      final ModelColorToken? token = theme.colorTokens[key];
      if (token == null) {
        return scheme;
      }

      final Color? parsed = _tryColorFromHex(token.color);
      if (parsed == null) {
        return scheme;
      }

      return setter(scheme, parsed);
    }

    // Special helper for deprecated roles (still supported by ColorScheme but may warn).
    ColorScheme applyDeprecatedSurfaceVariant(ColorScheme scheme) {
      final ModelColorToken? token = theme.colorTokens['surfaceVariant'];
      if (token == null) {
        return scheme;
      }
      final Color? parsed = _tryColorFromHex(token.color);
      if (parsed == null) {
        return scheme;
      }

      // ignore: deprecated_member_use
      return scheme.copyWith(surfaceVariant: parsed);
    }

    ColorScheme applyDeprecatedBackground(ColorScheme scheme) {
      final ModelColorToken? bg = theme.colorTokens['background'];
      final ModelColorToken? onBg = theme.colorTokens['onBackground'];

      ColorScheme out = scheme;

      if (bg != null) {
        final Color? parsed = _tryColorFromHex(bg.color);
        if (parsed != null) {
          // ignore: deprecated_member_use
          out = out.copyWith(background: parsed);
        }
      }

      if (onBg != null) {
        final Color? parsed = _tryColorFromHex(onBg.color);
        if (parsed != null) {
          // ignore: deprecated_member_use
          out = out.copyWith(onBackground: parsed);
        }
      }

      return out;
    }

    ColorScheme scheme = base;

    // Core
    scheme = apply(
      scheme,
      'primary',
      (ColorScheme s, Color c) => s.copyWith(primary: c),
    );
    scheme = apply(
      scheme,
      'onPrimary',
      (ColorScheme s, Color c) => s.copyWith(onPrimary: c),
    );
    scheme = apply(
      scheme,
      'primaryContainer',
      (ColorScheme s, Color c) => s.copyWith(primaryContainer: c),
    );
    scheme = apply(
      scheme,
      'onPrimaryContainer',
      (ColorScheme s, Color c) => s.copyWith(onPrimaryContainer: c),
    );

    scheme = apply(
      scheme,
      'secondary',
      (ColorScheme s, Color c) => s.copyWith(secondary: c),
    );
    scheme = apply(
      scheme,
      'onSecondary',
      (ColorScheme s, Color c) => s.copyWith(onSecondary: c),
    );
    scheme = apply(
      scheme,
      'secondaryContainer',
      (ColorScheme s, Color c) => s.copyWith(secondaryContainer: c),
    );
    scheme = apply(
      scheme,
      'onSecondaryContainer',
      (ColorScheme s, Color c) => s.copyWith(onSecondaryContainer: c),
    );

    scheme = apply(
      scheme,
      'tertiary',
      (ColorScheme s, Color c) => s.copyWith(tertiary: c),
    );
    scheme = apply(
      scheme,
      'onTertiary',
      (ColorScheme s, Color c) => s.copyWith(onTertiary: c),
    );
    scheme = apply(
      scheme,
      'tertiaryContainer',
      (ColorScheme s, Color c) => s.copyWith(tertiaryContainer: c),
    );
    scheme = apply(
      scheme,
      'onTertiaryContainer',
      (ColorScheme s, Color c) => s.copyWith(onTertiaryContainer: c),
    );

    // Error
    scheme = apply(
      scheme,
      'error',
      (ColorScheme s, Color c) => s.copyWith(error: c),
    );
    scheme = apply(
      scheme,
      'onError',
      (ColorScheme s, Color c) => s.copyWith(onError: c),
    );
    scheme = apply(
      scheme,
      'errorContainer',
      (ColorScheme s, Color c) => s.copyWith(errorContainer: c),
    );
    scheme = apply(
      scheme,
      'onErrorContainer',
      (ColorScheme s, Color c) => s.copyWith(onErrorContainer: c),
    );

    // Surfaces
    scheme = apply(
      scheme,
      'surface',
      (ColorScheme s, Color c) => s.copyWith(surface: c),
    );
    scheme = apply(
      scheme,
      'onSurface',
      (ColorScheme s, Color c) => s.copyWith(onSurface: c),
    );
    scheme = apply(
      scheme,
      'onSurfaceVariant',
      (ColorScheme s, Color c) => s.copyWith(onSurfaceVariant: c),
    );

    // Surface containers (Material 3)
    scheme = apply(
      scheme,
      'surfaceDim',
      (ColorScheme s, Color c) => s.copyWith(surfaceDim: c),
    );
    scheme = apply(
      scheme,
      'surfaceBright',
      (ColorScheme s, Color c) => s.copyWith(surfaceBright: c),
    );
    scheme = apply(
      scheme,
      'surfaceContainerLowest',
      (ColorScheme s, Color c) => s.copyWith(surfaceContainerLowest: c),
    );
    scheme = apply(
      scheme,
      'surfaceContainerLow',
      (ColorScheme s, Color c) => s.copyWith(surfaceContainerLow: c),
    );
    scheme = apply(
      scheme,
      'surfaceContainer',
      (ColorScheme s, Color c) => s.copyWith(surfaceContainer: c),
    );
    scheme = apply(
      scheme,
      'surfaceContainerHigh',
      (ColorScheme s, Color c) => s.copyWith(surfaceContainerHigh: c),
    );
    scheme = apply(
      scheme,
      'surfaceContainerHighest',
      (ColorScheme s, Color c) => s.copyWith(surfaceContainerHighest: c),
    );

    // Backward-compat mapping:
    // If you only have `surfaceVariant` token (old world), use it as a fallback
    // for `surfaceContainerHighest` (new world) ONLY when the new key is missing.
    if (!theme.colorTokens.containsKey('surfaceContainerHighest') &&
        theme.colorTokens.containsKey('surfaceVariant')) {
      final Color? parsed =
          _tryColorFromHex(theme.colorFor('surfaceVariant').color);
      if (parsed != null) {
        scheme = scheme.copyWith(surfaceContainerHighest: parsed);
      }
    }

    // Others
    scheme = apply(
      scheme,
      'outline',
      (ColorScheme s, Color c) => s.copyWith(outline: c),
    );
    scheme = apply(
      scheme,
      'outlineVariant',
      (ColorScheme s, Color c) => s.copyWith(outlineVariant: c),
    );
    scheme = apply(
      scheme,
      'shadow',
      (ColorScheme s, Color c) => s.copyWith(shadow: c),
    );
    scheme = apply(
      scheme,
      'scrim',
      (ColorScheme s, Color c) => s.copyWith(scrim: c),
    );
    scheme = apply(
      scheme,
      'inverseSurface',
      (ColorScheme s, Color c) => s.copyWith(inverseSurface: c),
    );
    scheme = apply(
      scheme,
      'onInverseSurface',
      (ColorScheme s, Color c) => s.copyWith(onInverseSurface: c),
    );
    scheme = apply(
      scheme,
      'inversePrimary',
      (ColorScheme s, Color c) => s.copyWith(inversePrimary: c),
    );
    scheme = apply(
      scheme,
      'surfaceTint',
      (ColorScheme s, Color c) => s.copyWith(surfaceTint: c),
    );

    // Fixed roles (Material 3)
    scheme = apply(
      scheme,
      'primaryFixed',
      (ColorScheme s, Color c) => s.copyWith(primaryFixed: c),
    );
    scheme = apply(
      scheme,
      'primaryFixedDim',
      (ColorScheme s, Color c) => s.copyWith(primaryFixedDim: c),
    );
    scheme = apply(
      scheme,
      'onPrimaryFixed',
      (ColorScheme s, Color c) => s.copyWith(onPrimaryFixed: c),
    );
    scheme = apply(
      scheme,
      'onPrimaryFixedVariant',
      (ColorScheme s, Color c) => s.copyWith(onPrimaryFixedVariant: c),
    );

    scheme = apply(
      scheme,
      'secondaryFixed',
      (ColorScheme s, Color c) => s.copyWith(secondaryFixed: c),
    );
    scheme = apply(
      scheme,
      'secondaryFixedDim',
      (ColorScheme s, Color c) => s.copyWith(secondaryFixedDim: c),
    );
    scheme = apply(
      scheme,
      'onSecondaryFixed',
      (ColorScheme s, Color c) => s.copyWith(onSecondaryFixed: c),
    );
    scheme = apply(
      scheme,
      'onSecondaryFixedVariant',
      (ColorScheme s, Color c) => s.copyWith(onSecondaryFixedVariant: c),
    );

    scheme = apply(
      scheme,
      'tertiaryFixed',
      (ColorScheme s, Color c) => s.copyWith(tertiaryFixed: c),
    );
    scheme = apply(
      scheme,
      'tertiaryFixedDim',
      (ColorScheme s, Color c) => s.copyWith(tertiaryFixedDim: c),
    );
    scheme = apply(
      scheme,
      'onTertiaryFixed',
      (ColorScheme s, Color c) => s.copyWith(onTertiaryFixed: c),
    );
    scheme = apply(
      scheme,
      'onTertiaryFixedVariant',
      (ColorScheme s, Color c) => s.copyWith(onTertiaryFixedVariant: c),
    );

    // Deprecated roles (kept for compatibility)
    scheme = applyDeprecatedSurfaceVariant(scheme);
    scheme = applyDeprecatedBackground(scheme);

    return scheme;
  }

  /// Strict parser with safe failure (returns null when invalid).
  static Color? _tryColorFromHex(String hex) {
    final String sanitized = hex.replaceAll('#', '').toUpperCase();
    try {
      if (sanitized.length == 6) {
        return Color(int.parse('0xFF$sanitized'));
      }
      if (sanitized.length == 8) {
        return Color(int.parse('0x$sanitized'));
      }
    } on FormatException {
      return null;
    }
    return null;
  }

  static Color _colorFromHex(String hex, {String fallback = '#000000'}) {
    final Color? parsed = _tryColorFromHex(hex);
    if (parsed != null) {
      return parsed;
    }

    final Color? parsedFallback = _tryColorFromHex(fallback);
    return parsedFallback ?? const Color(0xFF000000);
  }
}
