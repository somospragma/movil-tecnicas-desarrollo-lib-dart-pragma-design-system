import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
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
}
