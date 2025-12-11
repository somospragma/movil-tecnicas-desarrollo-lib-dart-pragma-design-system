import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('PragmaColors use the documented primary token', () {
    expect(
      PragmaColors.lightScheme.primary,
      equals(PragmaColorTokens.primaryPurple500),
    );
  });

  test('PragmaTheme returns ThemeData instances', () {
    expect(PragmaTheme.light(), isA<ThemeData>());
    expect(PragmaTheme.dark().brightness, equals(Brightness.dark));
  });

  test('Typography tokens map to the Poppins scale', () {
    final TextTheme theme = PragmaTypography.textTheme();
    expect(theme.displayLarge?.fontSize, 72);
    expect(theme.displayLarge?.fontFamily?.toLowerCase(), contains('poppins'));
    expect(PragmaTypographyTokens.captionRegularUppercase.isUppercase, isTrue);
  });

  test('Spacing tokens expose the 12-step scale', () {
    expect(PragmaSpacingTokens.all.length, 12);
    expect(PragmaSpacingTokens.all.first.value, 4);
    expect(PragmaSpacingTokens.xxl6.value, 88);
  });
}
