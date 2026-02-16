import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../tokens/pragma_color_tokens.dart';

abstract final class ModelSemanticColorsKeys {
  static const String success = 'success';
  static const String onSuccess = 'onSuccess';
  static const String successContainer = 'successContainer';
  static const String onSuccessContainer = 'onSuccessContainer';
  static const String warning = 'warning';
  static const String onWarning = 'onWarning';
  static const String warningContainer = 'warningContainer';
  static const String onWarningContainer = 'onWarningContainer';
  static const String info = 'info';
  static const String onInfo = 'onInfo';
  static const String infoContainer = 'infoContainer';
  static const String onInfoContainer = 'onInfoContainer';

  static const List<String> all = <String>[
    success,
    onSuccess,
    successContainer,
    onSuccessContainer,
    warning,
    onWarning,
    warningContainer,
    onWarningContainer,
    info,
    onInfo,
    infoContainer,
    onInfoContainer,
  ];
}

@immutable
class ModelSemanticColors {
  const ModelSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  factory ModelSemanticColors.fallbackLight() {
    return const ModelSemanticColors(
      success: PragmaColorTokens.success900,
      onSuccess: PragmaColorTokens.basicWhite50,
      successContainer: PragmaColorTokens.success50,
      onSuccessContainer: PragmaColorTokens.success900,
      warning: PragmaColorTokens.warning700,
      onWarning: PragmaColorTokens.basicBlack300,
      warningContainer: PragmaColorTokens.warning50,
      onWarningContainer: PragmaColorTokens.warning900,
      info: PragmaColorTokens.primaryIndigo700,
      onInfo: PragmaColorTokens.basicWhite50,
      infoContainer: PragmaColorTokens.primaryIndigo50,
      onInfoContainer: PragmaColorTokens.primaryIndigo900,
    ).._validate();
  }

  factory ModelSemanticColors.fallbackDark() {
    return const ModelSemanticColors(
      success: PragmaColorTokens.success300,
      onSuccess: PragmaColorTokens.success900,
      successContainer: PragmaColorTokens.success900,
      onSuccessContainer: PragmaColorTokens.success50,
      warning: PragmaColorTokens.warning300,
      onWarning: PragmaColorTokens.warning900,
      warningContainer: PragmaColorTokens.warning900,
      onWarningContainer: PragmaColorTokens.warning50,
      info: PragmaColorTokens.primaryIndigo500,
      onInfo: PragmaColorTokens.basicBlack300,
      infoContainer: PragmaColorTokens.primaryIndigo900,
      onInfoContainer: PragmaColorTokens.primaryIndigo50,
    ).._validate();
  }

  factory ModelSemanticColors.fromColorScheme(ColorScheme colorScheme) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final ModelSemanticColors base = isDark
        ? ModelSemanticColors.fallbackDark()
        : ModelSemanticColors.fallbackLight();

    Color blend(Color color) {
      final double alpha = isDark ? 0.24 : 0.16;
      return Color.alphaBlend(
        color.withValues(alpha: alpha),
        colorScheme.surface,
      );
    }

    return base.copyWith(
      successContainer: blend(base.success),
      warningContainer: blend(base.warning),
      infoContainer: blend(base.info),
      onSuccessContainer: _onColorFor(blend(base.success)),
      onWarningContainer: _onColorFor(blend(base.warning)),
      onInfoContainer: _onColorFor(blend(base.info)),
    );
  }

  factory ModelSemanticColors.fromJson(Map<String, dynamic> json) {
    for (final String key in ModelSemanticColorsKeys.all) {
      if (!json.containsKey(key)) {
        throw FormatException('Missing key: $key');
      }
    }

    Color readColor(String key) => Color(_toInteger(json[key]));

    final ModelSemanticColors out = ModelSemanticColors(
      success: readColor(ModelSemanticColorsKeys.success),
      onSuccess: readColor(ModelSemanticColorsKeys.onSuccess),
      successContainer: readColor(ModelSemanticColorsKeys.successContainer),
      onSuccessContainer: readColor(ModelSemanticColorsKeys.onSuccessContainer),
      warning: readColor(ModelSemanticColorsKeys.warning),
      onWarning: readColor(ModelSemanticColorsKeys.onWarning),
      warningContainer: readColor(ModelSemanticColorsKeys.warningContainer),
      onWarningContainer: readColor(ModelSemanticColorsKeys.onWarningContainer),
      info: readColor(ModelSemanticColorsKeys.info),
      onInfo: readColor(ModelSemanticColorsKeys.onInfo),
      infoContainer: readColor(ModelSemanticColorsKeys.infoContainer),
      onInfoContainer: readColor(ModelSemanticColorsKeys.onInfoContainer),
    );

    out._validate();
    return out;
  }

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  Map<String, dynamic> toJson() => <String, dynamic>{
        ModelSemanticColorsKeys.success: success.toARGB32(),
        ModelSemanticColorsKeys.onSuccess: onSuccess.toARGB32(),
        ModelSemanticColorsKeys.successContainer: successContainer.toARGB32(),
        ModelSemanticColorsKeys.onSuccessContainer:
            onSuccessContainer.toARGB32(),
        ModelSemanticColorsKeys.warning: warning.toARGB32(),
        ModelSemanticColorsKeys.onWarning: onWarning.toARGB32(),
        ModelSemanticColorsKeys.warningContainer: warningContainer.toARGB32(),
        ModelSemanticColorsKeys.onWarningContainer:
            onWarningContainer.toARGB32(),
        ModelSemanticColorsKeys.info: info.toARGB32(),
        ModelSemanticColorsKeys.onInfo: onInfo.toARGB32(),
        ModelSemanticColorsKeys.infoContainer: infoContainer.toARGB32(),
        ModelSemanticColorsKeys.onInfoContainer: onInfoContainer.toARGB32(),
      };

  ModelSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return ModelSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    ).._validate();
  }

  void _validate() {
    _minContrast(success, onSuccess, 'success/onSuccess');
    _minContrast(
      successContainer,
      onSuccessContainer,
      'successContainer/onSuccessContainer',
    );
    _minContrast(warning, onWarning, 'warning/onWarning');
    _minContrast(
      warningContainer,
      onWarningContainer,
      'warningContainer/onWarningContainer',
    );
    _minContrast(info, onInfo, 'info/onInfo');
    _minContrast(
      infoContainer,
      onInfoContainer,
      'infoContainer/onInfoContainer',
    );
  }

  static void _minContrast(Color bg, Color fg, String name) {
    final double ratio = _contrastRatio(bg, fg);
    if (ratio < 3.0) {
      throw RangeError('$name contrast too low. Got $ratio (< 3.0)');
    }
  }

  static double _contrastRatio(Color a, Color b) {
    final double l1 = a.computeLuminance();
    final double l2 = b.computeLuminance();
    final double hi = l1 > l2 ? l1 : l2;
    final double lo = l1 > l2 ? l2 : l1;
    return (hi + 0.05) / (lo + 0.05);
  }

  static Color _onColorFor(Color background) {
    const Color white = Colors.white;
    const Color black = Colors.black;
    final double whiteContrast = _contrastRatio(background, white);
    final double blackContrast = _contrastRatio(background, black);
    return whiteContrast >= blackContrast ? white : black;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ModelSemanticColors) {
      return false;
    }
    return mapEquals(toJson(), other.toJson());
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
        success,
        onSuccess,
        successContainer,
        onSuccessContainer,
        warning,
        onWarning,
        warningContainer,
        onWarningContainer,
        info,
        onInfo,
        infoContainer,
        onInfoContainer,
      ]);
}
