// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

// Consumimos la librería local directamente para iterar sin publicar a pub.dev.

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color onSurfaceVariant =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pragma Design System'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.light_mode,
                size: 18,
                color: onSurfaceVariant,
              ),
              Switch(
                value: mode == ThemeMode.dark,
                onChanged: onModeChanged,
              ),
              Icon(
                Icons.dark_mode,
                size: 18,
                color: onSurfaceVariant,
              ),
              const SizedBox(width: PragmaSpacing.md),
            ],
          ),
          IconButton(
            tooltip: 'Grid debugger',
            icon: const Icon(Icons.grid_4x4_outlined),
            onPressed: () => _openGridDebugger(context),
          ),
        ],
      ),
      body: ListView(
        padding: PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.xl,
          vertical: PragmaSpacing.xl,
        ),
        children: <Widget>[
          Text('Paleta cromática', style: textTheme.headlineSmall),
          const SizedBox(height: PragmaSpacing.xs),
          Text(
            'Visualiza los tokens de color incluidos en la librería y cómo se agrupan por intención.',
            style: textTheme.bodyMedium?.copyWith(color: onSurfaceVariant),
          ),
          const SizedBox(height: PragmaSpacing.lg),
          for (final _PaletteSection section in _paletteSections)
            _PaletteSectionView(section: section),
          const SizedBox(height: PragmaSpacing.xxl),
          Text('Componentes base', style: textTheme.headlineSmall),
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
                variant: PragmaIconButtonVariant.ghost,
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.xl),
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
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: PragmaSpacing.sm),
                Text(
                  'Mantén consistencia visual reutilizando estos componentes en cada squad.',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _openGridDebugger(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const GridDebuggerPage(),
    ),
  );
}

class GridDebuggerPage extends StatelessWidget {
  const GridDebuggerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final PragmaViewportEnum viewport = getViewportFromWidth(width);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grid debugger · ${viewport.name} · ${width.toStringAsFixed(0)}px',
        ),
      ),
      body: PragmaGridContainer(
        child: ListView(
          padding: PragmaSpacing.insetSymmetric(
            horizontal: PragmaSpacing.xl,
            vertical: PragmaSpacing.xl,
          ),
          children: <Widget>[
            Text(
              'Experimenta con el layout responsive',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: PragmaSpacing.md),
            Text(
              'Redimensiona la ventana o gira el dispositivo para ver cómo '
              'cambian los márgenes, gutters y columnas.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: PragmaSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: PragmaButton.icon(
                label: 'Ver demo con ScaleBox',
                icon: Icons.open_in_new,
                variant: PragmaButtonVariant.secondary,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ScaleBoxDemoPage(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: PragmaSpacing.xl),
            Wrap(
              spacing: PragmaSpacing.md,
              runSpacing: PragmaSpacing.md,
              children: List<Widget>.generate(4, (int index) {
                return SizedBox(
                  width: 320,
                  child: PragmaCard.section(
                    headline: 'Módulo ${index + 1}',
                    action: PragmaButton.icon(
                      label: 'Más info',
                      icon: Icons.open_in_new,
                      onPressed: () {},
                      variant: PragmaButtonVariant.text,
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Contenido alineado a la grilla para validar '
                          'la maquetación.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: PragmaSpacing.sm),
                        Text(
                          'Viewport actual: ${viewport.name}',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ScaleBoxDemoPage extends StatelessWidget {
  const ScaleBoxDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PragmaScaleBox demo'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width = constraints.maxWidth;
          final bool isCompact = width < 480;

          return ListView(
            padding: PragmaSpacing.insetSymmetric(
              horizontal: PragmaSpacing.xl,
              vertical: PragmaSpacing.xl,
            ),
            children: <Widget>[
              Text(
                'Escala composiciones completas',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Text(
                'El PragmaScaleBox toma una composición con tamaño de diseño '
                'fijo (ej. 390x844) y la estira para ocupar el ancho '
                'disponible manteniendo la proporción. Úsalo para mostrar '
                'maquetas, capturas o layouts creados en Figma sin perder '
                'referencias visuales.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.xl),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(PragmaSpacing.lg),
                child: PragmaScaleBox(
                  designSize: const Size(390, 844),
                  minScale: 0.5,
                  maxScale: 1.5,
                  child: _MockupPhone(isCompact: isCompact),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MockupPhone extends StatelessWidget {
  const _MockupPhone({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(48),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(backgroundColor: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Squad Andes',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      'Dashboard mobile',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.signal_cellular_alt,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Componentes sincronizados',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Este mockup respeta los márgenes y grilla de mobile, pero puede '
            'mostrarse en cualquier viewport gracias al escalado automático.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _MetricChip(icon: Icons.format_paint, label: 'Grid mobile 4px'),
              _MetricChip(icon: Icons.layers, label: '8 columnas'),
              _MetricChip(icon: Icons.lock, label: 'Ratio asegurado'),
              _MetricChip(icon: Icons.animation, label: 'Resizing automático'),
            ],
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: isCompact ? 16 / 9 : 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            scheme.primary.withOpacity(0.05),
                            scheme.secondary.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment:
                        isCompact ? Alignment.topCenter : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 0 : 24,
                        vertical: isCompact ? 12 : 24,
                      ),
                      child: _CompactCard(isCompact: isCompact),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  const _CompactCard({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      width: isCompact ? double.infinity : 280,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Próximo release',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'QA visual validado en 4 viewports usando el ScaleBox.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              const Icon(Icons.play_circle_outline),
              const SizedBox(width: 8),
              Text('Demo interactiva',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: scheme.surfaceContainer,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PaletteSectionView extends StatelessWidget {
  const _PaletteSectionView({required this.section});

  final _PaletteSection section;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color onSurfaceVariant =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: PragmaSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(section.title, style: textTheme.titleLarge),
          if (section.caption != null) ...<Widget>[
            const SizedBox(height: PragmaSpacing.xs),
            Text(
              section.caption!,
              style: textTheme.bodyMedium?.copyWith(color: onSurfaceVariant),
            ),
          ],
          const SizedBox(height: PragmaSpacing.md),
          for (final _PaletteGroup group in section.groups)
            _PaletteGroupTable(group: group),
        ],
      ),
    );
  }
}

class _PaletteGroupTable extends StatelessWidget {
  const _PaletteGroupTable({required this.group});

  final _PaletteGroup group;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(group.title, style: textTheme.titleMedium),
        const SizedBox(height: PragmaSpacing.sm),
        Card(
          margin: const EdgeInsets.only(bottom: PragmaSpacing.lg),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: PragmaSpacing.insetSymmetric(
              horizontal: PragmaSpacing.lg,
              vertical: PragmaSpacing.md,
            ),
            child: DataTable(
              columnSpacing: PragmaSpacing.xl,
              headingRowColor: WidgetStatePropertyAll<Color>(
                scheme.surfaceContainerHighest,
              ),
              headingTextStyle: textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              columns: const <DataColumn>[
                DataColumn(label: Text('Preview')),
                DataColumn(label: Text('Color name')),
                DataColumn(label: Text('Hex')),
                DataColumn(label: Text('Design token')),
              ],
              rows: group.colors
                  .map(
                    (_PaletteColor color) => DataRow(
                      cells: <DataCell>[
                        DataCell(_ColorPreview(color: color.color)),
                        DataCell(Text(color.name)),
                        DataCell(Text(color.hex)),
                        DataCell(Text(color.token)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
    );
  }
}

class _PaletteSection {
  const _PaletteSection({
    required this.title,
    required this.groups,
    this.caption,
  });

  final String title;
  final String? caption;
  final List<_PaletteGroup> groups;
}

class _PaletteGroup {
  const _PaletteGroup({
    required this.title,
    required this.colors,
  });

  final String title;
  final List<_PaletteColor> colors;
}

class _PaletteColor {
  const _PaletteColor({
    required this.name,
    required this.color,
    required this.token,
  });

  final String name;
  final Color color;
  final String token;

  String get hex => _hexFromColor(color);
}

String _hexFromColor(Color color) {
  final String value =
      color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
  return '#${value.substring(2)}';
}

const List<_PaletteSection> _paletteSections = <_PaletteSection>[
  _PaletteSection(
    title: 'Paleta primaria',
    caption:
        'Es la paleta que identifica nuestra marca. En web se utiliza aproximadamente el 60% del color en los diseños.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Primary purple',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Primary-purple-50',
            color: PragmaColorTokens.primaryPurple50,
            token: r'$pds-color-primary-purple-50',
          ),
          _PaletteColor(
            name: 'Primary-purple-300',
            color: PragmaColorTokens.primaryPurple300,
            token: r'$pds-color-primary-purple-300',
          ),
          _PaletteColor(
            name: 'Primary-purple-500',
            color: PragmaColorTokens.primaryPurple500,
            token: r'$pds-color-primary-purple-500',
          ),
          _PaletteColor(
            name: 'Primary-purple-700',
            color: PragmaColorTokens.primaryPurple700,
            token: r'$pds-color-primary-purple-700',
          ),
          _PaletteColor(
            name: 'Primary-purple-900',
            color: PragmaColorTokens.primaryPurple900,
            token: r'$pds-color-primary-purple-900',
          ),
        ],
      ),
      _PaletteGroup(
        title: 'Primary gray',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Primary-gray-50',
            color: PragmaColorTokens.primaryGray50,
            token: r'$pds-color-primary-gray-50',
          ),
          _PaletteColor(
            name: 'Primary-gray-300',
            color: PragmaColorTokens.primaryGray300,
            token: r'$pds-color-primary-gray-300',
          ),
          _PaletteColor(
            name: 'Primary-gray-500',
            color: PragmaColorTokens.primaryGray500,
            token: r'$pds-color-primary-gray-500',
          ),
          _PaletteColor(
            name: 'Primary-gray-700',
            color: PragmaColorTokens.primaryGray700,
            token: r'$pds-color-primary-gray-700',
          ),
          _PaletteColor(
            name: 'Primary-gray-900',
            color: PragmaColorTokens.primaryGray900,
            token: r'$pds-color-primary-gray-900',
          ),
        ],
      ),
      _PaletteGroup(
        title: 'Primary indigo',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Primary-indigo-50',
            color: PragmaColorTokens.primaryIndigo50,
            token: r'$pds-color-primary-indigo-50',
          ),
          _PaletteColor(
            name: 'Primary-indigo-300',
            color: PragmaColorTokens.primaryIndigo300,
            token: r'$pds-color-primary-indigo-300',
          ),
          _PaletteColor(
            name: 'Primary-indigo-500',
            color: PragmaColorTokens.primaryIndigo500,
            token: r'$pds-color-primary-indigo-500',
          ),
          _PaletteColor(
            name: 'Primary-indigo-700',
            color: PragmaColorTokens.primaryIndigo700,
            token: r'$pds-color-primary-indigo-700',
          ),
          _PaletteColor(
            name: 'Primary-indigo-900',
            color: PragmaColorTokens.primaryIndigo900,
            token: r'$pds-color-primary-indigo-900',
          ),
        ],
      ),
    ],
  ),
  _PaletteSection(
    title: 'Paleta secundaria',
    caption:
        'Estos tonos aportan contraste y presencia limpia/legible. En web se recomienda usar alrededor del 30% del canvas.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Secondary fuchsia',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Secondary-fuchsia-50',
            color: PragmaColorTokens.secondaryFuchsia50,
            token: r'$pds-color-secondary-fuchsia-50',
          ),
          _PaletteColor(
            name: 'Secondary-fuchsia-300',
            color: PragmaColorTokens.secondaryFuchsia300,
            token: r'$pds-color-secondary-fuchsia-300',
          ),
          _PaletteColor(
            name: 'Secondary-fuchsia-500',
            color: PragmaColorTokens.secondaryFuchsia500,
            token: r'$pds-color-secondary-fuchsia-500',
          ),
          _PaletteColor(
            name: 'Secondary-fuchsia-700',
            color: PragmaColorTokens.secondaryFuchsia700,
            token: r'$pds-color-secondary-fuchsia-700',
          ),
          _PaletteColor(
            name: 'Secondary-fuchsia-900',
            color: PragmaColorTokens.secondaryFuchsia900,
            token: r'$pds-color-secondary-fuchsia-900',
          ),
        ],
      ),
      _PaletteGroup(
        title: 'Secondary purple',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Secondary-purple-50',
            color: PragmaColorTokens.secondaryPurple50,
            token: r'$pds-color-secondary-purple-50',
          ),
          _PaletteColor(
            name: 'Secondary-purple-300',
            color: PragmaColorTokens.secondaryPurple300,
            token: r'$pds-color-secondary-purple-300',
          ),
          _PaletteColor(
            name: 'Secondary-purple-500',
            color: PragmaColorTokens.secondaryPurple500,
            token: r'$pds-color-secondary-purple-500',
          ),
          _PaletteColor(
            name: 'Secondary-purple-700',
            color: PragmaColorTokens.secondaryPurple700,
            token: r'$pds-color-secondary-purple-700',
          ),
          _PaletteColor(
            name: 'Secondary-purple-900',
            color: PragmaColorTokens.secondaryPurple900,
            token: r'$pds-color-secondary-purple-900',
          ),
        ],
      ),
    ],
  ),
  _PaletteSection(
    title: 'Paleta terciaria',
    caption:
        'Paleta de acento para resaltar información importante sin exceder el 10% del canvas.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Tertiary yellow',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Tertiary-yellow-50',
            color: PragmaColorTokens.tertiaryYellow50,
            token: r'$pds-color-tertiary-yellow-50',
          ),
          _PaletteColor(
            name: 'Tertiary-yellow-300',
            color: PragmaColorTokens.tertiaryYellow300,
            token: r'$pds-color-tertiary-yellow-300',
          ),
          _PaletteColor(
            name: 'Tertiary-yellow-500',
            color: PragmaColorTokens.tertiaryYellow500,
            token: r'$pds-color-tertiary-yellow-500',
          ),
          _PaletteColor(
            name: 'Tertiary-yellow-700',
            color: PragmaColorTokens.tertiaryYellow700,
            token: r'$pds-color-tertiary-yellow-700',
          ),
          _PaletteColor(
            name: 'Tertiary-yellow-900',
            color: PragmaColorTokens.tertiaryYellow900,
            token: r'$pds-color-tertiary-yellow-900',
          ),
        ],
      ),
    ],
  ),
  _PaletteSection(
    title: 'Escala de grises',
    caption: 'Soporte secundario para fondos, textos y componentes modales.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Gray scale',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Gray-50',
            color: PragmaColorTokens.neutralGray50,
            token: r'$pds-color-gray-50',
          ),
          _PaletteColor(
            name: 'Gray-100',
            color: PragmaColorTokens.neutralGray100,
            token: r'$pds-color-gray-100',
          ),
          _PaletteColor(
            name: 'Gray-200',
            color: PragmaColorTokens.neutralGray200,
            token: r'$pds-color-gray-200',
          ),
          _PaletteColor(
            name: 'Gray-300',
            color: PragmaColorTokens.neutralGray300,
            token: r'$pds-color-gray-300',
          ),
          _PaletteColor(
            name: 'Gray-400',
            color: PragmaColorTokens.neutralGray400,
            token: r'$pds-color-gray-400',
          ),
          _PaletteColor(
            name: 'Gray-500',
            color: PragmaColorTokens.neutralGray500,
            token: r'$pds-color-gray-500',
          ),
          _PaletteColor(
            name: 'Gray-600',
            color: PragmaColorTokens.neutralGray600,
            token: r'$pds-color-gray-600',
          ),
          _PaletteColor(
            name: 'Gray-700',
            color: PragmaColorTokens.neutralGray700,
            token: r'$pds-color-gray-700',
          ),
          _PaletteColor(
            name: 'Gray-800',
            color: PragmaColorTokens.neutralGray800,
            token: r'$pds-color-gray-800',
          ),
          _PaletteColor(
            name: 'Gray-900',
            color: PragmaColorTokens.neutralGray900,
            token: r'$pds-color-gray-900',
          ),
        ],
      ),
    ],
  ),
  _PaletteSection(
    title: 'Colores de acciones exitosas',
    caption:
        'Se utilizan como feedback visual para confirmar acciones satisfactorias.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Success',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Success-50',
            color: PragmaColorTokens.success50,
            token: r'$pds-color-success-50',
          ),
          _PaletteColor(
            name: 'Success-300',
            color: PragmaColorTokens.success300,
            token: r'$pds-color-success-300',
          ),
          _PaletteColor(
            name: 'Success-500',
            color: PragmaColorTokens.success500,
            token: r'$pds-color-success-500',
          ),
          _PaletteColor(
            name: 'Success-700',
            color: PragmaColorTokens.success700,
            token: r'$pds-color-success-700',
          ),
          _PaletteColor(
            name: 'Success-900',
            color: PragmaColorTokens.success900,
            token: r'$pds-color-success-900',
          ),
        ],
      ),
    ],
  ),
  _PaletteSection(
    title: 'Colores de advertencia',
    caption:
        'Usados para alertar y preparar al usuario ante acciones sensibles.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Warning',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Warning-50',
            color: PragmaColorTokens.warning50,
            token: r'$pds-color-warning-50',
          ),
          _PaletteColor(
            name: 'Warning-300',
            color: PragmaColorTokens.warning300,
            token: r'$pds-color-warning-300',
          ),
          _PaletteColor(
            name: 'Warning-500',
            color: PragmaColorTokens.warning500,
            token: r'$pds-color-warning-500',
          ),
          _PaletteColor(
            name: 'Warning-700',
            color: PragmaColorTokens.warning700,
            token: r'$pds-color-warning-700',
          ),
          _PaletteColor(
            name: 'Warning-900',
            color: PragmaColorTokens.warning900,
            token: r'$pds-color-warning-900',
          ),
        ],
      ),
    ],
  ),
  _PaletteSection(
    title: 'Colores de error',
    caption:
        'Acompañan mensajes críticos y ayudan a comunicar estados de fallo.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Error',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'Error-50',
            color: PragmaColorTokens.error50,
            token: r'$pds-color-error-50',
          ),
          _PaletteColor(
            name: 'Error-300',
            color: PragmaColorTokens.error300,
            token: r'$pds-color-error-300',
          ),
          _PaletteColor(
            name: 'Error-500',
            color: PragmaColorTokens.error500,
            token: r'$pds-color-error-500',
          ),
          _PaletteColor(
            name: 'Error-700',
            color: PragmaColorTokens.error700,
            token: r'$pds-color-error-700',
          ),
          _PaletteColor(
            name: 'Error-900',
            color: PragmaColorTokens.error900,
            token: r'$pds-color-error-900',
          ),
        ],
      ),
    ],
  ),
  _PaletteSection(
    title: 'Basic shades',
    caption: 'Tonos esenciales para mantener contraste extremo.',
    groups: <_PaletteGroup>[
      _PaletteGroup(
        title: 'Neutros absolutos',
        colors: <_PaletteColor>[
          _PaletteColor(
            name: 'White-50',
            color: PragmaColorTokens.basicWhite50,
            token: r'$pds-color-white-50',
          ),
          _PaletteColor(
            name: 'Black-300',
            color: PragmaColorTokens.basicBlack300,
            token: r'$pds-color-black-300',
          ),
        ],
      ),
    ],
  ),
];
