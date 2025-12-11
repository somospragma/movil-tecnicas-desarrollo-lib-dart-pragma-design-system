import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Escalas tipográficas basadas en Inter y Space Grotesk.
class PragmaTypography {
  const PragmaTypography._();

  static TextTheme textTheme({Brightness brightness = Brightness.light}) {
    final TextTheme base = GoogleFonts.interTextTheme();
    final TextTheme heading = GoogleFonts.spaceGroteskTextTheme();
    final Color color =
        brightness == Brightness.dark ? Colors.white : Colors.black87;

    TextStyle merge(
      TextStyle? primary,
      TextStyle? secondary, {
      FontWeight? weight,
      double? letterSpacing,
      double? height,
    }) {
      final TextStyle resolved =
          (secondary ?? const TextStyle()).merge(primary);
      return resolved.copyWith(
        color: color,
        fontWeight: weight ?? resolved.fontWeight,
        letterSpacing: letterSpacing ?? resolved.letterSpacing,
        height: height ?? resolved.height,
      );
    }

    return base.copyWith(
      displayLarge: merge(
        base.displayLarge,
        heading.displayLarge,
        weight: FontWeight.w600,
        letterSpacing: -1.2,
        height: 1.05,
      ),
      displayMedium: merge(
        base.displayMedium,
        heading.displayMedium,
        weight: FontWeight.w600,
        letterSpacing: -1.0,
        height: 1.08,
      ),
      displaySmall: merge(
        base.displaySmall,
        heading.displaySmall,
        weight: FontWeight.w600,
        letterSpacing: -0.6,
      ),
      headlineLarge: merge(
        base.headlineLarge,
        heading.headlineLarge,
        weight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      headlineMedium: merge(
        base.headlineMedium,
        heading.headlineMedium,
        weight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      headlineSmall: merge(
        base.headlineSmall,
        heading.headlineSmall,
        weight: FontWeight.w600,
      ),
      titleLarge: merge(
        base.titleLarge,
        heading.titleLarge,
        weight: FontWeight.w600,
      ),
      titleMedium: merge(
        base.titleMedium,
        heading.titleMedium,
        weight: FontWeight.w600,
      ),
      titleSmall: merge(
        base.titleSmall,
        heading.titleSmall,
        weight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelLarge: merge(
        base.labelLarge,
        heading.labelLarge,
        weight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      labelMedium: merge(
        base.labelMedium,
        null,
        weight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelSmall: merge(
        base.labelSmall,
        null,
        weight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      bodyLarge: merge(base.bodyLarge, null, height: 1.4),
      bodyMedium: merge(base.bodyMedium, null, height: 1.4),
      bodySmall: merge(base.bodySmall, null, height: 1.4),
    );
  }
}
