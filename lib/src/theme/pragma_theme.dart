import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/pragma_colors.dart';
import '../tokens/pragma_spacing.dart';
import '../tokens/pragma_typography.dart';
import '../widgets/pragma_button.dart';

/// Tema Material 3 adaptado a la identidad de Pragma.
class PragmaTheme {
  const PragmaTheme._();

  static ThemeData light() => _buildTheme(Brightness.light);

  static ThemeData dark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final ColorScheme colorScheme = brightness == Brightness.dark
        ? PragmaColors.darkScheme
        : PragmaColors.lightScheme;
    final TextTheme textTheme =
        PragmaTypography.textTheme(brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: PragmaButtons.primaryStyle(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: PragmaButtons.outlinedStyle(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: PragmaButtons.textStyle(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        padding: PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.sm,
          vertical: PragmaSpacing.xxxs,
        ),
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.85),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: PragmaSpacing.md,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        contentPadding: PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.md,
          vertical: PragmaSpacing.sm,
        ),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.md,
          vertical: PragmaSpacing.xs,
        ),
        iconColor: colorScheme.primary,
      ),
    );
  }
}
