import 'package:flutter/material.dart';

import 'pragma_color_tokens.dart';

/// Esquemas cromáticos derivados de los tokens oficiales.
class PragmaColors {
  const PragmaColors._();

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: PragmaColorTokens.primaryPurple500,
    onPrimary: PragmaColorTokens.basicWhite50,
    primaryContainer: PragmaColorTokens.primaryPurple50,
    onPrimaryContainer: PragmaColorTokens.primaryPurple900,
    secondary: PragmaColorTokens.secondaryFuchsia500,
    onSecondary: PragmaColorTokens.basicWhite50,
    secondaryContainer: PragmaColorTokens.secondaryFuchsia50,
    onSecondaryContainer: PragmaColorTokens.secondaryFuchsia900,
    tertiary: PragmaColorTokens.tertiaryYellow500,
    onTertiary: PragmaColorTokens.neutralGray900,
    tertiaryContainer: PragmaColorTokens.tertiaryYellow50,
    onTertiaryContainer: PragmaColorTokens.tertiaryYellow700,
    error: PragmaColorTokens.error500,
    onError: PragmaColorTokens.basicWhite50,
    errorContainer: PragmaColorTokens.error50,
    onErrorContainer: PragmaColorTokens.error900,
    surface: PragmaColorTokens.neutralGray50,
    onSurface: PragmaColorTokens.neutralGray900,
    onSurfaceVariant: PragmaColorTokens.neutralGray600,
    outline: PragmaColorTokens.neutralGray400,
    outlineVariant: PragmaColorTokens.neutralGray200,
    shadow: PragmaColorTokens.basicBlack300,
    scrim: PragmaColorTokens.basicBlack300,
    inverseSurface: PragmaColorTokens.neutralGray900,
    inversePrimary: PragmaColorTokens.primaryPurple300,
    surfaceTint: PragmaColorTokens.primaryPurple500,
    surfaceContainerHighest: PragmaColorTokens.neutralGray100,
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: PragmaColorTokens.primaryPurple300,
    onPrimary: PragmaColorTokens.primaryPurple900,
    primaryContainer: PragmaColorTokens.primaryPurple900,
    onPrimaryContainer: PragmaColorTokens.primaryPurple50,
    secondary: PragmaColorTokens.secondaryFuchsia300,
    onSecondary: PragmaColorTokens.secondaryFuchsia900,
    secondaryContainer: PragmaColorTokens.secondaryFuchsia900,
    onSecondaryContainer: PragmaColorTokens.secondaryFuchsia50,
    tertiary: PragmaColorTokens.tertiaryYellow300,
    onTertiary: PragmaColorTokens.tertiaryYellow900,
    tertiaryContainer: PragmaColorTokens.tertiaryYellow900,
    onTertiaryContainer: PragmaColorTokens.tertiaryYellow50,
    error: PragmaColorTokens.error300,
    onError: PragmaColorTokens.error900,
    errorContainer: PragmaColorTokens.error900,
    onErrorContainer: PragmaColorTokens.error50,
    surface: PragmaColorTokens.neutralGray900,
    onSurface: PragmaColorTokens.neutralGray50,
    onSurfaceVariant: PragmaColorTokens.neutralGray200,
    outline: PragmaColorTokens.neutralGray500,
    outlineVariant: PragmaColorTokens.neutralGray700,
    shadow: PragmaColorTokens.basicBlack300,
    scrim: PragmaColorTokens.basicBlack300,
    inverseSurface: PragmaColorTokens.neutralGray100,
    inversePrimary: PragmaColorTokens.primaryPurple500,
    surfaceTint: PragmaColorTokens.primaryPurple300,
    surfaceContainerHighest: PragmaColorTokens.neutralGray800,
  );
}
