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
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final Color onSurfaceVariant = colorScheme.onSurfaceVariant;
    final List<ModelPragmaComponent> documentedComponents = _componentCatalog
        .map<ModelPragmaComponent>(ModelPragmaComponent.fromJson)
        .toList();

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
              const PragmaPrimaryButton(
                label: 'Primario',
                onPressed: _noop,
              ),
              const PragmaPrimaryButton(
                label: 'Primario inverso',
                tone: PragmaButtonTone.inverse,
                onPressed: _noop,
              ),
              const PragmaSecondaryButton(
                label: 'Secundario',
                onPressed: _noop,
              ),
              const PragmaTertiaryButton(
                label: 'Terciario',
                onPressed: _noop,
              ),
              const PragmaSecondaryButton(
                label: 'Secundario small',
                size: PragmaButtonSize.small,
                onPressed: _noop,
              ),
              PragmaButton.icon(
                label: 'Texto con ícono',
                icon: Icons.arrow_forward,
                hierarchy: PragmaButtonHierarchy.tertiary,
                onPressed: _noop,
              ),
              const PragmaIconButtonWidget(
                icon: Icons.favorite,
                onPressed: _noop,
                tooltip: 'Favorito',
                style: PragmaIconButtonStyle.filledLight,
              ),
              const PragmaIconButtonWidget(
                icon: Icons.palette,
                tooltip: 'Deshabilitado',
                style: PragmaIconButtonStyle.outlinedLight,
                onPressed: null,
              ),
              const PragmaAvatarWidget(
                radius: PragmaSpacing.md,
                initials: 'PD',
                tooltip: 'Avatar estático',
              ),
              const PragmaBreadcrumbWidget(
                items: <PragmaBreadcrumbItem>[
                  PragmaBreadcrumbItem(label: 'Inicio'),
                  PragmaBreadcrumbItem(label: 'Componentes'),
                  PragmaBreadcrumbItem(label: 'Breadcrumb', isCurrent: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.xl),
          PragmaCard.section(
            headline: 'Estado de diseño',
            action: PragmaButton.icon(
              label: 'Ver detalles',
              icon: Icons.open_in_new,
              hierarchy: PragmaButtonHierarchy.tertiary,
              onPressed: _noop,
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
          const SizedBox(height: PragmaSpacing.xl),
          Text('PragmaCardWidget', style: textTheme.headlineSmall),
          const SizedBox(height: PragmaSpacing.sm),
          Wrap(
            spacing: PragmaSpacing.lg,
            runSpacing: PragmaSpacing.lg,
            children: <Widget>[
              SizedBox(
                width: 360,
                child: PragmaCardWidget(
                  title: 'Actividad semanal',
                  subtitle: 'Actualizado hace 5 min',
                  metadata: Wrap(
                    spacing: PragmaSpacing.xs,
                    runSpacing: PragmaSpacing.xs,
                    children: <Widget>[
                      Chip(
                        label: const Text('Squad Atlas'),
                        backgroundColor: colorScheme.surfaceContainerHighest,
                      ),
                      Chip(
                        label: const Text('Mobile'),
                        backgroundColor: colorScheme.surfaceContainerHighest,
                      ),
                    ],
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Sesiones totales',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: PragmaSpacing.xs),
                      Text(
                        '18.4K · +4.1% vs semana anterior',
                        style: textTheme.bodyMedium?.copyWith(
                          color: onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  variant: PragmaCardVariant.tonal,
                  actions: <Widget>[
                    PragmaButton.icon(
                      label: 'Ver dashboard',
                      icon: Icons.open_in_new,
                      hierarchy: PragmaButtonHierarchy.tertiary,
                      onPressed: _noop,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 320,
                child: PragmaCardWidget(
                  title: 'Prototipo desktop',
                  subtitle: 'Listo para pruebas internas',
                  metadata: Text(
                    'Actualizado por UX Research',
                    style: textTheme.bodySmall?.copyWith(
                      color: onSurfaceVariant,
                    ),
                  ),
                  media: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            colorScheme.primaryContainer,
                            colorScheme.secondaryContainer,
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.view_in_ar, size: 48),
                      ),
                    ),
                  ),
                  body: Text(
                    'Comparte enlaces a los archivos clave sin perder el contexto visual.',
                    style: textTheme.bodyMedium,
                  ),
                  size: PragmaCardSize.small,
                  variant: PragmaCardVariant.outlined,
                  actions: <Widget>[
                    TextButton.icon(
                      onPressed: _noop,
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('Abrir preview'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.xl),
          Text('PragmaAccordionWidget', style: textTheme.headlineSmall),
          const SizedBox(height: PragmaSpacing.sm),
          PragmaAccordionWidget(
            text: 'Resumen del sprint',
            icon: Icons.calendar_today_outlined,
            child: Text(
              'Comparte acuerdos, links a tableros y métricas clave sin saturar la vista principal.',
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: PragmaSpacing.md),
          const PragmaAccordionWidget(
            text: 'Checklist bloqueado',
            icon: Icons.lock_outline,
            disable: true,
            size: PragmaAccordionSize.block,
            child:
                Text('Este panel permanece cerrado hasta habilitar el flujo.'),
          ),
          const SizedBox(height: PragmaSpacing.xl),
          const _InputPlayground(),
          const SizedBox(height: PragmaSpacing.xl),
          const _DropdownPlayground(),
          const SizedBox(height: PragmaSpacing.xl),
          const _DropdownListPlayground(),
          const SizedBox(height: PragmaSpacing.xl),
          const _AvatarPlayground(),
          const SizedBox(height: PragmaSpacing.xl),
          const _BreadcrumbPlayground(),
          const SizedBox(height: PragmaSpacing.xl),
          const _IconButtonPlayground(),
          const SizedBox(height: PragmaSpacing.xl),
          Text('Componentes documentados', style: textTheme.headlineSmall),
          const SizedBox(height: PragmaSpacing.sm),
          Column(
            children:
                documentedComponents.map((ModelPragmaComponent component) {
              return _ComponentDocCard(component: component);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

void _noop() {}

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
                hierarchy: PragmaButtonHierarchy.secondary,
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
                      hierarchy: PragmaButtonHierarchy.tertiary,
                      onPressed: _noop,
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
            color: Colors.black.withValues(alpha: 0.9),
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
                            scheme.primary
                                .withValues(alpha: PragmaOpacity.opacity8),
                            scheme.secondary
                                .withValues(alpha: PragmaOpacity.opacity8),
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

class _InputPlayground extends StatefulWidget {
  const _InputPlayground();

  @override
  State<_InputPlayground> createState() => _InputPlaygroundState();
}

class _InputPlaygroundState extends State<_InputPlayground> {
  late final PragmaInputController _controller;
  PragmaInputVariant _variant = PragmaInputVariant.filled;
  PragmaInputSize _size = PragmaInputSize.regular;
  bool _enabled = true;
  bool _passwordMode = false;
  final List<String> _suggestions = <String>[
    'Analytics Squad',
    'Aplicaciones iOS',
    'Aplicaciones Android',
    'Discovery Lab',
    'Growth',
    'Research',
  ];
  String? _lastSuggestion;

  @override
  void initState() {
    super.initState();
    _controller = PragmaInputController(
      ModelFieldState(suggestions: _suggestions),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    if (value.trim().isEmpty) {
      _controller
        ..setValidation(isDirty: true, isValid: false)
        ..setError('Dato requerido');
    } else {
      _controller
        ..setValidation(isDirty: true, isValid: true)
        ..setError(null);
    }
    setState(() {});
  }

  void _handleSuggestionSelected(String value) {
    setState(() => _lastSuggestion = value);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String statusLabel = _controller.value.errorText ??
        (_controller.value.value.isEmpty
            ? 'Esperando entrada'
            : 'Campo validado');
    final Color statusColor =
        _controller.value.errorText != null ? scheme.error : scheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaInputWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.sm),
        Wrap(
          spacing: PragmaSpacing.lg,
          runSpacing: PragmaSpacing.lg,
          alignment: WrapAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 360,
              child: PragmaInputWidget(
                label: 'Nombre del squad',
                placeholder: 'Introduce al menos 3 caracteres',
                helperText: 'Ofrecemos sugerencias de equipos activos',
                controller: _controller,
                variant: _variant,
                size: _size,
                enabled: _enabled,
                enablePasswordToggle: _passwordMode,
                obscureText: _passwordMode,
                onChanged: _handleChanged,
                onSuggestionSelected: _handleSuggestionSelected,
              ),
            ),
            SizedBox(
              width: 320,
              child: PragmaCard.section(
                headline: 'Configura el campo',
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButtonFormField<PragmaInputVariant>(
                      initialValue: _variant,
                      decoration: const InputDecoration(labelText: 'Variant'),
                      items: PragmaInputVariant.values
                          .map(
                            (PragmaInputVariant value) =>
                                DropdownMenuItem<PragmaInputVariant>(
                              value: value,
                              child: Text(value.name),
                            ),
                          )
                          .toList(),
                      onChanged: (PragmaInputVariant? value) {
                        if (value != null) {
                          setState(() => _variant = value);
                        }
                      },
                    ),
                    const SizedBox(height: PragmaSpacing.sm),
                    DropdownButtonFormField<PragmaInputSize>(
                      initialValue: _size,
                      decoration: const InputDecoration(labelText: 'Size'),
                      items: PragmaInputSize.values
                          .map(
                            (PragmaInputSize value) =>
                                DropdownMenuItem<PragmaInputSize>(
                              value: value,
                              child: Text(value.name),
                            ),
                          )
                          .toList(),
                      onChanged: (PragmaInputSize? value) {
                        if (value != null) {
                          setState(() => _size = value);
                        }
                      },
                    ),
                    const SizedBox(height: PragmaSpacing.xs),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Habilitado'),
                      value: _enabled,
                      onChanged: (bool value) =>
                          setState(() => _enabled = value),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Modo contraseña'),
                      value: _passwordMode,
                      onChanged: (bool value) =>
                          setState(() => _passwordMode = value),
                    ),
                    if (_lastSuggestion != null) ...<Widget>[
                      const SizedBox(height: PragmaSpacing.xs),
                      Text(
                        'Sugerencia seleccionada: $_lastSuggestion',
                        style: textTheme.labelMedium,
                      ),
                    ],
                    const SizedBox(height: PragmaSpacing.xs),
                    Text(
                      'Estado: $statusLabel',
                      style: textTheme.labelLarge?.copyWith(color: statusColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: PragmaSpacing.md),
        Text(
          'Valor actual: ${_controller.value.value}',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _DropdownPlayground extends StatefulWidget {
  const _DropdownPlayground();

  @override
  State<_DropdownPlayground> createState() => _DropdownPlaygroundState();
}

class _DropdownPlaygroundState extends State<_DropdownPlayground> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaDropdownWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.sm),
        Wrap(
          spacing: PragmaSpacing.lg,
          runSpacing: PragmaSpacing.lg,
          children: <Widget>[
            SizedBox(
              width: 320,
              child: PragmaDropdownWidget<String>(
                label: 'Rol asignado',
                placeholder: 'Selecciona un rol',
                helperText: 'Define permisos en tableros y reportes',
                options: _dropdownOptions,
                value: _selectedRole,
                onChanged: (String? value) {
                  setState(() => _selectedRole = value);
                },
              ),
            ),
            SizedBox(
              width: 320,
              child: PragmaDropdownWidget<String>(
                label: 'Estado de revisión',
                placeholder: 'Selecciona un estado',
                errorText: 'Campo obligatorio',
                options: _dropdownOptions,
                value: null,
                onChanged: (String? value) {
                  setState(() => _selectedRole = value);
                },
              ),
            ),
            SizedBox(
              width: 320,
              child: PragmaDropdownWidget<String>(
                label: 'Revisor asignado',
                placeholder: 'No disponible',
                enabled: false,
                options: _dropdownOptions,
                value: null,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DropdownListPlayground extends StatefulWidget {
  const _DropdownListPlayground();

  @override
  State<_DropdownListPlayground> createState() =>
      _DropdownListPlaygroundState();
}

class _DropdownListPlaygroundState extends State<_DropdownListPlayground> {
  Set<String> _selectedValues = <String>{'ux', 'ios'};
  bool _showCheckbox = true;
  bool _showIcons = true;
  bool _showRemoveAction = true;

  void _handleSelectionChanged(List<String> values) {
    setState(() => _selectedValues = values.toSet());
  }

  void _handleRemove(String value) {
    setState(() => _selectedValues.remove(value));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaDropdownListWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.sm),
        Wrap(
          spacing: PragmaSpacing.lg,
          runSpacing: PragmaSpacing.lg,
          children: <Widget>[
            SizedBox(
              width: 360,
              child: PragmaDropdownListWidget<String>(
                label: 'Equipo colaborador',
                placeholder: 'Selecciona perfiles',
                options: _dropdownListOptions,
                initialSelectedValues: _selectedValues.toList(),
                showCheckbox: _showCheckbox,
                showOptionIcons: _showIcons,
                showRemoveAction: _showRemoveAction,
                onSelectionChanged: _handleSelectionChanged,
                onItemRemoved: _handleRemove,
              ),
            ),
            SizedBox(
              width: 360,
              child: PragmaDropdownListWidget<String>(
                label: 'Resumen de equipo',
                placeholder: 'Equipo sin asignar',
                options: _dropdownListOptions,
                initialSelectedValues: _selectedValues.toList(),
                showCheckbox: false,
                showOptionIcons: false,
                showRemoveAction: true,
                summaryBuilder: (
                  BuildContext context,
                  List<PragmaDropdownOption<String>> selected,
                ) {
                  return Text(
                    '${selected.length} perfiles seleccionados',
                    style: textTheme.bodyLarge,
                  );
                },
                optionBuilder: (
                  BuildContext context,
                  PragmaDropdownOption<String> option,
                  bool isSelected,
                ) {
                  final Color iconColor =
                      isSelected ? scheme.surface : scheme.primary;
                  return Row(
                    children: <Widget>[
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        size: 16,
                        color: iconColor,
                      ),
                      const SizedBox(width: PragmaSpacing.xs),
                      Text(option.label),
                    ],
                  );
                },
                onSelectionChanged: _handleSelectionChanged,
                onItemRemoved: _handleRemove,
              ),
            ),
          ],
        ),
        const SizedBox(height: PragmaSpacing.md),
        Wrap(
          spacing: PragmaSpacing.md,
          runSpacing: PragmaSpacing.md,
          children: <Widget>[
            SizedBox(
              width: 280,
              child: SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mostrar checkbox'),
                value: _showCheckbox,
                onChanged: (bool value) =>
                    setState(() => _showCheckbox = value),
              ),
            ),
            SizedBox(
              width: 280,
              child: SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mostrar iconos'),
                value: _showIcons,
                onChanged: (bool value) => setState(() => _showIcons = value),
              ),
            ),
            SizedBox(
              width: 280,
              child: SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Acción de eliminar'),
                value: _showRemoveAction,
                onChanged: (bool value) =>
                    setState(() => _showRemoveAction = value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AvatarPlayground extends StatefulWidget {
  const _AvatarPlayground();

  @override
  State<_AvatarPlayground> createState() => _AvatarPlaygroundState();
}

class _AvatarPlaygroundState extends State<_AvatarPlayground> {
  static const double _minRadius = PragmaSpacing.sm;
  static const double _maxRadius = PragmaSpacing.xxl3;

  late final TextEditingController _initialsController;
  late final TextEditingController _imageUrlController;
  double _radius = PragmaSpacing.md;
  PragmaAvatarStyle _style = PragmaAvatarStyle.primary;
  bool _useImage = false;

  @override
  void initState() {
    super.initState();
    _initialsController = TextEditingController(text: 'PD');
    _imageUrlController = TextEditingController(
      text: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
    );
  }

  @override
  void dispose() {
    _initialsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget avatar = PragmaAvatarWidget(
      radius: _radius,
      initials: _useImage ? null : _initialsController.text,
      imageUrl: _useImage ? _imageUrlController.text : null,
      style: _style,
      tooltip: 'Avatar preview',
    );

    return PragmaCard.section(
      headline: 'PragmaAvatarWidget',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: avatar),
          const SizedBox(height: PragmaSpacing.md),
          Text(
            'Radius ${_radius.toStringAsFixed(0)} px',
            style: theme.textTheme.labelLarge,
          ),
          Slider(
            value: _radius,
            min: _minRadius,
            max: _maxRadius,
            divisions: (_maxRadius - _minRadius).toInt(),
            onChanged: (double value) => setState(() => _radius = value),
          ),
          const SizedBox(height: PragmaSpacing.sm),
          TextField(
            controller: _initialsController,
            decoration: const InputDecoration(labelText: 'Initials'),
            onChanged: (_) {
              if (!_useImage) {
                setState(() {});
              }
            },
          ),
          const SizedBox(height: PragmaSpacing.sm),
          DropdownButtonFormField<PragmaAvatarStyle>(
            initialValue: _style,
            decoration: const InputDecoration(labelText: 'Style'),
            items: PragmaAvatarStyle.values.map((PragmaAvatarStyle style) {
              return DropdownMenuItem<PragmaAvatarStyle>(
                value: style,
                child: Text(style.name),
              );
            }).toList(),
            onChanged: (PragmaAvatarStyle? value) {
              if (value != null) {
                setState(() => _style = value);
              }
            },
          ),
          const SizedBox(height: PragmaSpacing.sm),
          SwitchListTile.adaptive(
            value: _useImage,
            contentPadding: EdgeInsets.zero,
            title: const Text('Use image URL'),
            onChanged: (bool value) => setState(() => _useImage = value),
          ),
          if (_useImage) ...<Widget>[
            const SizedBox(height: PragmaSpacing.xs),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
    );
  }
}

class _BreadcrumbPlayground extends StatefulWidget {
  const _BreadcrumbPlayground();

  @override
  State<_BreadcrumbPlayground> createState() => _BreadcrumbPlaygroundState();
}

class _BreadcrumbPlaygroundState extends State<_BreadcrumbPlayground> {
  PragmaBreadcrumbType _type = PragmaBreadcrumbType.standard;
  bool _disabled = false;
  int _activeIndex = 2;

  final List<String> _labels = <String>['Inicio', 'Componentes', 'Breadcrumb'];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PragmaBreadcrumbItem> items =
        List<PragmaBreadcrumbItem>.generate(
      _labels.length,
      (int index) {
        return PragmaBreadcrumbItem(
          label: _labels[index],
          isCurrent: index == _activeIndex,
          onTap: index == _activeIndex
              ? null
              : () {
                  final ScaffoldMessengerState messenger =
                      ScaffoldMessenger.of(context);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(content: Text('Navigate to ${_labels[index]}')),
                  );
                },
        );
      },
    );

    return PragmaCard.section(
      headline: 'PragmaBreadcrumbWidget',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PragmaBreadcrumbWidget(
            items: items,
            type: _type,
            disabled: _disabled,
          ),
          const SizedBox(height: PragmaSpacing.md),
          DropdownButtonFormField<PragmaBreadcrumbType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items:
                PragmaBreadcrumbType.values.map((PragmaBreadcrumbType value) {
              return DropdownMenuItem<PragmaBreadcrumbType>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
            onChanged: (PragmaBreadcrumbType? value) {
              if (value != null) {
                setState(() => _type = value);
              }
            },
          ),
          const SizedBox(height: PragmaSpacing.sm),
          DropdownButtonFormField<int>(
            initialValue: _activeIndex,
            decoration: const InputDecoration(labelText: 'Active item'),
            items: List<DropdownMenuItem<int>>.generate(
              _labels.length,
              (int index) => DropdownMenuItem<int>(
                value: index,
                child: Text(_labels[index]),
              ),
            ),
            onChanged: (int? value) {
              if (value != null) {
                setState(() => _activeIndex = value);
              }
            },
          ),
          const SizedBox(height: PragmaSpacing.sm),
          SwitchListTile.adaptive(
            value: _disabled,
            contentPadding: EdgeInsets.zero,
            title: const Text('Disabled'),
            onChanged: (bool value) => setState(() => _disabled = value),
          ),
          const SizedBox(height: PragmaSpacing.sm),
          Text(
            'Active page: ${_labels[_activeIndex]}',
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _IconButtonPlayground extends StatefulWidget {
  const _IconButtonPlayground();

  @override
  State<_IconButtonPlayground> createState() => _IconButtonPlaygroundState();
}

class _IconButtonPlaygroundState extends State<_IconButtonPlayground> {
  PragmaIconButtonStyle _style = PragmaIconButtonStyle.filledLight;
  PragmaIconButtonSize _size = PragmaIconButtonSize.regular;
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PragmaCard.section(
      headline: 'PragmaIconButtonWidget',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Explora variantes y tamaños para superficies claras u oscuras.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: PragmaSpacing.sm),
          Wrap(
            spacing: PragmaSpacing.md,
            runSpacing: PragmaSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Style', style: textTheme.labelSmall),
                    DropdownButton<PragmaIconButtonStyle>(
                      isExpanded: true,
                      value: _style,
                      items: PragmaIconButtonStyle.values
                          .map((PragmaIconButtonStyle value) {
                        return DropdownMenuItem<PragmaIconButtonStyle>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                      onChanged: (PragmaIconButtonStyle? value) {
                        if (value != null) {
                          setState(() => _style = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Size', style: textTheme.labelSmall),
                    DropdownButton<PragmaIconButtonSize>(
                      isExpanded: true,
                      value: _size,
                      items: PragmaIconButtonSize.values
                          .map((PragmaIconButtonSize value) {
                        return DropdownMenuItem<PragmaIconButtonSize>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                      onChanged: (PragmaIconButtonSize? value) {
                        if (value != null) {
                          setState(() => _size = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Disabled'),
                  Switch(
                    value: _disabled,
                    onChanged: (bool value) =>
                        setState(() => _disabled = value),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.md),
          Wrap(
            spacing: PragmaSpacing.md,
            runSpacing: PragmaSpacing.md,
            children: <Widget>[
              PragmaIconButtonWidget(
                icon: Icons.add,
                tooltip: 'Añadir',
                style: _style,
                size: _size,
                onPressed: _disabled ? null : _noop,
              ),
              PragmaIconButtonWidget(
                icon: Icons.remove,
                tooltip: 'Quitar',
                style: PragmaIconButtonStyle.outlinedDark,
                size: _size,
                onPressed: _disabled ? null : _noop,
              ),
              PragmaIconButtonWidget(
                icon: Icons.lightbulb_outline,
                tooltip: 'Idea',
                style: PragmaIconButtonStyle.filledDark,
                size: PragmaIconButtonSize.regular,
                onPressed: _disabled ? null : _noop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComponentDocCard extends StatelessWidget {
  const _ComponentDocCard({required this.component});

  final ModelPragmaComponent component;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: PragmaSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(PragmaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              component.titleComponent,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: PragmaSpacing.xs),
            Text(component.description, style: textTheme.bodyMedium),
            if (component.useCases.isNotEmpty) ...<Widget>[
              const SizedBox(height: PragmaSpacing.md),
              Text('Casos de uso', style: textTheme.labelLarge),
              const SizedBox(height: PragmaSpacing.xs),
              Wrap(
                spacing: PragmaSpacing.sm,
                runSpacing: PragmaSpacing.xs,
                children: component.useCases.map((String useCase) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PragmaSpacing.sm,
                      vertical: PragmaSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      useCase,
                      style: textTheme.bodySmall,
                    ),
                  );
                }).toList(),
              ),
            ],
            if (component.anatomy.isNotEmpty) ...<Widget>[
              const SizedBox(height: PragmaSpacing.md),
              Text('Anatomía', style: textTheme.labelLarge),
              const SizedBox(height: PragmaSpacing.xs),
              Column(
                children: component.anatomy.map((ModelAnatomyAttribute attr) {
                  final String percentage =
                      '${(attr.value * 100).toStringAsFixed(0)}%';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: scheme.primary.withValues(
                        alpha: PragmaOpacity.opacity30,
                      ),
                      child: Text(
                        percentage,
                        style: textTheme.labelSmall,
                      ),
                    ),
                    title: Text(attr.title, style: textTheme.bodyMedium),
                    subtitle: attr.description.isEmpty
                        ? null
                        : Text(attr.description, style: textTheme.bodySmall),
                  );
                }).toList(),
              ),
            ],
            if (component.urlImages.isNotEmpty) ...<Widget>[
              const SizedBox(height: PragmaSpacing.md),
              Text('Referencias visuales', style: textTheme.labelLarge),
              const SizedBox(height: PragmaSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: component.urlImages.map((String url) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: PragmaSpacing.xs),
                    child: SelectableText(
                      url,
                      style:
                          textTheme.bodySmall?.copyWith(color: scheme.primary),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
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

const List<Map<String, dynamic>> _componentCatalog = <Map<String, dynamic>>[
  <String, dynamic>{
    'titleComponent': 'PragmaAccordionWidget',
    'description':
        'Panel expandible que gestiona su estado interno y expone callbacks.',
    'anatomy': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Header',
        'description': 'Dispara el toggle y aloja íconos auxiliares.',
        'value': 0.35,
      },
      <String, dynamic>{
        'title': 'Body',
        'description': 'Contenedor con contenido colapsable.',
        'value': 0.65,
      },
    ],
    'useCases': <String>['FAQs', 'Centros de ayuda', 'Documentación interna'],
    'urlImages': <String>[
      'https://cdn.pragma.co/components/accordion/cover.png',
    ],
  },
  <String, dynamic>{
    'titleComponent': 'PragmaScaleBox',
    'description':
        'Escala mockups de Figma al width disponible manteniendo el aspecto.',
    'anatomy': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Viewport wrapper',
        'description': 'Delimita el ancho máximo disponible.',
        'value': 0.4,
      },
      <String, dynamic>{
        'title': 'Mockup',
        'description': 'Contenido diseñado a un tamaño fijo.',
        'value': 0.6,
      },
    ],
    'useCases': <String>['Demos responsivas', 'QA visual'],
    'urlImages': <String>[
      'https://cdn.pragma.co/components/scalebox/cover.png',
    ],
  },
];

const List<PragmaDropdownOption<String>> _dropdownListOptions =
    <PragmaDropdownOption<String>>[
  PragmaDropdownOption<String>(
    label: 'UX Research',
    value: 'ux',
    icon: Icons.psychology_alt_outlined,
  ),
  PragmaDropdownOption<String>(
    label: 'Product Design',
    value: 'design',
    icon: Icons.design_services_outlined,
  ),
  PragmaDropdownOption<String>(
    label: 'Product Manager',
    value: 'pm',
    icon: Icons.view_kanban,
  ),
  PragmaDropdownOption<String>(
    label: 'Mobile iOS',
    value: 'ios',
    icon: Icons.phone_iphone,
  ),
  PragmaDropdownOption<String>(
    label: 'Mobile Android',
    value: 'android',
    icon: Icons.android,
  ),
];

const List<PragmaDropdownOption<String>> _dropdownOptions =
    <PragmaDropdownOption<String>>[
  PragmaDropdownOption<String>(
    label: 'Product Designer',
    value: 'ux',
  ),
  PragmaDropdownOption<String>(
    label: 'Product Manager',
    value: 'pm',
  ),
  PragmaDropdownOption<String>(
    label: 'iOS Engineer',
    value: 'ios',
  ),
  PragmaDropdownOption<String>(
    label: 'Android Engineer',
    value: 'android',
  ),
];

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
