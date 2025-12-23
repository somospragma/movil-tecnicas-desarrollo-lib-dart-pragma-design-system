import 'package:flutter/foundation.dart';

import 'model_color_token.dart';

/// Brightness options supported by [ModelThemePragma].
enum ThemeBrightness { light, dark }

/// Immutable data structure that represents a full Pragma theme definition.
@immutable
class ModelThemePragma {
  factory ModelThemePragma({
    Map<String, ModelColorToken>? colorTokens,
    Map<String, ModelColorToken>? textColorTokens,
    String typographyFamily = _defaultTypography,
    ThemeBrightness brightness = ThemeBrightness.light,
  }) {
    return ModelThemePragma._(
      // NOTE: tokens may be partial; the ThemeData builder must apply defaults
      // using ColorScheme.light()/dark() and only override provided keys.
      colorTokens: _sanitizeTokens(colorTokens ?? _defaultColorTokens()),
      textColorTokens:
          _sanitizeTokens(textColorTokens ?? _defaultTextColorTokens()),
      typographyFamily: typographyFamily.trim().isEmpty
          ? _defaultTypography
          : typographyFamily.trim(),
      brightness: brightness,
    );
  }

  /// Builds a theme model from JSON.
  factory ModelThemePragma.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ModelThemePragma();
    }

    return ModelThemePragma(
      colorTokens: _parseTokenMap(json[_colorTokensKey]),
      textColorTokens: _parseTokenMap(json[_textColorTokensKey]),
      typographyFamily: json[_typographyKey]?.toString() ?? _defaultTypography,
      brightness: _parseBrightness(json[_brightnessKey]),
    );
  }

  const ModelThemePragma._({
    required this.colorTokens,
    required this.textColorTokens,
    required this.typographyFamily,
    required this.brightness,
  });

  static const String _colorTokensKey = 'colorTokens';
  static const String _textColorTokensKey = 'textColorTokens';
  static const String _typographyKey = 'typographyFamily';
  static const String _brightnessKey = 'brightness';
  static const String _defaultTypography = 'Poppins';

  /// Full set of keys supported by Flutter's Material 3 [ColorScheme].
  ///
  /// Notes:
  /// - Some keys are deprecated in Flutter but kept here for backward-compat:
  ///   `background`, `onBackground`, `surfaceVariant`.
  /// - Tokens can be partial; the builder should merge them over a default
  ///   ColorScheme.light()/dark() so missing values never fall back to black.
  static const List<String> coreColorKeys = <String>[
    // Core
    'primary',
    'onPrimary',
    'primaryContainer',
    'onPrimaryContainer',
    'secondary',
    'onSecondary',
    'secondaryContainer',
    'onSecondaryContainer',
    'tertiary',
    'onTertiary',
    'tertiaryContainer',
    'onTertiaryContainer',

    // Error
    'error',
    'onError',
    'errorContainer',
    'onErrorContainer',

    // Surfaces (and deprecated ones)
    'surface',
    'onSurface',
    'surfaceVariant', // deprecated in Flutter (kept for backward-compat)
    'onSurfaceVariant',
    'background', // deprecated in Flutter (kept for backward-compat)
    'onBackground', // deprecated in Flutter (kept for backward-compat)

    // Surface containers (Material 3)
    'surfaceDim',
    'surfaceBright',
    'surfaceContainerLowest',
    'surfaceContainerLow',
    'surfaceContainer',
    'surfaceContainerHigh',
    'surfaceContainerHighest',

    // Other roles
    'inverseSurface',
    'onInverseSurface',
    'inversePrimary',
    'surfaceTint',
    'outline',
    'outlineVariant',
    'shadow',
    'scrim',

    // Fixed roles (Material 3)
    'primaryFixed',
    'primaryFixedDim',
    'onPrimaryFixed',
    'onPrimaryFixedVariant',
    'secondaryFixed',
    'secondaryFixedDim',
    'onSecondaryFixed',
    'onSecondaryFixedVariant',
    'tertiaryFixed',
    'tertiaryFixedDim',
    'onTertiaryFixed',
    'onTertiaryFixedVariant',
  ];

  /// Ordered keys used to colorize text styles.
  static const List<String> textColorKeys = <String>[
    'display',
    'body',
    'label',
  ];

  /// Complete set of color tokens employed to craft a [ThemeData].
  final Map<String, ModelColorToken> colorTokens;

  /// Dedicated colors for text styles within the [TextTheme].
  final Map<String, ModelColorToken> textColorTokens;

  /// Google Fonts family applied to the preview text styles.
  final String typographyFamily;

  /// Base brightness that influences the generated [ThemeData].
  final ThemeBrightness brightness;

  /// Serializes this model into a JSON representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _colorTokensKey: _encodeTokenMap(colorTokens),
      _textColorTokensKey: _encodeTokenMap(textColorTokens),
      _typographyKey: typographyFamily,
      _brightnessKey: brightness.name,
    };
  }

  /// Returns a copy with optional overrides.
  ModelThemePragma copyWith({
    Map<String, ModelColorToken>? colorTokens,
    Map<String, ModelColorToken>? textColorTokens,
    String? typographyFamily,
    ThemeBrightness? brightness,
  }) {
    return ModelThemePragma(
      colorTokens: colorTokens ?? this.colorTokens,
      textColorTokens: textColorTokens ?? this.textColorTokens,
      typographyFamily: typographyFamily ?? this.typographyFamily,
      brightness: brightness ?? this.brightness,
    );
  }

  /// Picks a color token by key.
  ///
  /// If missing, returns a neutral placeholder. Prefer using the Theme builder
  /// to merge tokens over ColorScheme defaults so missing keys never become black.
  ModelColorToken colorFor(String key) {
    return colorTokens[key] ?? ModelColorToken(label: key, color: '#000000');
  }

  /// Picks a text color token by key, falling back to a neutral swatch.
  ModelColorToken textColorFor(String key) {
    return textColorTokens[key] ??
        ModelColorToken(label: key, color: '#000000');
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelThemePragma &&
            runtimeType == other.runtimeType &&
            mapEquals(colorTokens, other.colorTokens) &&
            mapEquals(textColorTokens, other.textColorTokens) &&
            typographyFamily == other.typographyFamily &&
            brightness == other.brightness;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(
          colorTokens.entries.map(
            (MapEntry<String, ModelColorToken> entry) =>
                Object.hash(entry.key, entry.value),
          ),
        ),
        Object.hashAll(
          textColorTokens.entries.map(
            (MapEntry<String, ModelColorToken> entry) =>
                Object.hash(entry.key, entry.value),
          ),
        ),
        typographyFamily,
        brightness,
      );

  static Map<String, ModelColorToken> _sanitizeTokens(
    Map<String, ModelColorToken> source,
  ) {
    return Map<String, ModelColorToken>.unmodifiable(
      source.map((String key, ModelColorToken value) {
        return MapEntry<String, ModelColorToken>(
          key,
          ModelColorToken(label: value.label, color: value.color),
        );
      }),
    );
  }

  /// Minimal defaults (can be overridden by tokens or replaced by builder fallbacks).
  ///
  /// Important: the Theme builder MUST merge missing keys from ColorScheme defaults.
  static Map<String, ModelColorToken> _defaultColorTokens() {
    return <String, ModelColorToken>{
      // Core (same as your previous set)
      'primary': ModelColorToken(label: 'Primary', color: '#6750A4'),
      'onPrimary': ModelColorToken(label: 'On primary', color: '#FFFFFF'),
      'primaryContainer':
          ModelColorToken(label: 'Primary container', color: '#EADDFF'),
      'onPrimaryContainer':
          ModelColorToken(label: 'On primary container', color: '#21005D'),
      'secondary': ModelColorToken(label: 'Secondary', color: '#625B71'),
      'onSecondary': ModelColorToken(label: 'On secondary', color: '#FFFFFF'),
      'secondaryContainer':
          ModelColorToken(label: 'Secondary container', color: '#E8DEF8'),
      'onSecondaryContainer':
          ModelColorToken(label: 'On secondary container', color: '#1D192B'),
      'tertiary': ModelColorToken(label: 'Tertiary', color: '#7D5260'),
      'onTertiary': ModelColorToken(label: 'On tertiary', color: '#FFFFFF'),
      'tertiaryContainer':
          ModelColorToken(label: 'Tertiary container', color: '#FFD8E4'),
      'onTertiaryContainer':
          ModelColorToken(label: 'On tertiary container', color: '#31111D'),

      // Error
      'error': ModelColorToken(label: 'Error', color: '#B3261E'),
      'onError': ModelColorToken(label: 'On error', color: '#FFFFFF'),
      'errorContainer':
          ModelColorToken(label: 'Error container', color: '#F9DEDC'),
      'onErrorContainer':
          ModelColorToken(label: 'On error container', color: '#410E0B'),

      // Surfaces (plus deprecated)
      'background': ModelColorToken(label: 'Background', color: '#FFFBFE'),
      'onBackground': ModelColorToken(label: 'On background', color: '#1C1B1F'),
      'surface': ModelColorToken(label: 'Surface', color: '#FFFBFE'),
      'onSurface': ModelColorToken(label: 'On surface', color: '#1C1B1F'),
      'surfaceVariant': ModelColorToken(
        label: 'Surface variant (deprecated)',
        color: '#E7E0EC',
      ),
      'onSurfaceVariant':
          ModelColorToken(label: 'On surface variant', color: '#49454F'),

      // Surface containers (reasonable defaults; builder will still fallback properly)
      'surfaceDim': ModelColorToken(label: 'Surface dim', color: '#DED8E1'),
      'surfaceBright':
          ModelColorToken(label: 'Surface bright', color: '#FFFBFE'),
      'surfaceContainerLowest':
          ModelColorToken(label: 'Surface container lowest', color: '#FFFFFF'),
      'surfaceContainerLow':
          ModelColorToken(label: 'Surface container low', color: '#F7F2FA'),
      'surfaceContainer':
          ModelColorToken(label: 'Surface container', color: '#F3EDF7'),
      'surfaceContainerHigh':
          ModelColorToken(label: 'Surface container high', color: '#ECE6F0'),
      'surfaceContainerHighest':
          ModelColorToken(label: 'Surface container highest', color: '#E6E0E9'),

      // Other roles
      'inverseSurface':
          ModelColorToken(label: 'Inverse surface', color: '#313033'),
      'onInverseSurface':
          ModelColorToken(label: 'On inverse surface', color: '#F4EFF4'),
      'inversePrimary':
          ModelColorToken(label: 'Inverse primary', color: '#D0BCFF'),
      'surfaceTint': ModelColorToken(label: 'Surface tint', color: '#6750A4'),
      'outline': ModelColorToken(label: 'Outline', color: '#79747E'),
      'outlineVariant':
          ModelColorToken(label: 'Outline variant', color: '#C4C7C5'),
      'shadow': ModelColorToken(label: 'Shadow', color: '#000000'),
      'scrim': ModelColorToken(label: 'Scrim', color: '#000000'),

      // Fixed roles (defaults are “safe”; builder fallbacks are the source of truth)
      'primaryFixed': ModelColorToken(label: 'Primary fixed', color: '#EADDFF'),
      'primaryFixedDim':
          ModelColorToken(label: 'Primary fixed dim', color: '#D0BCFF'),
      'onPrimaryFixed':
          ModelColorToken(label: 'On primary fixed', color: '#21005D'),
      'onPrimaryFixedVariant':
          ModelColorToken(label: 'On primary fixed variant', color: '#4F378B'),

      'secondaryFixed':
          ModelColorToken(label: 'Secondary fixed', color: '#E8DEF8'),
      'secondaryFixedDim':
          ModelColorToken(label: 'Secondary fixed dim', color: '#CCC2DC'),
      'onSecondaryFixed':
          ModelColorToken(label: 'On secondary fixed', color: '#1D192B'),
      'onSecondaryFixedVariant': ModelColorToken(
        label: 'On secondary fixed variant',
        color: '#4A4458',
      ),

      'tertiaryFixed':
          ModelColorToken(label: 'Tertiary fixed', color: '#FFD8E4'),
      'tertiaryFixedDim':
          ModelColorToken(label: 'Tertiary fixed dim', color: '#EFB8C8'),
      'onTertiaryFixed':
          ModelColorToken(label: 'On tertiary fixed', color: '#31111D'),
      'onTertiaryFixedVariant':
          ModelColorToken(label: 'On tertiary fixed variant', color: '#633B48'),
    };
  }

  static Map<String, ModelColorToken> _defaultTextColorTokens() {
    return <String, ModelColorToken>{
      'display': ModelColorToken(label: 'Display color', color: '#1C1B1F'),
      'body': ModelColorToken(label: 'Body color', color: '#49454F'),
      'label': ModelColorToken(label: 'Label color', color: '#6750A4'),
    };
  }

  static Map<String, ModelColorToken> _parseTokenMap(dynamic value) {
    if (value is Map) {
      final Map<String, ModelColorToken> result = <String, ModelColorToken>{};
      value.forEach((dynamic key, dynamic token) {
        final Map<String, dynamic>? json =
            token is Map ? token.cast<String, dynamic>() : null;
        result[key.toString()] = ModelColorToken.fromJson(json);
      });
      return result;
    }
    return <String, ModelColorToken>{};
  }

  static Map<String, dynamic> _encodeTokenMap(
    Map<String, ModelColorToken> tokens,
  ) {
    return tokens.map(
      (String key, ModelColorToken value) =>
          MapEntry<String, Map<String, dynamic>>(key, value.toJson()),
    );
  }

  static ThemeBrightness _parseBrightness(dynamic value) {
    if (value is String) {
      return ThemeBrightness.values.firstWhere(
        (ThemeBrightness element) => element.name == value,
        orElse: () => ThemeBrightness.light,
      );
    }
    return ThemeBrightness.light;
  }
}
