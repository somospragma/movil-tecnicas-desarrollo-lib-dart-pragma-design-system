import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class ThemeLabPage extends StatefulWidget {
  const ThemeLabPage({super.key});

  @override
  State<ThemeLabPage> createState() => _ThemeLabPageState();
}

class _ThemeLabPageState extends State<ThemeLabPage> {
  ModelThemePragma _theme = ModelThemePragma();

  void _handleThemeChanged(ModelThemePragma value) {
    setState(() => _theme = value);
  }

  void _resetTheme() {
    setState(() => _theme = ModelThemePragma());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme lab'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Restablecer',
            icon: const Icon(Icons.restart_alt),
            onPressed: _resetTheme,
          ),
        ],
      ),
      body: Padding(
        padding: PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.xl,
          vertical: PragmaSpacing.lg,
        ),
        child: PragmaThemeEditorWidget(
          theme: _theme,
          onChanged: _handleThemeChanged,
        ),
      ),
    );
  }
}
