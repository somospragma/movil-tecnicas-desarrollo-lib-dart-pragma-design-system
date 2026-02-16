import 'package:flutter/foundation.dart';

/// Adapted from `jocaaguraarchetype`.
///
/// Thanks to the `grupo-jocaagura/jocaaguraarchetype` team for the original
/// model and base structure:
/// https://github.com/grupo-jocaagura/jocaaguraarchetype/blob/develop/lib/domain/models/model_ds_extended_tokens.dart
/// Defines stable JSON keys for [DsExtendedTokens].
///
/// This is a centralized registry of keys to ensure:
/// - Export/import consistency.
/// - Validation of required keys during [DsExtendedTokens.fromJson].
///
/// The [all] list contains every key that must exist in a valid JSON payload.
///
/// Notes:
/// - Keys are intentionally stable; avoid renaming.
/// - Adding a new key is a breaking change for strict JSON import.
abstract class DsExtendedTokensKeys {
  static const String spacingXs = 'spacingXs';
  static const String spacingSm = 'spacingSm';
  static const String spacing = 'spacing';
  static const String spacingLg = 'spacingLg';
  static const String spacingXl = 'spacingXl';
  static const String spacingXXl = 'spacingXXl';

  static const String borderRadiusXs = 'borderRadiusXs';
  static const String borderRadiusSm = 'borderRadiusSm';
  static const String borderRadius = 'borderRadius';
  static const String borderRadiusLg = 'borderRadiusLg';
  static const String borderRadiusXl = 'borderRadiusXl';
  static const String borderRadiusXXl = 'borderRadiusXXl';

  static const String elevationXs = 'elevationXs';
  static const String elevationSm = 'elevationSm';
  static const String elevation = 'elevation';
  static const String elevationLg = 'elevationLg';
  static const String elevationXl = 'elevationXl';
  static const String elevationXXl = 'elevationXXl';

  /// Values intended to be used with `Color.withOpacity(x)` or `withAlpha(...)` conversions.
  /// Range: 0..1.
  static const String withAlphaXs = 'withAlphaXs';
  static const String withAlphaSm = 'withAlphaSm';
  static const String withAlpha = 'withAlpha';
  static const String withAlphaLg = 'withAlphaLg';
  static const String withAlphaXl = 'withAlphaXl';
  static const String withAlphaXXl = 'withAlphaXXl';

  static const String animationDurationShort = 'animationDurationShort';
  static const String animationDuration = 'animationDuration';
  static const String animationDurationLong = 'animationDurationLong';

  static const List<String> all = <String>[
    spacingXs,
    spacingSm,
    spacing,
    spacingLg,
    spacingXl,
    spacingXXl,
    borderRadiusXs,
    borderRadiusSm,
    borderRadius,
    borderRadiusLg,
    borderRadiusXl,
    borderRadiusXXl,
    elevationXs,
    elevationSm,
    elevation,
    elevationLg,
    elevationXl,
    elevationXXl,
    withAlphaXs,
    withAlphaSm,
    withAlpha,
    withAlphaLg,
    withAlphaXl,
    withAlphaXXl,
    animationDurationShort,
    animationDuration,
    animationDurationLong,
  ];
}

/// Represents a set of extended Design System tokens.
///
/// This model groups commonly needed numeric tokens:
/// - Spacing scale (xs..xxl)
/// - Border radius scale (xs..xxl)
/// - Elevation scale (xs..xxl)
/// - Alpha scale for color opacity (xs..xxl) in the 0..1 range
/// - Animation durations (short/regular/long)
///
/// The instance is immutable and self-validating. Any constructor that builds
/// an instance will call an internal validation step.
///
/// Functional example:
/// ```dart
/// void main() {
///   final DsExtendedTokens tokens = DsExtendedTokens.fromFactor(
///     spacingFactor: 2.0,
///     initialSpacing: 4.0,
///     borderRadiusFactor: 2.0,
///     initialBorderRadius: 2.0,
///     elevationFactor: 2.0,
///     initialElevation: 1.0,
///     withAlphaFactor: 1.5,
///     initialWithAlpha: 0.04,
///     animationDurationFactor: 3,
///     initialAnimationDuration: 100.0,
///   );
///
///   final Map<String, dynamic> json = tokens.toJson();
///   final DsExtendedTokens restored = DsExtendedTokens.fromJson(json);
///
///   // Round-trip safety (should be true for the same values).
///   assert(tokens == restored);
///   print(restored.spacing); // e.g. 16.0
/// }
/// ```
///
/// Contracts:
/// - Spacing, radius and elevation values must be finite and >= 0.
/// - `withAlpha*` values must be finite and within 0..1.
/// - Each scale must be ascending (xs <= sm <= ... <= xxl).
/// - Durations must be >= 0 and ascending:
///   short <= regular <= long.
///
/// Throws:
/// - [RangeError] if any contract is violated.
/// - [FormatException] from [fromJson] if any required key is missing.
@immutable
class DsExtendedTokens {
  const DsExtendedTokens({
    this.spacingXs = 4.0,
    this.spacingSm = 8.0,
    this.spacing = 16.0,
    this.spacingLg = 24.0,
    this.spacingXl = 32.0,
    this.spacingXXl = 64.0,
    this.borderRadiusXs = 2.0,
    this.borderRadiusSm = 4.0,
    this.borderRadius = 8.0,
    this.borderRadiusLg = 12.0,
    this.borderRadiusXl = 16.0,
    this.borderRadiusXXl = 24.0,
    this.elevationXs = 0.0,
    this.elevationSm = 1.0,
    this.elevation = 3.0,
    this.elevationLg = 6.0,
    this.elevationXl = 9.0,
    this.elevationXXl = 12.0,
    this.withAlphaXs = 0.04,
    this.withAlphaSm = 0.12,
    this.withAlpha = 0.16,
    this.withAlphaLg = 0.24,
    this.withAlphaXl = 0.32,
    this.withAlphaXXl = 0.40,
    this.animationDurationShort = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationDurationLong = const Duration(milliseconds: 800),
  });

  /// Builds a token set using geometric progression factors.
  ///
  /// Notes:
  /// - Spacing / radius / elevation grow by multiplying the previous step by a factor.
  /// - `withAlpha*` grows upwards but is clamped into 0..1.
  /// - Durations are derived from `initialAnimationDuration` and `animationDurationFactor`.
  ///
  /// Parameters:
  /// - `spacingFactor`, `borderRadiusFactor`, `elevationFactor`:
  ///   Multipliers for each scale.
  /// - `initialSpacing`, `initialBorderRadius`, `initialElevation`:
  ///   The base value for the `*Xs` token.
  /// - `withAlphaFactor`:
  ///   Multiplier used for alpha tokens. Values are clamped into 0..1.
  /// - `initialWithAlpha`:
  ///   Base alpha used for `withAlphaXs` (0..1).
  /// - `animationDurationFactor`:
  ///   Multiplier applied to durations. `long = base * factor^2`.
  /// - `initialAnimationDuration`:
  ///   Base duration (milliseconds) used for `animationDurationShort`.
  ///
  /// Throws:
  /// - [RangeError] if the generated values violate the contracts
  ///   (non-finite values, negatives, non-ascending scales, invalid alpha range, etc.).
  factory DsExtendedTokens.fromFactor({
    double spacingFactor = 2.0,
    double initialSpacing = 4.0,
    double borderRadiusFactor = 2.0,
    double initialBorderRadius = 2.0,
    double elevationFactor = 2.0,
    double initialElevation = 1.0,

    /// ⚠️ `withAlpha` grows upward (0..1), so factor should be > 1 (e.g. 1.5 or 1.25).
    double withAlphaFactor = 1.5,
    double initialWithAlpha = 0.04,
    int animationDurationFactor = 3,
    double initialAnimationDuration = 100.0,
  }) {
    double pNumber(double base, double factor, int exp) {
      double out = base;
      for (int i = 0; i < exp; i++) {
        out *= factor;
      }
      return out;
    }

    int ms(double x) => x.round();

    final DsExtendedTokens out = DsExtendedTokens(
      spacingXs: initialSpacing,
      spacingSm: pNumber(initialSpacing, spacingFactor, 1),
      spacing: pNumber(initialSpacing, spacingFactor, 2),
      spacingLg: pNumber(initialSpacing, spacingFactor, 3),
      spacingXl: pNumber(initialSpacing, spacingFactor, 4),
      spacingXXl: pNumber(initialSpacing, spacingFactor, 5),
      borderRadiusXs: initialBorderRadius,
      borderRadiusSm: pNumber(initialBorderRadius, borderRadiusFactor, 1),
      borderRadius: pNumber(initialBorderRadius, borderRadiusFactor, 2),
      borderRadiusLg: pNumber(initialBorderRadius, borderRadiusFactor, 3),
      borderRadiusXl: pNumber(initialBorderRadius, borderRadiusFactor, 4),
      borderRadiusXXl: pNumber(initialBorderRadius, borderRadiusFactor, 5),
      elevationXs: initialElevation,
      elevationSm: pNumber(initialElevation, elevationFactor, 1),
      elevation: pNumber(initialElevation, elevationFactor, 2),
      elevationLg: pNumber(initialElevation, elevationFactor, 3),
      elevationXl: pNumber(initialElevation, elevationFactor, 4),
      elevationXXl: pNumber(initialElevation, elevationFactor, 5),
      withAlphaXs: initialWithAlpha,
      withAlphaSm: _toDouble(
        pNumber(initialWithAlpha, withAlphaFactor, 1).clamp(0.0, 1.0),
      ),
      withAlpha: _toDouble(
        pNumber(initialWithAlpha, withAlphaFactor, 2).clamp(0.0, 1.0),
      ),
      withAlphaLg: _toDouble(
        pNumber(initialWithAlpha, withAlphaFactor, 3).clamp(0.0, 1.0),
      ),
      withAlphaXl: _toDouble(
        pNumber(initialWithAlpha, withAlphaFactor, 4).clamp(0.0, 1.0),
      ),
      withAlphaXXl: _toDouble(
        pNumber(initialWithAlpha, withAlphaFactor, 5).clamp(0.0, 1.0),
      ),
      animationDurationShort:
          Duration(milliseconds: ms(initialAnimationDuration)),
      animationDuration: Duration(
        milliseconds: ms(initialAnimationDuration * animationDurationFactor),
      ),
      animationDurationLong: Duration(
        milliseconds: ms(
          initialAnimationDuration *
              animationDurationFactor *
              animationDurationFactor,
        ),
      ),
    );

    out._validate();
    return out;
  }

  /// Builds a token set from a JSON map.
  ///
  /// This parser is strict: all keys from [DsExtendedTokensKeys.all]
  /// must be present, otherwise a [FormatException] is thrown.
  ///
  /// Throws:
  /// - [FormatException] if a required key is missing.
  /// - [RangeError] if any parsed value violates the contracts.
  factory DsExtendedTokens.fromJson(Map<String, dynamic> json) {
    for (final String key in DsExtendedTokensKeys.all) {
      if (!json.containsKey(key)) {
        throw FormatException('Missing key: $key');
      }
    }

    double doubleNumber(String key) => _toDouble(json[key]);
    int integerNumber(String key) => _toInteger(json[key]);

    final DsExtendedTokens out = DsExtendedTokens(
      spacingXs: doubleNumber(DsExtendedTokensKeys.spacingXs),
      spacingSm: doubleNumber(DsExtendedTokensKeys.spacingSm),
      spacing: doubleNumber(DsExtendedTokensKeys.spacing),
      spacingLg: doubleNumber(DsExtendedTokensKeys.spacingLg),
      spacingXl: doubleNumber(DsExtendedTokensKeys.spacingXl),
      spacingXXl: doubleNumber(DsExtendedTokensKeys.spacingXXl),
      borderRadiusXs: doubleNumber(DsExtendedTokensKeys.borderRadiusXs),
      borderRadiusSm: doubleNumber(DsExtendedTokensKeys.borderRadiusSm),
      borderRadius: doubleNumber(DsExtendedTokensKeys.borderRadius),
      borderRadiusLg: doubleNumber(DsExtendedTokensKeys.borderRadiusLg),
      borderRadiusXl: doubleNumber(DsExtendedTokensKeys.borderRadiusXl),
      borderRadiusXXl: doubleNumber(DsExtendedTokensKeys.borderRadiusXXl),
      elevationXs: doubleNumber(DsExtendedTokensKeys.elevationXs),
      elevationSm: doubleNumber(DsExtendedTokensKeys.elevationSm),
      elevation: doubleNumber(DsExtendedTokensKeys.elevation),
      elevationLg: doubleNumber(DsExtendedTokensKeys.elevationLg),
      elevationXl: doubleNumber(DsExtendedTokensKeys.elevationXl),
      elevationXXl: doubleNumber(DsExtendedTokensKeys.elevationXXl),
      withAlphaXs: doubleNumber(DsExtendedTokensKeys.withAlphaXs),
      withAlphaSm: doubleNumber(DsExtendedTokensKeys.withAlphaSm),
      withAlpha: doubleNumber(DsExtendedTokensKeys.withAlpha),
      withAlphaLg: doubleNumber(DsExtendedTokensKeys.withAlphaLg),
      withAlphaXl: doubleNumber(DsExtendedTokensKeys.withAlphaXl),
      withAlphaXXl: doubleNumber(DsExtendedTokensKeys.withAlphaXXl),
      animationDurationShort: Duration(
        milliseconds:
            integerNumber(DsExtendedTokensKeys.animationDurationShort),
      ),
      animationDuration: Duration(
        milliseconds: integerNumber(DsExtendedTokensKeys.animationDuration),
      ),
      animationDurationLong: Duration(
        milliseconds: integerNumber(DsExtendedTokensKeys.animationDurationLong),
      ),
    );

    out._validate();
    return out;
  }

  final double spacingXs;
  final double spacingSm;
  final double spacing;
  final double spacingLg;
  final double spacingXl;
  final double spacingXXl;

  final double borderRadiusXs;
  final double borderRadiusSm;
  final double borderRadius;
  final double borderRadiusLg;
  final double borderRadiusXl;
  final double borderRadiusXXl;

  final double elevationXs;
  final double elevationSm;
  final double elevation;
  final double elevationLg;
  final double elevationXl;
  final double elevationXXl;

  /// Intended for use with `Color.withOpacity(x)` (0..1).
  final double withAlphaXs;
  final double withAlphaSm;
  final double withAlpha;
  final double withAlphaLg;
  final double withAlphaXl;
  final double withAlphaXXl;

  final Duration animationDurationShort;
  final Duration animationDuration;
  final Duration animationDurationLong;

  /// Returns a new instance with the provided overrides.
  ///
  /// Optimization: if every parameter is `null`, returns `this`.
  ///
  /// Throws:
  /// - [RangeError] if the resulting instance violates the contracts.
  DsExtendedTokens copyWith({
    double? spacingXs,
    double? spacingSm,
    double? spacing,
    double? spacingLg,
    double? spacingXl,
    double? spacingXXl,
    double? borderRadiusXs,
    double? borderRadiusSm,
    double? borderRadius,
    double? borderRadiusLg,
    double? borderRadiusXl,
    double? borderRadiusXXl,
    double? elevationXs,
    double? elevationSm,
    double? elevation,
    double? elevationLg,
    double? elevationXl,
    double? elevationXXl,
    double? withAlphaXs,
    double? withAlphaSm,
    double? withAlpha,
    double? withAlphaLg,
    double? withAlphaXl,
    double? withAlphaXXl,
    Duration? animationDurationShort,
    Duration? animationDuration,
    Duration? animationDurationLong,
  }) {
    if (spacingXs == null &&
        spacingSm == null &&
        spacing == null &&
        spacingLg == null &&
        spacingXl == null &&
        spacingXXl == null &&
        borderRadiusXs == null &&
        borderRadiusSm == null &&
        borderRadius == null &&
        borderRadiusLg == null &&
        borderRadiusXl == null &&
        borderRadiusXXl == null &&
        elevationXs == null &&
        elevationSm == null &&
        elevation == null &&
        elevationLg == null &&
        elevationXl == null &&
        elevationXXl == null &&
        withAlphaXs == null &&
        withAlphaSm == null &&
        withAlpha == null &&
        withAlphaLg == null &&
        withAlphaXl == null &&
        withAlphaXXl == null &&
        animationDurationShort == null &&
        animationDuration == null &&
        animationDurationLong == null) {
      return this;
    }

    final DsExtendedTokens out = DsExtendedTokens(
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacing: spacing ?? this.spacing,
      spacingLg: spacingLg ?? this.spacingLg,
      spacingXl: spacingXl ?? this.spacingXl,
      spacingXXl: spacingXXl ?? this.spacingXXl,
      borderRadiusXs: borderRadiusXs ?? this.borderRadiusXs,
      borderRadiusSm: borderRadiusSm ?? this.borderRadiusSm,
      borderRadius: borderRadius ?? this.borderRadius,
      borderRadiusLg: borderRadiusLg ?? this.borderRadiusLg,
      borderRadiusXl: borderRadiusXl ?? this.borderRadiusXl,
      borderRadiusXXl: borderRadiusXXl ?? this.borderRadiusXXl,
      elevationXs: elevationXs ?? this.elevationXs,
      elevationSm: elevationSm ?? this.elevationSm,
      elevation: elevation ?? this.elevation,
      elevationLg: elevationLg ?? this.elevationLg,
      elevationXl: elevationXl ?? this.elevationXl,
      elevationXXl: elevationXXl ?? this.elevationXXl,
      withAlphaXs: withAlphaXs ?? this.withAlphaXs,
      withAlphaSm: withAlphaSm ?? this.withAlphaSm,
      withAlpha: withAlpha ?? this.withAlpha,
      withAlphaLg: withAlphaLg ?? this.withAlphaLg,
      withAlphaXl: withAlphaXl ?? this.withAlphaXl,
      withAlphaXXl: withAlphaXXl ?? this.withAlphaXXl,
      animationDurationShort:
          animationDurationShort ?? this.animationDurationShort,
      animationDuration: animationDuration ?? this.animationDuration,
      animationDurationLong:
          animationDurationLong ?? this.animationDurationLong,
    );

    out._validate();
    return out;
  }

  /// Returns a JSON representation compatible with [fromJson].
  ///
  /// Durations are serialized as milliseconds (`int`).
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      DsExtendedTokensKeys.spacingXs: spacingXs,
      DsExtendedTokensKeys.spacingSm: spacingSm,
      DsExtendedTokensKeys.spacing: spacing,
      DsExtendedTokensKeys.spacingLg: spacingLg,
      DsExtendedTokensKeys.spacingXl: spacingXl,
      DsExtendedTokensKeys.spacingXXl: spacingXXl,
      DsExtendedTokensKeys.borderRadiusXs: borderRadiusXs,
      DsExtendedTokensKeys.borderRadiusSm: borderRadiusSm,
      DsExtendedTokensKeys.borderRadius: borderRadius,
      DsExtendedTokensKeys.borderRadiusLg: borderRadiusLg,
      DsExtendedTokensKeys.borderRadiusXl: borderRadiusXl,
      DsExtendedTokensKeys.borderRadiusXXl: borderRadiusXXl,
      DsExtendedTokensKeys.elevationXs: elevationXs,
      DsExtendedTokensKeys.elevationSm: elevationSm,
      DsExtendedTokensKeys.elevation: elevation,
      DsExtendedTokensKeys.elevationLg: elevationLg,
      DsExtendedTokensKeys.elevationXl: elevationXl,
      DsExtendedTokensKeys.elevationXXl: elevationXXl,
      DsExtendedTokensKeys.withAlphaXs: withAlphaXs,
      DsExtendedTokensKeys.withAlphaSm: withAlphaSm,
      DsExtendedTokensKeys.withAlpha: withAlpha,
      DsExtendedTokensKeys.withAlphaLg: withAlphaLg,
      DsExtendedTokensKeys.withAlphaXl: withAlphaXl,
      DsExtendedTokensKeys.withAlphaXXl: withAlphaXXl,
      DsExtendedTokensKeys.animationDurationShort:
          animationDurationShort.inMilliseconds,
      DsExtendedTokensKeys.animationDuration: animationDuration.inMilliseconds,
      DsExtendedTokensKeys.animationDurationLong:
          animationDurationLong.inMilliseconds,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim()) ?? 0.0;
    }
    return 0.0;
  }

  static int _toInteger(dynamic value) {
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

  void _validate() {
    void nonNegative(double v, String name) {
      if (v.isNaN || !v.isFinite) {
        throw RangeError('$name must be finite. Got $v');
      }
      if (v < 0) {
        throw RangeError('$name must be >= 0. Got $v');
      }
    }

    void unit(double v, String name) {
      if (v.isNaN || !v.isFinite) {
        throw RangeError('$name must be finite. Got $v');
      }
      if (v < 0.0 || v > 1.0) {
        throw RangeError('$name must be within 0..1. Got $v');
      }
    }

    void ascending(double a, double b, String aName, String bName) {
      if (a > b) {
        throw RangeError('$aName must be <= $bName. Got $a > $b');
      }
    }

    nonNegative(spacingXs, DsExtendedTokensKeys.spacingXs);
    nonNegative(spacingSm, DsExtendedTokensKeys.spacingSm);
    nonNegative(spacing, DsExtendedTokensKeys.spacing);
    nonNegative(spacingLg, DsExtendedTokensKeys.spacingLg);
    nonNegative(spacingXl, DsExtendedTokensKeys.spacingXl);
    nonNegative(spacingXXl, DsExtendedTokensKeys.spacingXXl);

    ascending(
      spacingXs,
      spacingSm,
      DsExtendedTokensKeys.spacingXs,
      DsExtendedTokensKeys.spacingSm,
    );
    ascending(
      spacingSm,
      spacing,
      DsExtendedTokensKeys.spacingSm,
      DsExtendedTokensKeys.spacing,
    );
    ascending(
      spacing,
      spacingLg,
      DsExtendedTokensKeys.spacing,
      DsExtendedTokensKeys.spacingLg,
    );
    ascending(
      spacingLg,
      spacingXl,
      DsExtendedTokensKeys.spacingLg,
      DsExtendedTokensKeys.spacingXl,
    );
    ascending(
      spacingXl,
      spacingXXl,
      DsExtendedTokensKeys.spacingXl,
      DsExtendedTokensKeys.spacingXXl,
    );

    nonNegative(borderRadiusXs, DsExtendedTokensKeys.borderRadiusXs);
    nonNegative(borderRadiusSm, DsExtendedTokensKeys.borderRadiusSm);
    nonNegative(borderRadius, DsExtendedTokensKeys.borderRadius);
    nonNegative(borderRadiusLg, DsExtendedTokensKeys.borderRadiusLg);
    nonNegative(borderRadiusXl, DsExtendedTokensKeys.borderRadiusXl);
    nonNegative(borderRadiusXXl, DsExtendedTokensKeys.borderRadiusXXl);

    ascending(
      borderRadiusXs,
      borderRadiusSm,
      DsExtendedTokensKeys.borderRadiusXs,
      DsExtendedTokensKeys.borderRadiusSm,
    );
    ascending(
      borderRadiusSm,
      borderRadius,
      DsExtendedTokensKeys.borderRadiusSm,
      DsExtendedTokensKeys.borderRadius,
    );
    ascending(
      borderRadius,
      borderRadiusLg,
      DsExtendedTokensKeys.borderRadius,
      DsExtendedTokensKeys.borderRadiusLg,
    );
    ascending(
      borderRadiusLg,
      borderRadiusXl,
      DsExtendedTokensKeys.borderRadiusLg,
      DsExtendedTokensKeys.borderRadiusXl,
    );
    ascending(
      borderRadiusXl,
      borderRadiusXXl,
      DsExtendedTokensKeys.borderRadiusXl,
      DsExtendedTokensKeys.borderRadiusXXl,
    );

    nonNegative(elevationXs, DsExtendedTokensKeys.elevationXs);
    nonNegative(elevationSm, DsExtendedTokensKeys.elevationSm);
    nonNegative(elevation, DsExtendedTokensKeys.elevation);
    nonNegative(elevationLg, DsExtendedTokensKeys.elevationLg);
    nonNegative(elevationXl, DsExtendedTokensKeys.elevationXl);
    nonNegative(elevationXXl, DsExtendedTokensKeys.elevationXXl);

    ascending(
      elevationXs,
      elevationSm,
      DsExtendedTokensKeys.elevationXs,
      DsExtendedTokensKeys.elevationSm,
    );
    ascending(
      elevationSm,
      elevation,
      DsExtendedTokensKeys.elevationSm,
      DsExtendedTokensKeys.elevation,
    );
    ascending(
      elevation,
      elevationLg,
      DsExtendedTokensKeys.elevation,
      DsExtendedTokensKeys.elevationLg,
    );
    ascending(
      elevationLg,
      elevationXl,
      DsExtendedTokensKeys.elevationLg,
      DsExtendedTokensKeys.elevationXl,
    );
    ascending(
      elevationXl,
      elevationXXl,
      DsExtendedTokensKeys.elevationXl,
      DsExtendedTokensKeys.elevationXXl,
    );

    unit(withAlphaXs, DsExtendedTokensKeys.withAlphaXs);
    unit(withAlphaSm, DsExtendedTokensKeys.withAlphaSm);
    unit(withAlpha, DsExtendedTokensKeys.withAlpha);
    unit(withAlphaLg, DsExtendedTokensKeys.withAlphaLg);
    unit(withAlphaXl, DsExtendedTokensKeys.withAlphaXl);
    unit(withAlphaXXl, DsExtendedTokensKeys.withAlphaXXl);

    ascending(
      withAlphaXs,
      withAlphaSm,
      DsExtendedTokensKeys.withAlphaXs,
      DsExtendedTokensKeys.withAlphaSm,
    );
    ascending(
      withAlphaSm,
      withAlpha,
      DsExtendedTokensKeys.withAlphaSm,
      DsExtendedTokensKeys.withAlpha,
    );
    ascending(
      withAlpha,
      withAlphaLg,
      DsExtendedTokensKeys.withAlpha,
      DsExtendedTokensKeys.withAlphaLg,
    );
    ascending(
      withAlphaLg,
      withAlphaXl,
      DsExtendedTokensKeys.withAlphaLg,
      DsExtendedTokensKeys.withAlphaXl,
    );
    ascending(
      withAlphaXl,
      withAlphaXXl,
      DsExtendedTokensKeys.withAlphaXl,
      DsExtendedTokensKeys.withAlphaXXl,
    );
    if (animationDurationShort.inMilliseconds < 0) {
      throw RangeError('animationDurationShort must be >= 0');
    }
    if (animationDuration.inMilliseconds < 0) {
      throw RangeError('animationDuration must be >= 0');
    }
    if (animationDurationLong.inMilliseconds < 0) {
      throw RangeError('animationDurationLong must be >= 0');
    }
    if (animationDurationShort > animationDuration) {
      throw RangeError('animationDurationShort must be <= animationDuration');
    }
    if (animationDuration > animationDurationLong) {
      throw RangeError('animationDuration must be <= animationDurationLong');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (other is! DsExtendedTokens) {
      return false;
    }

    return spacingXs == other.spacingXs &&
        spacingSm == other.spacingSm &&
        spacing == other.spacing &&
        spacingLg == other.spacingLg &&
        spacingXl == other.spacingXl &&
        spacingXXl == other.spacingXXl &&
        borderRadiusXs == other.borderRadiusXs &&
        borderRadiusSm == other.borderRadiusSm &&
        borderRadius == other.borderRadius &&
        borderRadiusLg == other.borderRadiusLg &&
        borderRadiusXl == other.borderRadiusXl &&
        borderRadiusXXl == other.borderRadiusXXl &&
        elevationXs == other.elevationXs &&
        elevationSm == other.elevationSm &&
        elevation == other.elevation &&
        elevationLg == other.elevationLg &&
        elevationXl == other.elevationXl &&
        elevationXXl == other.elevationXXl &&
        withAlphaXs == other.withAlphaXs &&
        withAlphaSm == other.withAlphaSm &&
        withAlpha == other.withAlpha &&
        withAlphaLg == other.withAlphaLg &&
        withAlphaXl == other.withAlphaXl &&
        withAlphaXXl == other.withAlphaXXl &&
        animationDurationShort == other.animationDurationShort &&
        animationDuration == other.animationDuration &&
        animationDurationLong == other.animationDurationLong;
  }

  @override
  int get hashCode =>
      spacingXs.hashCode ^
      (spacingSm.hashCode * 3) ^
      (spacing.hashCode * 5) ^
      (spacingLg.hashCode * 7) ^
      (spacingXl.hashCode * 11) ^
      (spacingXXl.hashCode * 13) ^
      (borderRadiusXs.hashCode * 17) ^
      (borderRadiusSm.hashCode * 19) ^
      (borderRadius.hashCode * 23) ^
      (borderRadiusLg.hashCode * 29) ^
      (borderRadiusXl.hashCode * 31) ^
      (borderRadiusXXl.hashCode * 37) ^
      (elevationXs.hashCode * 41) ^
      (elevationSm.hashCode * 43) ^
      (elevation.hashCode * 47) ^
      (elevationLg.hashCode * 53) ^
      (elevationXl.hashCode * 59) ^
      (elevationXXl.hashCode * 61) ^
      (withAlphaXs.hashCode * 67) ^
      (withAlphaSm.hashCode * 71) ^
      (withAlpha.hashCode * 73) ^
      (withAlphaLg.hashCode * 79) ^
      (withAlphaXl.hashCode * 83) ^
      (withAlphaXXl.hashCode * 89) ^
      (animationDurationShort.inMilliseconds.hashCode * 97) ^
      (animationDuration.inMilliseconds.hashCode * 101) ^
      (animationDurationLong.inMilliseconds.hashCode * 103);
}
