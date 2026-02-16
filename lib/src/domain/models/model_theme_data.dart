import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../tokens/pragma_colors.dart';
import '../../tokens/pragma_typography.dart';

abstract final class ModelThemeDataKeys {
  static const String useMaterial3 = 'useMaterial3';
  static const String lightScheme = 'lightScheme';
  static const String darkScheme = 'darkScheme';
  static const String lightTextTheme = 'lightTextTheme';
  static const String darkTextTheme = 'darkTextTheme';
}

abstract final class _ColorSchemeKeys {
  static const String brightness = 'brightness';
  static const String primary = 'primary';
  static const String onPrimary = 'onPrimary';
  static const String primaryContainer = 'primaryContainer';
  static const String onPrimaryContainer = 'onPrimaryContainer';
  static const String secondary = 'secondary';
  static const String onSecondary = 'onSecondary';
  static const String secondaryContainer = 'secondaryContainer';
  static const String onSecondaryContainer = 'onSecondaryContainer';
  static const String tertiary = 'tertiary';
  static const String onTertiary = 'onTertiary';
  static const String tertiaryContainer = 'tertiaryContainer';
  static const String onTertiaryContainer = 'onTertiaryContainer';
  static const String error = 'error';
  static const String onError = 'onError';
  static const String errorContainer = 'errorContainer';
  static const String onErrorContainer = 'onErrorContainer';
  static const String surface = 'surface';
  static const String onSurface = 'onSurface';
  static const String onSurfaceVariant = 'onSurfaceVariant';
  static const String outline = 'outline';
  static const String outlineVariant = 'outlineVariant';
  static const String shadow = 'shadow';
  static const String scrim = 'scrim';
  static const String inverseSurface = 'inverseSurface';
  static const String inversePrimary = 'inversePrimary';
  static const String surfaceTint = 'surfaceTint';
  static const String surfaceContainerHighest = 'surfaceContainerHighest';
}

abstract final class _TextThemeKeys {
  static const String displayLarge = 'displayLarge';
  static const String displayMedium = 'displayMedium';
  static const String displaySmall = 'displaySmall';
  static const String headlineLarge = 'headlineLarge';
  static const String headlineMedium = 'headlineMedium';
  static const String headlineSmall = 'headlineSmall';
  static const String titleLarge = 'titleLarge';
  static const String titleMedium = 'titleMedium';
  static const String titleSmall = 'titleSmall';
  static const String bodyLarge = 'bodyLarge';
  static const String bodyMedium = 'bodyMedium';
  static const String bodySmall = 'bodySmall';
  static const String labelLarge = 'labelLarge';
  static const String labelMedium = 'labelMedium';
  static const String labelSmall = 'labelSmall';
}

abstract final class _TextStyleKeys {
  static const String color = 'color';
  static const String fontSize = 'fontSize';
  static const String fontWeight = 'fontWeight';
  static const String height = 'height';
  static const String letterSpacing = 'letterSpacing';
  static const String fontFamily = 'fontFamily';
}

@immutable
class ModelThemeData {
  const ModelThemeData({
    required this.lightScheme,
    required this.darkScheme,
    required this.lightTextTheme,
    required this.darkTextTheme,
    required this.useMaterial3,
  });

  factory ModelThemeData.pragmaDefault() {
    return ModelThemeData(
      lightScheme: PragmaColors.lightScheme,
      darkScheme: PragmaColors.darkScheme,
      lightTextTheme: PragmaTypography.textTheme(),
      darkTextTheme: PragmaTypography.textTheme(brightness: Brightness.dark),
      useMaterial3: true,
    );
  }

  factory ModelThemeData.fromJson(Map<String, dynamic> json) {
    final Object? useMaterial3Raw = json[ModelThemeDataKeys.useMaterial3];
    final Object? lightSchemeRaw = json[ModelThemeDataKeys.lightScheme];
    final Object? darkSchemeRaw = json[ModelThemeDataKeys.darkScheme];
    final Object? lightTextThemeRaw = json[ModelThemeDataKeys.lightTextTheme];
    final Object? darkTextThemeRaw = json[ModelThemeDataKeys.darkTextTheme];

    if (useMaterial3Raw is! bool) {
      throw const FormatException('Expected bool for useMaterial3');
    }
    if (lightSchemeRaw is! Map<String, dynamic>) {
      throw const FormatException('Expected map for lightScheme');
    }
    if (darkSchemeRaw is! Map<String, dynamic>) {
      throw const FormatException('Expected map for darkScheme');
    }

    return ModelThemeData(
      useMaterial3: useMaterial3Raw,
      lightScheme: _schemeFromJson(lightSchemeRaw),
      darkScheme: _schemeFromJson(darkSchemeRaw),
      lightTextTheme: lightTextThemeRaw is Map<String, dynamic>
          ? _textThemeFromJson(lightTextThemeRaw)
          : PragmaTypography.textTheme(),
      darkTextTheme: darkTextThemeRaw is Map<String, dynamic>
          ? _textThemeFromJson(darkTextThemeRaw)
          : PragmaTypography.textTheme(brightness: Brightness.dark),
    );
  }

  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  final TextTheme lightTextTheme;
  final TextTheme darkTextTheme;
  final bool useMaterial3;

  ThemeData toThemeData({required Brightness brightness}) {
    final bool isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: brightness,
      colorScheme: isDark ? darkScheme : lightScheme,
      textTheme: isDark ? darkTextTheme : lightTextTheme,
    );
  }

  static ModelThemeData fromThemeData({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
  }) {
    return ModelThemeData(
      lightScheme: lightTheme.colorScheme,
      darkScheme: darkTheme.colorScheme,
      lightTextTheme: lightTheme.textTheme,
      darkTextTheme: darkTheme.textTheme,
      useMaterial3: lightTheme.useMaterial3,
    );
  }

  ModelThemeData copyWith({
    ColorScheme? lightScheme,
    ColorScheme? darkScheme,
    TextTheme? lightTextTheme,
    TextTheme? darkTextTheme,
    bool? useMaterial3,
  }) {
    return ModelThemeData(
      lightScheme: lightScheme ?? this.lightScheme,
      darkScheme: darkScheme ?? this.darkScheme,
      lightTextTheme: lightTextTheme ?? this.lightTextTheme,
      darkTextTheme: darkTextTheme ?? this.darkTextTheme,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        ModelThemeDataKeys.useMaterial3: useMaterial3,
        ModelThemeDataKeys.lightScheme: _schemeToJson(lightScheme),
        ModelThemeDataKeys.darkScheme: _schemeToJson(darkScheme),
        ModelThemeDataKeys.lightTextTheme: _textThemeToJson(lightTextTheme),
        ModelThemeDataKeys.darkTextTheme: _textThemeToJson(darkTextTheme),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ModelThemeData) {
      return false;
    }
    return mapEquals(toJson(), other.toJson());
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
        useMaterial3,
        lightScheme,
        darkScheme,
        lightTextTheme,
        darkTextTheme,
      ]);

  static Map<String, dynamic> _schemeToJson(ColorScheme s) {
    return <String, dynamic>{
      _ColorSchemeKeys.brightness: s.brightness.name,
      _ColorSchemeKeys.primary: s.primary.toARGB32(),
      _ColorSchemeKeys.onPrimary: s.onPrimary.toARGB32(),
      _ColorSchemeKeys.primaryContainer: s.primaryContainer.toARGB32(),
      _ColorSchemeKeys.onPrimaryContainer: s.onPrimaryContainer.toARGB32(),
      _ColorSchemeKeys.secondary: s.secondary.toARGB32(),
      _ColorSchemeKeys.onSecondary: s.onSecondary.toARGB32(),
      _ColorSchemeKeys.secondaryContainer: s.secondaryContainer.toARGB32(),
      _ColorSchemeKeys.onSecondaryContainer: s.onSecondaryContainer.toARGB32(),
      _ColorSchemeKeys.tertiary: s.tertiary.toARGB32(),
      _ColorSchemeKeys.onTertiary: s.onTertiary.toARGB32(),
      _ColorSchemeKeys.tertiaryContainer: s.tertiaryContainer.toARGB32(),
      _ColorSchemeKeys.onTertiaryContainer: s.onTertiaryContainer.toARGB32(),
      _ColorSchemeKeys.error: s.error.toARGB32(),
      _ColorSchemeKeys.onError: s.onError.toARGB32(),
      _ColorSchemeKeys.errorContainer: s.errorContainer.toARGB32(),
      _ColorSchemeKeys.onErrorContainer: s.onErrorContainer.toARGB32(),
      _ColorSchemeKeys.surface: s.surface.toARGB32(),
      _ColorSchemeKeys.onSurface: s.onSurface.toARGB32(),
      _ColorSchemeKeys.onSurfaceVariant: s.onSurfaceVariant.toARGB32(),
      _ColorSchemeKeys.outline: s.outline.toARGB32(),
      _ColorSchemeKeys.outlineVariant: s.outlineVariant.toARGB32(),
      _ColorSchemeKeys.shadow: s.shadow.toARGB32(),
      _ColorSchemeKeys.scrim: s.scrim.toARGB32(),
      _ColorSchemeKeys.inverseSurface: s.inverseSurface.toARGB32(),
      _ColorSchemeKeys.inversePrimary: s.inversePrimary.toARGB32(),
      _ColorSchemeKeys.surfaceTint: s.surfaceTint.toARGB32(),
      _ColorSchemeKeys.surfaceContainerHighest:
          s.surfaceContainerHighest.toARGB32(),
    };
  }

  static ColorScheme _schemeFromJson(Map<String, dynamic> json) {
    final Brightness brightness = (json[_ColorSchemeKeys.brightness] == 'dark')
        ? Brightness.dark
        : Brightness.light;

    final ColorScheme base = brightness == Brightness.dark
        ? PragmaColors.darkScheme
        : PragmaColors.lightScheme;

    return base.copyWith(
      primary: _readColor(json, _ColorSchemeKeys.primary, base.primary),
      onPrimary: _readColor(json, _ColorSchemeKeys.onPrimary, base.onPrimary),
      primaryContainer: _readColor(
        json,
        _ColorSchemeKeys.primaryContainer,
        base.primaryContainer,
      ),
      onPrimaryContainer: _readColor(
        json,
        _ColorSchemeKeys.onPrimaryContainer,
        base.onPrimaryContainer,
      ),
      secondary: _readColor(json, _ColorSchemeKeys.secondary, base.secondary),
      onSecondary:
          _readColor(json, _ColorSchemeKeys.onSecondary, base.onSecondary),
      secondaryContainer: _readColor(
        json,
        _ColorSchemeKeys.secondaryContainer,
        base.secondaryContainer,
      ),
      onSecondaryContainer: _readColor(
        json,
        _ColorSchemeKeys.onSecondaryContainer,
        base.onSecondaryContainer,
      ),
      tertiary: _readColor(json, _ColorSchemeKeys.tertiary, base.tertiary),
      onTertiary:
          _readColor(json, _ColorSchemeKeys.onTertiary, base.onTertiary),
      tertiaryContainer: _readColor(
        json,
        _ColorSchemeKeys.tertiaryContainer,
        base.tertiaryContainer,
      ),
      onTertiaryContainer: _readColor(
        json,
        _ColorSchemeKeys.onTertiaryContainer,
        base.onTertiaryContainer,
      ),
      error: _readColor(json, _ColorSchemeKeys.error, base.error),
      onError: _readColor(json, _ColorSchemeKeys.onError, base.onError),
      errorContainer: _readColor(
        json,
        _ColorSchemeKeys.errorContainer,
        base.errorContainer,
      ),
      onErrorContainer: _readColor(
        json,
        _ColorSchemeKeys.onErrorContainer,
        base.onErrorContainer,
      ),
      surface: _readColor(json, _ColorSchemeKeys.surface, base.surface),
      onSurface: _readColor(json, _ColorSchemeKeys.onSurface, base.onSurface),
      onSurfaceVariant: _readColor(
        json,
        _ColorSchemeKeys.onSurfaceVariant,
        base.onSurfaceVariant,
      ),
      outline: _readColor(json, _ColorSchemeKeys.outline, base.outline),
      outlineVariant: _readColor(
        json,
        _ColorSchemeKeys.outlineVariant,
        base.outlineVariant,
      ),
      shadow: _readColor(json, _ColorSchemeKeys.shadow, base.shadow),
      scrim: _readColor(json, _ColorSchemeKeys.scrim, base.scrim),
      inverseSurface: _readColor(
        json,
        _ColorSchemeKeys.inverseSurface,
        base.inverseSurface,
      ),
      inversePrimary: _readColor(
        json,
        _ColorSchemeKeys.inversePrimary,
        base.inversePrimary,
      ),
      surfaceTint:
          _readColor(json, _ColorSchemeKeys.surfaceTint, base.surfaceTint),
      surfaceContainerHighest: _readColor(
        json,
        _ColorSchemeKeys.surfaceContainerHighest,
        base.surfaceContainerHighest,
      ),
    );
  }

  static Map<String, dynamic> _textThemeToJson(TextTheme theme) {
    return <String, dynamic>{
      _TextThemeKeys.displayLarge: _textStyleToJson(theme.displayLarge),
      _TextThemeKeys.displayMedium: _textStyleToJson(theme.displayMedium),
      _TextThemeKeys.displaySmall: _textStyleToJson(theme.displaySmall),
      _TextThemeKeys.headlineLarge: _textStyleToJson(theme.headlineLarge),
      _TextThemeKeys.headlineMedium: _textStyleToJson(theme.headlineMedium),
      _TextThemeKeys.headlineSmall: _textStyleToJson(theme.headlineSmall),
      _TextThemeKeys.titleLarge: _textStyleToJson(theme.titleLarge),
      _TextThemeKeys.titleMedium: _textStyleToJson(theme.titleMedium),
      _TextThemeKeys.titleSmall: _textStyleToJson(theme.titleSmall),
      _TextThemeKeys.bodyLarge: _textStyleToJson(theme.bodyLarge),
      _TextThemeKeys.bodyMedium: _textStyleToJson(theme.bodyMedium),
      _TextThemeKeys.bodySmall: _textStyleToJson(theme.bodySmall),
      _TextThemeKeys.labelLarge: _textStyleToJson(theme.labelLarge),
      _TextThemeKeys.labelMedium: _textStyleToJson(theme.labelMedium),
      _TextThemeKeys.labelSmall: _textStyleToJson(theme.labelSmall),
    };
  }

  static TextTheme _textThemeFromJson(Map<String, dynamic> json) {
    final TextTheme base = PragmaTypography.textTheme();
    return TextTheme(
      displayLarge: _textStyleFromJson(
        json[_TextThemeKeys.displayLarge],
        fallback: base.displayLarge,
      ),
      displayMedium: _textStyleFromJson(
        json[_TextThemeKeys.displayMedium],
        fallback: base.displayMedium,
      ),
      displaySmall: _textStyleFromJson(
        json[_TextThemeKeys.displaySmall],
        fallback: base.displaySmall,
      ),
      headlineLarge: _textStyleFromJson(
        json[_TextThemeKeys.headlineLarge],
        fallback: base.headlineLarge,
      ),
      headlineMedium: _textStyleFromJson(
        json[_TextThemeKeys.headlineMedium],
        fallback: base.headlineMedium,
      ),
      headlineSmall: _textStyleFromJson(
        json[_TextThemeKeys.headlineSmall],
        fallback: base.headlineSmall,
      ),
      titleLarge: _textStyleFromJson(
        json[_TextThemeKeys.titleLarge],
        fallback: base.titleLarge,
      ),
      titleMedium: _textStyleFromJson(
        json[_TextThemeKeys.titleMedium],
        fallback: base.titleMedium,
      ),
      titleSmall: _textStyleFromJson(
        json[_TextThemeKeys.titleSmall],
        fallback: base.titleSmall,
      ),
      bodyLarge: _textStyleFromJson(
        json[_TextThemeKeys.bodyLarge],
        fallback: base.bodyLarge,
      ),
      bodyMedium: _textStyleFromJson(
        json[_TextThemeKeys.bodyMedium],
        fallback: base.bodyMedium,
      ),
      bodySmall: _textStyleFromJson(
        json[_TextThemeKeys.bodySmall],
        fallback: base.bodySmall,
      ),
      labelLarge: _textStyleFromJson(
        json[_TextThemeKeys.labelLarge],
        fallback: base.labelLarge,
      ),
      labelMedium: _textStyleFromJson(
        json[_TextThemeKeys.labelMedium],
        fallback: base.labelMedium,
      ),
      labelSmall: _textStyleFromJson(
        json[_TextThemeKeys.labelSmall],
        fallback: base.labelSmall,
      ),
    );
  }

  static Map<String, dynamic>? _textStyleToJson(TextStyle? style) {
    if (style == null) {
      return null;
    }
    return <String, dynamic>{
      _TextStyleKeys.color: style.color?.toARGB32(),
      _TextStyleKeys.fontSize: style.fontSize,
      _TextStyleKeys.fontWeight: style.fontWeight?.value,
      _TextStyleKeys.height: style.height,
      _TextStyleKeys.letterSpacing: style.letterSpacing,
      _TextStyleKeys.fontFamily: style.fontFamily,
    };
  }

  static TextStyle? _textStyleFromJson(
    Object? raw, {
    required TextStyle? fallback,
  }) {
    if (raw is! Map<String, dynamic>) {
      return fallback;
    }

    final Color? color = _readNullableColor(raw[_TextStyleKeys.color]);
    final double? fontSize = _readNullableDouble(raw[_TextStyleKeys.fontSize]);
    final int? fontWeightValue =
        _readNullableInt(raw[_TextStyleKeys.fontWeight]);
    final FontWeight? fontWeight = fontWeightValue == null
        ? null
        : FontWeight.values[fontWeightValue ~/ 100 - 1];
    final double? height = _readNullableDouble(raw[_TextStyleKeys.height]);
    final double? letterSpacing =
        _readNullableDouble(raw[_TextStyleKeys.letterSpacing]);
    final String? fontFamily = raw[_TextStyleKeys.fontFamily] as String?;

    final TextStyle base = fallback ?? const TextStyle();
    return base.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      fontFamily: fontFamily,
    );
  }

  static Color _readColor(
    Map<String, dynamic> json,
    String key,
    Color fallback,
  ) {
    final Object? value = json[key];
    final Color? parsed = _readNullableColor(value);
    return parsed ?? fallback;
  }

  static Color? _readNullableColor(Object? raw) {
    final int? value = _readNullableInt(raw);
    if (value == null) {
      return null;
    }
    return Color(value);
  }

  static int? _readNullableInt(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.round();
    }
    if (raw is String) {
      return int.tryParse(raw.trim()) ?? double.tryParse(raw.trim())?.round();
    }
    return null;
  }

  static double? _readNullableDouble(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is double) {
      return raw;
    }
    if (raw is num) {
      return raw.toDouble();
    }
    if (raw is String) {
      return double.tryParse(raw.trim());
    }
    return null;
  }
}
