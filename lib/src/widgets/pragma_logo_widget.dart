import 'package:flutter/material.dart';

import '../layout/pragma_scale_box.dart';

/// Visual variants supported by [PragmaLogoWidget].
enum PragmaLogoVariant {
  wordmark,
  app,
  isotypeCircle,
  isotypeCircles,
}

/// Responsive widget that renders the official Pragma logo assets while keeping
/// their proportions thanks to [PragmaScaleBox].
class PragmaLogoWidget extends StatelessWidget {
  const PragmaLogoWidget({
    required this.width,
    super.key,
    this.variant = PragmaLogoVariant.wordmark,
    this.margin,
    this.alignment = Alignment.centerLeft,
    this.semanticLabel,
  });

  /// Target width for the rendered asset.
  final double width;

  /// Logo variation that should be displayed.
  final PragmaLogoVariant variant;

  /// Overrides the automatically calculated margin.
  final EdgeInsetsGeometry? margin;

  /// Alignment used for both the scale box and the image.
  final Alignment alignment;

  /// Custom semantics label. Defaults to "Pragma logo".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(width > 0, 'width must be greater than zero');
    final Brightness brightness = Theme.of(context).brightness;
    final _PragmaLogoConfig config = _PragmaLogoConfig.fromVariant(variant);
    final String assetPath =
        brightness == Brightness.dark ? config.darkAsset : config.lightAsset;
    final EdgeInsetsGeometry resolvedMargin =
        margin ?? config.marginForWidth(width);

    return Padding(
      padding: resolvedMargin,
      child: SizedBox(
        width: width,
        child: Semantics(
          label: semanticLabel ?? 'Pragma logo',
          image: true,
          child: PragmaScaleBox(
            designSize: config.designSize,
            alignment: alignment,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              alignment: alignment,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}

class _PragmaLogoConfig {
  const _PragmaLogoConfig({
    required this.designSize,
    required this.lightAsset,
    required this.darkAsset,
    required this.horizontalMarginFactor,
    required this.verticalMarginFactor,
  });

  factory _PragmaLogoConfig.fromVariant(PragmaLogoVariant variant) {
    switch (variant) {
      case PragmaLogoVariant.app:
        return const _PragmaLogoConfig(
          designSize: Size(119, 41),
          lightAsset: 'assets/logo_light/app_logo.png',
          darkAsset: 'assets/logo_dark/app_logo_white.png',
          horizontalMarginFactor: 0.06,
          verticalMarginFactor: 0.04,
        );
      case PragmaLogoVariant.isotypeCircle:
        return const _PragmaLogoConfig(
          designSize: Size(64, 64),
          lightAsset: 'assets/logo_light/isotype_circle.png',
          darkAsset: 'assets/logo_dark/circle_isotype_white.png',
          horizontalMarginFactor: 0.04,
          verticalMarginFactor: 0.04,
        );
      case PragmaLogoVariant.isotypeCircles:
        return const _PragmaLogoConfig(
          designSize: Size(226, 33),
          lightAsset: 'assets/logo_light/circles_isotype.png',
          darkAsset: 'assets/logo_dark/circles_isotype_white.png',
          horizontalMarginFactor: 0.05,
          verticalMarginFactor: 0.035,
        );
      case PragmaLogoVariant.wordmark:
        return const _PragmaLogoConfig(
          designSize: Size(256, 64),
          lightAsset: 'assets/logo_light/logo.png',
          darkAsset: 'assets/logo_dark/logo_white.png',
          horizontalMarginFactor: 0.08,
          verticalMarginFactor: 0.04,
        );
    }
  }

  final Size designSize;
  final String lightAsset;
  final String darkAsset;
  final double horizontalMarginFactor;
  final double verticalMarginFactor;

  EdgeInsets marginForWidth(double width) {
    final double horizontal = width * horizontalMarginFactor;
    final double vertical = width * verticalMarginFactor;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
}
