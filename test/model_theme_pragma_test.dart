import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  test('serializes and deserializes without losing information', () {
    final ModelThemePragma original = ModelThemePragma(
      typographyFamily: 'Space Grotesk',
      brightness: ThemeBrightness.dark,
    );

    final Map<String, dynamic> json = original.toJson();
    final ModelThemePragma decoded = ModelThemePragma.fromJson(json);

    expect(decoded, equals(original));
    expect(decoded.colorTokens.length, original.colorTokens.length);
    expect(decoded.textColorTokens.length, original.textColorTokens.length);
  });

  test('copyWith overrides typography and brightness', () {
    final ModelThemePragma theme = ModelThemePragma();
    final ModelThemePragma updated = theme.copyWith(
      typographyFamily: 'Roboto',
      brightness: ThemeBrightness.dark,
    );

    expect(updated.typographyFamily, 'Roboto');
    expect(updated.brightness, ThemeBrightness.dark);
    expect(updated.colorTokens, equals(theme.colorTokens));
  });

  test('colorFor falls back to a neutral token when missing', () {
    final ModelThemePragma theme = ModelThemePragma();
    final ModelColorToken token = theme.colorFor('nonExisting');

    expect(token.label, 'nonExisting');
    expect(token.color, '#000000');
  });
}
