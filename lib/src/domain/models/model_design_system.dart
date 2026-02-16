import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../tokens/pragma_typography.dart';
import 'model_ds_dataviz_palette.dart';
import 'model_ds_extended_tokens.dart';
import 'model_semantic_colors.dart';
import 'model_theme_data.dart';
import 'model_typography_tokens.dart';

abstract final class ModelDesignSystemKeys {
  static const String theme = 'theme';
  static const String tokens = 'tokens';
  static const String semanticLight = 'semanticLight';
  static const String semanticDark = 'semanticDark';
  static const String dataViz = 'dataViz';
  static const String typographyTokens = 'typographyTokens';
}

@immutable
class ModelDesignSystem {
  const ModelDesignSystem({
    required this.theme,
    required this.tokens,
    required this.semanticLight,
    required this.semanticDark,
    required this.dataViz,
    required this.typographyTokens,
  });

  factory ModelDesignSystem.pragmaDefault() {
    return ModelDesignSystem(
      theme: ModelThemeData.pragmaDefault(),
      tokens: const DsExtendedTokens(),
      semanticLight: ModelSemanticColors.fallbackLight(),
      semanticDark: ModelSemanticColors.fallbackDark(),
      dataViz: ModelDataVizPalette.fallback(),
      typographyTokens: ModelTypographyTokens.pragmaDefault(),
    );
  }

  factory ModelDesignSystem.fromJson(Map<String, dynamic> json) {
    final Object? themeRaw = json[ModelDesignSystemKeys.theme];
    final Object? tokensRaw = json[ModelDesignSystemKeys.tokens];

    if (themeRaw is! Map<String, dynamic>) {
      throw const FormatException('Expected map for theme');
    }
    if (tokensRaw is! Map<String, dynamic>) {
      throw const FormatException('Expected map for tokens');
    }

    final Object? semanticLightRaw = json[ModelDesignSystemKeys.semanticLight];
    final Object? semanticDarkRaw = json[ModelDesignSystemKeys.semanticDark];
    final Object? dataVizRaw = json[ModelDesignSystemKeys.dataViz];
    final Object? typographyTokensRaw =
        json[ModelDesignSystemKeys.typographyTokens];

    return ModelDesignSystem(
      theme: ModelThemeData.fromJson(themeRaw),
      tokens: DsExtendedTokens.fromJson(tokensRaw),
      semanticLight: semanticLightRaw is Map<String, dynamic>
          ? ModelSemanticColors.fromJson(semanticLightRaw)
          : ModelSemanticColors.fallbackLight(),
      semanticDark: semanticDarkRaw is Map<String, dynamic>
          ? ModelSemanticColors.fromJson(semanticDarkRaw)
          : ModelSemanticColors.fallbackDark(),
      dataViz: dataVizRaw is Map<String, dynamic>
          ? ModelDataVizPalette.fromJson(dataVizRaw)
          : ModelDataVizPalette.fallback(),
      typographyTokens: typographyTokensRaw is Map<String, dynamic>
          ? ModelTypographyTokens.fromJson(typographyTokensRaw)
          : ModelTypographyTokens.pragmaDefault(),
    );
  }

  final ModelThemeData theme;
  final DsExtendedTokens tokens;
  final ModelSemanticColors semanticLight;
  final ModelSemanticColors semanticDark;
  final ModelDataVizPalette dataViz;
  final ModelTypographyTokens typographyTokens;

  ModelDesignSystem copyWith({
    ModelThemeData? theme,
    DsExtendedTokens? tokens,
    ModelSemanticColors? semanticLight,
    ModelSemanticColors? semanticDark,
    ModelDataVizPalette? dataViz,
    ModelTypographyTokens? typographyTokens,
  }) {
    return ModelDesignSystem(
      theme: theme ?? this.theme,
      tokens: tokens ?? this.tokens,
      semanticLight: semanticLight ?? this.semanticLight,
      semanticDark: semanticDark ?? this.semanticDark,
      dataViz: dataViz ?? this.dataViz,
      typographyTokens: typographyTokens ?? this.typographyTokens,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        ModelDesignSystemKeys.theme: theme.toJson(),
        ModelDesignSystemKeys.tokens: tokens.toJson(),
        ModelDesignSystemKeys.semanticLight: semanticLight.toJson(),
        ModelDesignSystemKeys.semanticDark: semanticDark.toJson(),
        ModelDesignSystemKeys.dataViz: dataViz.toJson(),
        ModelDesignSystemKeys.typographyTokens: typographyTokens.toJson(),
      };

  ThemeData toThemeData({required Brightness brightness}) {
    final ModelThemeData themed = theme.copyWith(
      lightTextTheme: PragmaTypography.textThemeFromTokens(
        typographyTokens: typographyTokens,
      ),
      darkTextTheme: PragmaTypography.textThemeFromTokens(
        typographyTokens: typographyTokens,
        brightness: Brightness.dark,
      ),
    );

    final ThemeData base = themed.toThemeData(brightness: brightness);
    final ModelSemanticColors semantic =
        brightness == Brightness.dark ? semanticDark : semanticLight;

    final ThemeData withExtensions = base.copyWith(
      extensions: <ThemeExtension<dynamic>>[
        DsExtendedTokensExtension(tokens: tokens),
        DsSemanticColorsExtension(semantic: semantic),
        DsDataVizPaletteExtension(palette: dataViz),
      ],
    );

    return _applyComponentTheme(withExtensions);
  }

  ThemeData _applyComponentTheme(ThemeData t) {
    final ColorScheme cs = t.colorScheme;
    final BorderRadius radius = BorderRadius.circular(tokens.borderRadius);
    final BorderRadius radiusLg = BorderRadius.circular(tokens.borderRadiusLg);

    return t.copyWith(
      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: tokens.elevation,
        shape: RoundedRectangleBorder(borderRadius: radiusLg),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: radius),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: cs.primary, width: 1.4),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spacing,
          vertical: tokens.spacingSm,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: tokens.spacing,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ModelDesignSystem) {
      return false;
    }
    return mapEquals(toJson(), other.toJson());
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
        theme,
        tokens,
        semanticLight,
        semanticDark,
        dataViz,
        typographyTokens,
      ]);
}

@immutable
class DsExtendedTokensExtension
    extends ThemeExtension<DsExtendedTokensExtension> {
  const DsExtendedTokensExtension({required this.tokens});

  final DsExtendedTokens tokens;

  @override
  DsExtendedTokensExtension copyWith({DsExtendedTokens? tokens}) {
    return DsExtendedTokensExtension(tokens: tokens ?? this.tokens);
  }

  @override
  DsExtendedTokensExtension lerp(
    covariant ThemeExtension<DsExtendedTokensExtension>? other,
    double t,
  ) {
    if (other is! DsExtendedTokensExtension) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}

@immutable
class DsSemanticColorsExtension
    extends ThemeExtension<DsSemanticColorsExtension> {
  const DsSemanticColorsExtension({required this.semantic});

  final ModelSemanticColors semantic;

  @override
  DsSemanticColorsExtension copyWith({ModelSemanticColors? semantic}) {
    return DsSemanticColorsExtension(semantic: semantic ?? this.semantic);
  }

  @override
  DsSemanticColorsExtension lerp(
    covariant ThemeExtension<DsSemanticColorsExtension>? other,
    double t,
  ) {
    if (other is! DsSemanticColorsExtension) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}

@immutable
class DsDataVizPaletteExtension
    extends ThemeExtension<DsDataVizPaletteExtension> {
  const DsDataVizPaletteExtension({required this.palette});

  final ModelDataVizPalette palette;

  @override
  DsDataVizPaletteExtension copyWith({ModelDataVizPalette? palette}) {
    return DsDataVizPaletteExtension(palette: palette ?? this.palette);
  }

  @override
  DsDataVizPaletteExtension lerp(
    covariant ThemeExtension<DsDataVizPaletteExtension>? other,
    double t,
  ) {
    if (other is! DsDataVizPaletteExtension) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}

extension PragmaDesignSystemThemeX on ThemeData {
  DsExtendedTokens get dsTokens {
    return extension<DsExtendedTokensExtension>()?.tokens ??
        const DsExtendedTokens();
  }

  ModelSemanticColors get dsSemantic {
    return extension<DsSemanticColorsExtension>()?.semantic ??
        ModelSemanticColors.fallbackLight();
  }

  ModelDataVizPalette get dsDataViz {
    return extension<DsDataVizPaletteExtension>()?.palette ??
        ModelDataVizPalette.fallback();
  }
}
