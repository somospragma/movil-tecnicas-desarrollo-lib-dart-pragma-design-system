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

    final ModelThemePragma custom =
        ModelThemePragma(colorTokens: tokens, typographyFamily: 'Roboto');

    final ThemeData theme = PragmaThemeBuilder.buildTheme(custom);

    expect(theme.colorScheme.primary, const Color(0xFF3498DB));
    expect(theme.colorScheme.onPrimary, Colors.black);
    expect(theme.textTheme.bodyLarge?.fontFamily, contains('Roboto'));
  });
}
