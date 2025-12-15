import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../domain/models/model_theme_pragma.dart';

/// Builds [ThemeData] instances from [ModelThemePragma].
class PragmaThemeBuilder {
  const PragmaThemeBuilder._();

  /// Generates a Material 3 [ThemeData] honoring the color tokens defined in
  /// [theme].
  static ThemeData buildTheme(ModelThemePragma theme) {
    final ColorScheme scheme = _colorSchemeFromTokens(theme);
    final TextTheme baseTextTheme = ThemeData(
      colorScheme: scheme,
      brightness: theme.brightness == ThemeBrightness.dark
          ? Brightness.dark
          : Brightness.light,
      useMaterial3: true,
    ).textTheme;

    final TextTheme googleFontsTheme = GoogleFonts.getTextTheme(
      theme.typographyFamily,
      baseTextTheme,
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

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: coloredTextTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
    );
  }

  static ColorScheme _colorSchemeFromTokens(ModelThemePragma theme) {
    Color resolve(String key, String fallback) {
      return _colorFromHex(theme.colorFor(key).color, fallback: fallback);
    }

    final bool isDark = theme.brightness == ThemeBrightness.dark;
    return ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: resolve('primary', '#6750A4'),
      onPrimary: resolve('onPrimary', '#FFFFFF'),
      primaryContainer: resolve('primaryContainer', '#EADDFF'),
      onPrimaryContainer: resolve('onPrimaryContainer', '#21005D'),
      secondary: resolve('secondary', '#625B71'),
      onSecondary: resolve('onSecondary', '#FFFFFF'),
      secondaryContainer: resolve('secondaryContainer', '#E8DEF8'),
      onSecondaryContainer: resolve('onSecondaryContainer', '#1D192B'),
      tertiary: resolve('tertiary', '#7D5260'),
      onTertiary: resolve('onTertiary', '#FFFFFF'),
      tertiaryContainer: resolve('tertiaryContainer', '#FFD8E4'),
      onTertiaryContainer: resolve('onTertiaryContainer', '#31111D'),
      error: resolve('error', '#B3261E'),
      onError: resolve('onError', '#FFFFFF'),
      surface: resolve('surface', isDark ? '#1C1B1F' : '#FFFBFE'),
      onSurface: resolve('onSurface', isDark ? '#E6E1E5' : '#1C1B1F'),
      surfaceContainerHighest: resolve('surfaceVariant', '#E7E0EC'),
      onSurfaceVariant: resolve('onSurfaceVariant', '#49454F'),
      outline: resolve('outline', '#79747E'),
      outlineVariant: resolve('outlineVariant', '#C4C7C5'),
      shadow: resolve('shadow', '#000000'),
      scrim: resolve('scrim', '#000000'),
      inverseSurface: resolve('inverseSurface', '#313033'),
      onInverseSurface: resolve('onInverseSurface', '#F4EFF4'),
      inversePrimary: resolve('inversePrimary', '#D0BCFF'),
      surfaceTint: resolve('surfaceTint', '#6750A4'),
    );
  }

  static Color _colorFromHex(String hex, {String fallback = '#000000'}) {
    final String sanitized = hex.replaceAll('#', '').toUpperCase();
    if (sanitized.length == 6) {
      return Color(int.parse('0xFF$sanitized'));
    }
    if (sanitized.length == 8) {
      return Color(int.parse('0x$sanitized'));
    }
    final String fallbackSanitized = fallback.replaceAll('#', '').toUpperCase();
    if (fallbackSanitized.length == 6) {
      return Color(int.parse('0xFF$fallbackSanitized'));
    }
    return const Color(0xFF000000);
  }
}
