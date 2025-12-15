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

  /// Ordered keys commonly used across color schemes.
  static const List<String> coreColorKeys = <String>[
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
    'error',
    'onError',
    'background',
    'onBackground',
    'surface',
    'onSurface',
    'surfaceVariant',
    'onSurfaceVariant',
    'inverseSurface',
    'onInverseSurface',
    'inversePrimary',
    'surfaceTint',
    'outline',
    'outlineVariant',
    'shadow',
    'scrim',
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

  /// Picks a core color token by key, falling back to a neutral swatch.
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

  static Map<String, ModelColorToken> _defaultColorTokens() {
    return <String, ModelColorToken>{
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
      'error': ModelColorToken(label: 'Error', color: '#B3261E'),
      'onError': ModelColorToken(label: 'On error', color: '#FFFFFF'),
      'background': ModelColorToken(label: 'Background', color: '#FFFBFE'),
      'onBackground': ModelColorToken(label: 'On background', color: '#1C1B1F'),
      'surface': ModelColorToken(label: 'Surface', color: '#FFFBFE'),
      'onSurface': ModelColorToken(label: 'On surface', color: '#1C1B1F'),
      'surfaceVariant':
          ModelColorToken(label: 'Surface variant', color: '#E7E0EC'),
      'onSurfaceVariant':
          ModelColorToken(label: 'On surface variant', color: '#49454F'),
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
