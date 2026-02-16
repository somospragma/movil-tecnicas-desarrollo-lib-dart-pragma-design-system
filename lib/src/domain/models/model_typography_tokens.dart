import 'package:flutter/foundation.dart';

abstract final class ModelTypographyTokenStyleKeys {
  static const String fontSize = 'fontSize';
  static const String lineHeight = 'lineHeight';
  static const String fontWeight = 'fontWeight';
  static const String letterSpacing = 'letterSpacing';
}

@immutable
class ModelTypographyTokenStyle {
  const ModelTypographyTokenStyle({
    required this.fontSize,
    required this.lineHeight,
    required this.fontWeight,
    this.letterSpacing,
  });

  factory ModelTypographyTokenStyle.fromJson(Map<String, dynamic> json) {
    return ModelTypographyTokenStyle(
      fontSize: _toDouble(json[ModelTypographyTokenStyleKeys.fontSize]),
      lineHeight: _toDouble(json[ModelTypographyTokenStyleKeys.lineHeight]),
      fontWeight: _toInt(json[ModelTypographyTokenStyleKeys.fontWeight]),
      letterSpacing:
          _toNullableDouble(json[ModelTypographyTokenStyleKeys.letterSpacing]),
    ).._validate();
  }

  final double fontSize;
  final double lineHeight;
  final int fontWeight;
  final double? letterSpacing;

  ModelTypographyTokenStyle copyWith({
    double? fontSize,
    double? lineHeight,
    int? fontWeight,
    double? letterSpacing,
  }) {
    return ModelTypographyTokenStyle(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontWeight: fontWeight ?? this.fontWeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    ).._validate();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        ModelTypographyTokenStyleKeys.fontSize: fontSize,
        ModelTypographyTokenStyleKeys.lineHeight: lineHeight,
        ModelTypographyTokenStyleKeys.fontWeight: fontWeight,
        ModelTypographyTokenStyleKeys.letterSpacing: letterSpacing,
      };

  void _validate() {
    if (!fontSize.isFinite || fontSize <= 0) {
      throw RangeError('fontSize must be > 0');
    }
    if (!lineHeight.isFinite || lineHeight <= 0) {
      throw RangeError('lineHeight must be > 0');
    }
    if (fontWeight < 100 || fontWeight > 900) {
      throw RangeError('fontWeight must be in 100..900');
    }
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ??
          double.tryParse(value.trim())?.round() ??
          0;
    }
    return 0;
  }

  static double? _toNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ModelTypographyTokenStyle &&
        other.fontSize == fontSize &&
        other.lineHeight == lineHeight &&
        other.fontWeight == fontWeight &&
        other.letterSpacing == letterSpacing;
  }

  @override
  int get hashCode =>
      Object.hash(fontSize, lineHeight, fontWeight, letterSpacing);
}

abstract final class ModelTypographyTokensKeys {
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

@immutable
class ModelTypographyTokens {
  const ModelTypographyTokens({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  factory ModelTypographyTokens.pragmaDefault() {
    return const ModelTypographyTokens(
      displayLarge: ModelTypographyTokenStyle(
        fontSize: 72,
        lineHeight: 76,
        fontWeight: 600,
      ),
      displayMedium: ModelTypographyTokenStyle(
        fontSize: 60,
        lineHeight: 64,
        fontWeight: 600,
      ),
      displaySmall: ModelTypographyTokenStyle(
        fontSize: 46,
        lineHeight: 50,
        fontWeight: 600,
      ),
      headlineLarge: ModelTypographyTokenStyle(
        fontSize: 36,
        lineHeight: 40,
        fontWeight: 600,
      ),
      headlineMedium: ModelTypographyTokenStyle(
        fontSize: 30,
        lineHeight: 34,
        fontWeight: 600,
      ),
      headlineSmall: ModelTypographyTokenStyle(
        fontSize: 26,
        lineHeight: 30,
        fontWeight: 600,
      ),
      titleLarge: ModelTypographyTokenStyle(
        fontSize: 21,
        lineHeight: 25,
        fontWeight: 600,
      ),
      titleMedium: ModelTypographyTokenStyle(
        fontSize: 16,
        lineHeight: 20,
        fontWeight: 600,
      ),
      titleSmall: ModelTypographyTokenStyle(
        fontSize: 30,
        lineHeight: 34,
        fontWeight: 400,
      ),
      bodyLarge: ModelTypographyTokenStyle(
        fontSize: 21,
        lineHeight: 25,
        fontWeight: 400,
      ),
      bodyMedium: ModelTypographyTokenStyle(
        fontSize: 16,
        lineHeight: 20,
        fontWeight: 400,
      ),
      bodySmall: ModelTypographyTokenStyle(
        fontSize: 14,
        lineHeight: 18,
        fontWeight: 400,
      ),
      labelLarge: ModelTypographyTokenStyle(
        fontSize: 12,
        lineHeight: 16,
        fontWeight: 700,
      ),
      labelMedium: ModelTypographyTokenStyle(
        fontSize: 12,
        lineHeight: 16,
        fontWeight: 400,
      ),
      labelSmall: ModelTypographyTokenStyle(
        fontSize: 10,
        lineHeight: 14,
        fontWeight: 400,
      ),
    );
  }

  factory ModelTypographyTokens.fromJson(Map<String, dynamic> json) {
    ModelTypographyTokenStyle read(String key) {
      final Object? raw = json[key];
      if (raw is! Map<String, dynamic>) {
        throw FormatException('Expected map for $key');
      }
      return ModelTypographyTokenStyle.fromJson(raw);
    }

    return ModelTypographyTokens(
      displayLarge: read(ModelTypographyTokensKeys.displayLarge),
      displayMedium: read(ModelTypographyTokensKeys.displayMedium),
      displaySmall: read(ModelTypographyTokensKeys.displaySmall),
      headlineLarge: read(ModelTypographyTokensKeys.headlineLarge),
      headlineMedium: read(ModelTypographyTokensKeys.headlineMedium),
      headlineSmall: read(ModelTypographyTokensKeys.headlineSmall),
      titleLarge: read(ModelTypographyTokensKeys.titleLarge),
      titleMedium: read(ModelTypographyTokensKeys.titleMedium),
      titleSmall: read(ModelTypographyTokensKeys.titleSmall),
      bodyLarge: read(ModelTypographyTokensKeys.bodyLarge),
      bodyMedium: read(ModelTypographyTokensKeys.bodyMedium),
      bodySmall: read(ModelTypographyTokensKeys.bodySmall),
      labelLarge: read(ModelTypographyTokensKeys.labelLarge),
      labelMedium: read(ModelTypographyTokensKeys.labelMedium),
      labelSmall: read(ModelTypographyTokensKeys.labelSmall),
    );
  }

  final ModelTypographyTokenStyle displayLarge;
  final ModelTypographyTokenStyle displayMedium;
  final ModelTypographyTokenStyle displaySmall;
  final ModelTypographyTokenStyle headlineLarge;
  final ModelTypographyTokenStyle headlineMedium;
  final ModelTypographyTokenStyle headlineSmall;
  final ModelTypographyTokenStyle titleLarge;
  final ModelTypographyTokenStyle titleMedium;
  final ModelTypographyTokenStyle titleSmall;
  final ModelTypographyTokenStyle bodyLarge;
  final ModelTypographyTokenStyle bodyMedium;
  final ModelTypographyTokenStyle bodySmall;
  final ModelTypographyTokenStyle labelLarge;
  final ModelTypographyTokenStyle labelMedium;
  final ModelTypographyTokenStyle labelSmall;

  ModelTypographyTokens copyWith({
    ModelTypographyTokenStyle? displayLarge,
    ModelTypographyTokenStyle? displayMedium,
    ModelTypographyTokenStyle? displaySmall,
    ModelTypographyTokenStyle? headlineLarge,
    ModelTypographyTokenStyle? headlineMedium,
    ModelTypographyTokenStyle? headlineSmall,
    ModelTypographyTokenStyle? titleLarge,
    ModelTypographyTokenStyle? titleMedium,
    ModelTypographyTokenStyle? titleSmall,
    ModelTypographyTokenStyle? bodyLarge,
    ModelTypographyTokenStyle? bodyMedium,
    ModelTypographyTokenStyle? bodySmall,
    ModelTypographyTokenStyle? labelLarge,
    ModelTypographyTokenStyle? labelMedium,
    ModelTypographyTokenStyle? labelSmall,
  }) {
    return ModelTypographyTokens(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        ModelTypographyTokensKeys.displayLarge: displayLarge.toJson(),
        ModelTypographyTokensKeys.displayMedium: displayMedium.toJson(),
        ModelTypographyTokensKeys.displaySmall: displaySmall.toJson(),
        ModelTypographyTokensKeys.headlineLarge: headlineLarge.toJson(),
        ModelTypographyTokensKeys.headlineMedium: headlineMedium.toJson(),
        ModelTypographyTokensKeys.headlineSmall: headlineSmall.toJson(),
        ModelTypographyTokensKeys.titleLarge: titleLarge.toJson(),
        ModelTypographyTokensKeys.titleMedium: titleMedium.toJson(),
        ModelTypographyTokensKeys.titleSmall: titleSmall.toJson(),
        ModelTypographyTokensKeys.bodyLarge: bodyLarge.toJson(),
        ModelTypographyTokensKeys.bodyMedium: bodyMedium.toJson(),
        ModelTypographyTokensKeys.bodySmall: bodySmall.toJson(),
        ModelTypographyTokensKeys.labelLarge: labelLarge.toJson(),
        ModelTypographyTokensKeys.labelMedium: labelMedium.toJson(),
        ModelTypographyTokensKeys.labelSmall: labelSmall.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ModelTypographyTokens &&
        other.displayLarge == displayLarge &&
        other.displayMedium == displayMedium &&
        other.displaySmall == displaySmall &&
        other.headlineLarge == headlineLarge &&
        other.headlineMedium == headlineMedium &&
        other.headlineSmall == headlineSmall &&
        other.titleLarge == titleLarge &&
        other.titleMedium == titleMedium &&
        other.titleSmall == titleSmall &&
        other.bodyLarge == bodyLarge &&
        other.bodyMedium == bodyMedium &&
        other.bodySmall == bodySmall &&
        other.labelLarge == labelLarge &&
        other.labelMedium == labelMedium &&
        other.labelSmall == labelSmall;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
        displayLarge,
        displayMedium,
        displaySmall,
        headlineLarge,
        headlineMedium,
        headlineSmall,
        titleLarge,
        titleMedium,
        titleSmall,
        bodyLarge,
        bodyMedium,
        bodySmall,
        labelLarge,
        labelMedium,
        labelSmall,
      ]);
}
