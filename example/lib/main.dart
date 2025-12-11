import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  runApp(const PragmaShowcaseApp());
}

class PragmaShowcaseApp extends StatefulWidget {
  const PragmaShowcaseApp({super.key});

  @override
  State<PragmaShowcaseApp> createState() => _PragmaShowcaseAppState();
}

class _PragmaShowcaseAppState extends State<PragmaShowcaseApp> {
  ThemeMode _mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pragma Design System',
      debugShowCheckedModeBanner: false,
      theme: PragmaTheme.light(),
      darkTheme: PragmaTheme.dark(),
      themeMode: _mode,
      home: ShowcaseScreen(
        mode: _mode,
        onModeChanged: (bool value) {
          setState(() => _mode = value ? ThemeMode.dark : ThemeMode.light);
        },
      ),
    );
  }
}

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({
    required this.mode,
    required this.onModeChanged,
    super.key,
  });

  final ThemeMode mode;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pragma Design System'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.light_mode, size: 18),
              Switch(
                value: mode == ThemeMode.dark,
                onChanged: onModeChanged,
              ),
              const Icon(Icons.dark_mode, size: 18),
              const SizedBox(width: PragmaSpacing.md),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.xl,
          vertical: PragmaSpacing.xl,
        ),
        children: <Widget>[
          Text('Tokens', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: PragmaSpacing.md),
          _ColorTokensRow(scheme: scheme),
          const SizedBox(height: PragmaSpacing.xl),
          Text('Componentes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: PragmaSpacing.md),
          Wrap(
            spacing: PragmaSpacing.md,
            runSpacing: PragmaSpacing.md,
            children: <Widget>[
              PragmaButton(
                label: 'Primario',
                onPressed: () {},
              ),
              PragmaButton(
                label: 'Tonal',
                onPressed: () {},
                variant: PragmaButtonVariant.tonal,
              ),
              PragmaButton(
                label: 'Secundario',
                onPressed: () {},
                variant: PragmaButtonVariant.secondary,
              ),
              PragmaButton.icon(
                label: 'Texto',
                icon: Icons.arrow_forward,
                variant: PragmaButtonVariant.text,
                onPressed: () {},
              ),
              PragmaIconButton(
                icon: Icons.favorite,
                onPressed: () {},
                tooltip: 'Favorito',
              ),
              const PragmaIconButton(
                icon: Icons.palette,
                onPressed: null,
                tooltip: 'Deshabilitado',
                variant: PragmaIconButtonVariant.tonal,
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.xl),
          Text('Card', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: PragmaSpacing.md),
          PragmaCard.section(
            headline: 'Estado de diseño',
            action: PragmaButton.icon(
              label: 'Ver detalles',
              icon: Icons.open_in_new,
              onPressed: () {},
              variant: PragmaButtonVariant.text,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tokens sincronizados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: PragmaSpacing.sm),
                Text(
                  'Mantén consistencia visual reutilizando estos componentes en cada squad.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorTokensRow extends StatelessWidget {
  const _ColorTokensRow({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = <Color>[
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      scheme.error,
      scheme.surface,
      scheme.surfaceContainerHighest,
    ];

    return Wrap(
      spacing: PragmaSpacing.sm,
      children: colors
          .map(
            (Color color) => _ColorSwatch(
              color: color,
              label:
                  '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
            ),
          )
          .toList(),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
        ),
        const SizedBox(height: PragmaSpacing.xs),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
