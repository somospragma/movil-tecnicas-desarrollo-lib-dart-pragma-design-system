import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('buildTheme wires up custom tokens', () {
    final ModelThemePragma base = ModelThemePragma();
    final Map<String, ModelColorToken> tokens =
        Map<String, ModelColorToken>.from(base.colorTokens);
    tokens['primary'] = ModelColorToken(label: 'Primary', color: '#3498DB');
    tokens['onPrimary'] =
        ModelColorToken(label: 'On primary', color: '#000000');

    final Map<String, ModelColorToken> textTokens =
        Map<String, ModelColorToken>.from(base.textColorTokens);
    textTokens['body'] = ModelColorToken(label: 'Body', color: '#222222');
    textTokens['label'] = ModelColorToken(label: 'Label', color: '#FF00FF');

    final ModelThemePragma custom = ModelThemePragma(
      colorTokens: tokens,
      textColorTokens: textTokens,
      typographyFamily: 'Roboto',
    );

    final ThemeData theme = PragmaThemeBuilder.buildTheme(custom);

    expect(theme.colorScheme.primary, const Color(0xFF3498DB));
    expect(theme.colorScheme.onPrimary, Colors.black);
    expect(theme.textTheme.bodyLarge?.fontFamily, contains('Roboto'));
    expect(theme.textTheme.bodyMedium?.color, const Color(0xFF222222));
    expect(theme.textTheme.labelLarge?.color, const Color(0xFFFF00FF));
  });
}
