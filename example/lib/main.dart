// ignore_for_file: avoid_relative_lib_imports

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

import 'calendar_demo_page.dart';
import 'pragma_page_scaffold.dart';
import 'theme_lab_page.dart';

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

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({
    required this.mode,
    required this.onModeChanged,
    super.key,
  });

  final ThemeMode mode;
  final ValueChanged<bool> onModeChanged;

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  bool _sidebarCollapsed = false;
  String _activeSidebarId = 'overview';

  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{
    'overview': GlobalKey(),
    'tokens': GlobalKey(),
    'base': GlobalKey(),
    'navigation': GlobalKey(),
    'forms': GlobalKey(),
    'feedback': GlobalKey(),
    'data': GlobalKey(),
    'overlays': GlobalKey(),
    'docs': GlobalKey(),
  };

  static final List<ModelDsSidebarMenuItem> _sidebarItems =
      <ModelDsSidebarMenuItem>[
    ModelDsSidebarMenuItem(
      id: 'overview',
      label: 'Inicio',
      iconToken: DsSidebarIconToken.home,
    ),
    ModelDsSidebarMenuItem(
      id: 'tokens',
      label: 'Tokens',
      iconToken: DsSidebarIconToken.analytics,
    ),
    ModelDsSidebarMenuItem(
      id: 'base',
      label: 'Base',
      iconToken: DsSidebarIconToken.dashboard,
    ),
    ModelDsSidebarMenuItem(
      id: 'navigation',
      label: 'Navegacion',
      iconToken: DsSidebarIconToken.projects,
    ),
    ModelDsSidebarMenuItem(
      id: 'forms',
      label: 'Formularios',
      iconToken: DsSidebarIconToken.lock,
    ),
    ModelDsSidebarMenuItem(
      id: 'feedback',
      label: 'Feedback',
      iconToken: DsSidebarIconToken.settings,
    ),
    ModelDsSidebarMenuItem(
      id: 'data',
      label: 'Datos',
      iconToken: DsSidebarIconToken.reports,
    ),
    ModelDsSidebarMenuItem(
      id: 'overlays',
      label: 'Overlays',
      iconToken: DsSidebarIconToken.analytics,
    ),
    ModelDsSidebarMenuItem(
      id: 'docs',
      label: 'Docs',
      iconToken: DsSidebarIconToken.projects,
    ),
  ];

  void _goToSection(String id) {
    setState(() => _activeSidebarId = id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final BuildContext? targetContext = _sectionKeys[id]?.currentContext;
      if (targetContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        alignment: 0.02,
      );
    });
  }

  Widget _sectionAnchor(String id) {
    return SizedBox(key: _sectionKeys[id], height: 1);
  }

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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsSidebarMenuWidget(
            title: 'Showcase',
            items: _sidebarItems,
            activeId: _activeSidebarId,
            collapsed: _sidebarCollapsed,
            showCollapseToggle: false,
            onItemTap: _goToSection,
            footer: Center(
              child: Text(
                _sidebarCollapsed ? '©' : '© Pragma',
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  left: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: PragmaSpacing.md,
                        left: PragmaSpacing.lg,
                        right: PragmaSpacing.lg,
                      ),
                      child: DsHeaderWidget(
                        title: 'Pragma Design System',
                        actions: <Widget>[
                          DsHeaderActionSurface(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.light_mode,
                                  size: 18,
                                  color: onSurfaceVariant,
                                ),
                                Switch(
                                  value: widget.mode == ThemeMode.dark,
                                  onChanged: widget.onModeChanged,
                                ),
                                Icon(
                                  Icons.dark_mode,
                                  size: 18,
                                  color: onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Grid debugger',
                            icon: const Icon(Icons.grid_4x4_outlined),
                            onPressed: () => _openGridDebugger(context),
                          ),
                          IconButton(
                            tooltip: 'Calendar demo',
                            icon: const Icon(Icons.event_note_outlined),
                            onPressed: () => _openCalendarDemo(context),
                          ),
                          IconButton(
                            tooltip: 'Theme lab',
                            icon: const Icon(Icons.palette_outlined),
                            onPressed: () => _openThemeLab(context),
                          ),
                          IconButton(
                            tooltip: 'Page scaffold demo',
                            icon:
                                const Icon(Icons.dashboard_customize_outlined),
                            onPressed: () => _openPragmaPageScaffold(context),
                          ),
                          TextButton.icon(
                            onPressed: () => setState(
                              () => _sidebarCollapsed = !_sidebarCollapsed,
                            ),
                            icon: Icon(
                              _sidebarCollapsed
                                  ? Icons.keyboard_double_arrow_right
                                  : Icons.keyboard_double_arrow_left,
                            ),
                            label: Text(
                              _sidebarCollapsed ? 'Expandir' : 'Contraer',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: PragmaSpacing.insetSymmetric(
                          horizontal: PragmaSpacing.xl,
                          vertical: PragmaSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _sectionAnchor('overview'),
                            const _LogoShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('tokens'),
                            Text('Paleta cromática',
                                style: textTheme.headlineSmall),
                            const SizedBox(height: PragmaSpacing.md),
                            Text(
                              'Visualiza los tokens de color incluidos en la librería y cómo se agrupan por intención.',
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: onSurfaceVariant),
                            ),
                            const SizedBox(height: PragmaSpacing.lg),
                            for (final _PaletteSection section
                                in _paletteSections)
                              _PaletteSectionView(section: section),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _ColorTokenRowPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('base'),
                            Text('Componentes base',
                                style: textTheme.headlineSmall),
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
                                    PragmaBreadcrumbItem(
                                      label: 'Breadcrumb',
                                      isCurrent: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: PragmaSpacing.lg),
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
                            const SizedBox(height: PragmaSpacing.lg),
                            Text('PragmaCardWidget',
                                style: textTheme.headlineSmall),
                            const SizedBox(height: PragmaSpacing.md),
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
                                          backgroundColor: colorScheme
                                              .surfaceContainerHighest,
                                        ),
                                        Chip(
                                          label: const Text('Mobile'),
                                          backgroundColor: colorScheme
                                              .surfaceContainerHighest,
                                        ),
                                      ],
                                    ),
                                    body: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Sesiones totales',
                                          style: textTheme.titleMedium,
                                        ),
                                        const SizedBox(
                                            height: PragmaSpacing.xs),
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
                                        hierarchy:
                                            PragmaButtonHierarchy.tertiary,
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
                                          child:
                                              Icon(Icons.view_in_ar, size: 48),
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
                                        icon: const Icon(
                                            Icons.visibility_outlined),
                                        label: const Text('Abrir preview'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: PragmaSpacing.lg),
                            Text(
                              'PragmaAccordionWidget',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: PragmaSpacing.md),
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
                              child: Text(
                                'Este panel permanece cerrado hasta habilitar el flujo.',
                              ),
                            ),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('navigation'),
                            const _SidebarMenuShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('forms'),
                            const _InputPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _TextAreaShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _TagShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _BadgeShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _CheckboxShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _RadioButtonShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('feedback'),
                            const _ToastPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _LoadingShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _StepperShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('data'),
                            const _TableShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _PaginationShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _FilterShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('overlays'),
                            const _TooltipShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _SearchShowcase(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _DropdownPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _DropdownListPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _AvatarPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _BreadcrumbPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            const _IconButtonPlayground(),
                            const SizedBox(height: PragmaSpacing.lg),
                            _sectionAnchor('docs'),
                            Text(
                              'Componentes documentados',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: PragmaSpacing.md),
                            Column(
                              children: documentedComponents
                                  .map((ModelPragmaComponent component) {
                                return _ComponentDocCard(component: component);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
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

void _noop() {}

void _openGridDebugger(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const GridDebuggerPage(),
    ),
  );
}

void _openCalendarDemo(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const CalendarDemoPage(),
    ),
  );
}

void _openThemeLab(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const ThemeLabPage(),
    ),
  );
}

void _openPragmaPageScaffold(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const PragmaPageScaffold(),
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
          const SizedBox(height: PragmaSpacing.lg),
          Text(
            'Componentes sincronizados',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: PragmaSpacing.md),
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
        const SizedBox(height: PragmaSpacing.md),
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

class _TextAreaShowcase extends StatefulWidget {
  const _TextAreaShowcase();

  @override
  State<_TextAreaShowcase> createState() => _TextAreaShowcaseState();
}

class _SidebarMenuShowcase extends StatefulWidget {
  const _SidebarMenuShowcase();

  @override
  State<_SidebarMenuShowcase> createState() => _SidebarMenuShowcaseState();
}

class _SidebarMenuShowcaseState extends State<_SidebarMenuShowcase> {
  bool _collapsed = false;
  String _activeId = 'dashboard';

  static final List<ModelDsSidebarMenuItem> _items = <ModelDsSidebarMenuItem>[
    ModelDsSidebarMenuItem(
      id: 'dashboard',
      label: 'Dashboard',
      iconToken: DsSidebarIconToken.dashboard,
    ),
    ModelDsSidebarMenuItem(
      id: 'projects',
      label: 'Proyectos',
      iconToken: DsSidebarIconToken.projects,
    ),
    ModelDsSidebarMenuItem(
      id: 'reports',
      label: 'Reportes',
      iconToken: DsSidebarIconToken.reports,
    ),
    ModelDsSidebarMenuItem(
      id: 'settings',
      label: 'Configuracion',
      iconToken: DsSidebarIconToken.settings,
      enabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('DsSidebarMenuWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        Wrap(
          spacing: PragmaSpacing.lg,
          runSpacing: PragmaSpacing.lg,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            DsSidebarMenuWidget(
              title: 'Creci',
              items: _items,
              activeId: _activeId,
              collapsed: _collapsed,
              onItemTap: (String id) => setState(() => _activeId = id),
              onCollapsedToggle: (bool next) =>
                  setState(() => _collapsed = next),
              footer: const Padding(
                padding: EdgeInsets.only(top: PragmaSpacing.sm),
                child: Text(
                  'v2.0.0 · made by Prag',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 320,
              child: PragmaCard.section(
                headline: 'Configura sidebar',
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Collapsed'),
                      value: _collapsed,
                      onChanged: (bool value) =>
                          setState(() => _collapsed = value),
                    ),
                    const SizedBox(height: PragmaSpacing.xs),
                    Text(
                      'Activo: $_activeId',
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(height: PragmaSpacing.sm),
                    Wrap(
                      spacing: PragmaSpacing.xs,
                      runSpacing: PragmaSpacing.xs,
                      children: _items
                          .where((ModelDsSidebarMenuItem item) => item.enabled)
                          .map(
                            (ModelDsSidebarMenuItem item) => ChoiceChip(
                              label: Text(item.label),
                              selected: _activeId == item.id,
                              onSelected: (_) =>
                                  setState(() => _activeId = item.id),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextAreaShowcaseState extends State<_TextAreaShowcase> {
  final TextEditingController _controller = TextEditingController(
    text:
        'Documenta los acuerdos del squad, riesgos conocidos y próximos entregables en un solo lugar.',
  );
  bool _disabled = false;
  bool _showError = false;
  bool _showSuccess = false;
  bool _showCounter = true;
  int _minLines = 4;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleError(bool value) {
    setState(() {
      _showError = value;
      if (value) {
        _showSuccess = false;
      }
    });
  }

  void _toggleSuccess(bool value) {
    setState(() {
      _showSuccess = value;
      if (value) {
        _showError = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String? errorText =
        _showError ? 'Describe el bloqueo o la tarea pendiente.' : null;
    final String? successText =
        _showSuccess ? 'Listo para compartir con el squad.' : null;
    final int maxLines = _minLines + 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaTextAreaWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Briefs extensos',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Combina estados default/focus/error/success y el contador para validar escenarios del spec.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.lg,
                runSpacing: PragmaSpacing.lg,
                children: <Widget>[
                  SizedBox(
                    width: 420,
                    child: PragmaTextAreaWidget(
                      label: 'Notas del requerimiento',
                      controller: _controller,
                      placeholder:
                          'Escribe alcance, supuestos, riesgos y decisiones clave...',
                      description: _showError || _showSuccess
                          ? null
                          : 'Usa este espacio para registrar acuerdos largos.',
                      errorText: errorText,
                      successText: successText,
                      enabled: !_disabled,
                      maxLength: _showCounter ? 320 : null,
                      showCounter: _showCounter,
                      minLines: _minLines,
                      maxLines: maxLines,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropdownButtonFormField<int>(
                          initialValue: _minLines,
                          decoration: const InputDecoration(
                              labelText: 'Líneas mínimas'),
                          items: const <int>[3, 4, 5, 6]
                              .map(
                                (int value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value líneas'),
                                ),
                              )
                              .toList(),
                          onChanged: (int? value) {
                            if (value != null) {
                              setState(() => _minLines = value);
                            }
                          },
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Deshabilitar campo'),
                          value: _disabled,
                          onChanged: (bool value) =>
                              setState(() => _disabled = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Mostrar error'),
                          value: _showError,
                          onChanged: _toggleError,
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Mostrar success'),
                          value: _showSuccess,
                          onChanged: _toggleSuccess,
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Contador de caracteres'),
                          value: _showCounter,
                          onChanged: (bool value) =>
                              setState(() => _showCounter = value),
                        ),
                        const SizedBox(height: PragmaSpacing.xs),
                        Text(
                          'Caracteres actuales: ${_controller.text.length}',
                          style: textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TagShowcase extends StatefulWidget {
  const _TagShowcase();

  @override
  State<_TagShowcase> createState() => _TagShowcaseState();
}

class _TagShowcaseState extends State<_TagShowcase> {
  final List<String> _participants = <String>[
    'eugenia.sarmiento@pragma.com.co',
    'andres.burgos@pragma.com',
    'luisa.granados@pragma.com',
    'uxresearch@pragma.com',
  ];

  bool _withAvatar = true;
  bool _allowRemove = true;
  bool _disabled = false;
  String? _lastAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaTagWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Asignaciones rápidas',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Etiqueta squads, responsables o tópicos y permite eliminarlos con el ícono X.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.sm,
                runSpacing: PragmaSpacing.sm,
                children: _participants
                    .map((String email) => PragmaTagWidget(
                          label: email,
                          leading: _withAvatar
                              ? _buildAvatar(email, colorScheme)
                              : null,
                          enabled: !_disabled,
                          onPressed: _disabled
                              ? null
                              : () => setState(
                                    () => _lastAction = 'Tap: $email',
                                  ),
                          onRemove: _allowRemove && !_disabled
                              ? () => setState(
                                    () => _lastAction = 'Eliminar: $email',
                                  )
                              : null,
                        ))
                    .toList(),
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.lg,
                runSpacing: PragmaSpacing.md,
                children: <Widget>[
                  SizedBox(
                    width: 320,
                    child: Column(
                      children: <Widget>[
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Mostrar avatar'),
                          value: _withAvatar,
                          onChanged: (bool value) =>
                              setState(() => _withAvatar = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Permitir eliminar'),
                          value: _allowRemove,
                          onChanged: (bool value) =>
                              setState(() => _allowRemove = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Deshabilitar tags'),
                          value: _disabled,
                          onChanged: (bool value) =>
                              setState(() => _disabled = value),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Última interacción',
                          style: textTheme.labelMedium,
                        ),
                        const SizedBox(height: PragmaSpacing.xs),
                        Text(
                          _lastAction ?? 'Ninguna todavía',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String email, ColorScheme scheme) {
    final String alias = email.split('@').first;
    final List<String> segments = alias.split('.');
    final List<String> letters = <String>[];
    for (final String segment in segments) {
      if (segment.isEmpty) {
        continue;
      }
      letters.add(segment[0].toUpperCase());
      if (letters.length == 2) {
        break;
      }
    }
    if (letters.isEmpty && alias.isNotEmpty) {
      letters.add(alias[0].toUpperCase());
    }
    if (letters.length == 1 && alias.length > 1) {
      letters.add(alias[1].toUpperCase());
    }

    return SizedBox(
      width: 28,
      height: 28,
      child: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: Text(
          letters.join(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
    );
  }
}

class _BadgeShowcase extends StatefulWidget {
  const _BadgeShowcase();

  @override
  State<_BadgeShowcase> createState() => _BadgeShowcaseState();
}

class _BadgeShowcaseState extends State<_BadgeShowcase> {
  final TextEditingController _labelController =
      TextEditingController(text: 'Nuevo release');
  PragmaBadgeTone _tone = PragmaBadgeTone.brand;
  PragmaBadgeBrightness _brightness = PragmaBadgeBrightness.light;
  bool _dense = false;
  bool _withIcon = true;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme scheme = theme.colorScheme;
    final IconData? icon = _withIcon ? Icons.auto_awesome : null;
    final Color previewBackground = _brightness == PragmaBadgeBrightness.dark
        ? Color.lerp(scheme.surface, Colors.black, 0.65)!
        : scheme.surfaceContainerHighest.withValues(alpha: 0.4);
    final Color borderColor = scheme.outlineVariant.withValues(alpha: 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaBadgeWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Capsulas informativas',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Etiqueta estados rápidos en dashboards o tarjetas usando los tonos brand/success/warning/info/neutral.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.lg,
                runSpacing: PragmaSpacing.lg,
                children: <Widget>[
                  SizedBox(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(PragmaSpacing.md),
                          decoration: BoxDecoration(
                            color: previewBackground,
                            borderRadius:
                                BorderRadius.circular(PragmaBorderRadius.l),
                            border: Border.all(color: borderColor),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: PragmaBadgeWidget(
                              label: _labelController.text,
                              tone: _tone,
                              brightness: _brightness,
                              dense: _dense,
                              icon: icon,
                            ),
                          ),
                        ),
                        const SizedBox(height: PragmaSpacing.sm),
                        TextField(
                          controller: _labelController,
                          decoration: const InputDecoration(labelText: 'Label'),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: PragmaSpacing.sm),
                        DropdownButtonFormField<PragmaBadgeTone>(
                          initialValue: _tone,
                          decoration: const InputDecoration(labelText: 'Tone'),
                          items: PragmaBadgeTone.values
                              .map(
                                (PragmaBadgeTone tone) =>
                                    DropdownMenuItem<PragmaBadgeTone>(
                                  value: tone,
                                  child: Text(_toneLabel(tone)),
                                ),
                              )
                              .toList(),
                          onChanged: (PragmaBadgeTone? value) {
                            if (value != null) {
                              setState(() => _tone = value);
                            }
                          },
                        ),
                        const SizedBox(height: PragmaSpacing.xs),
                        SegmentedButton<PragmaBadgeBrightness>(
                          segments: const <ButtonSegment<
                              PragmaBadgeBrightness>>[
                            ButtonSegment<PragmaBadgeBrightness>(
                              value: PragmaBadgeBrightness.light,
                              label: Text('Light'),
                            ),
                            ButtonSegment<PragmaBadgeBrightness>(
                              value: PragmaBadgeBrightness.dark,
                              label: Text('Dark'),
                            ),
                          ],
                          selected: <PragmaBadgeBrightness>{_brightness},
                          showSelectedIcon: false,
                          onSelectionChanged:
                              (Set<PragmaBadgeBrightness> selection) {
                            setState(() => _brightness = selection.first);
                          },
                        ),
                        const SizedBox(height: PragmaSpacing.xs),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Modo denso'),
                          value: _dense,
                          onChanged: (bool value) =>
                              setState(() => _dense = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Mostrar ícono'),
                          value: _withIcon,
                          onChanged: (bool value) =>
                              setState(() => _withIcon = value),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 420,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Catálogo listo para copiar',
                            style: textTheme.titleSmall),
                        const SizedBox(height: PragmaSpacing.xs),
                        Text(
                          'Compara los tonos en light/dark y mezcla densidades para maquetar badges en wraps.',
                          style: textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: PragmaSpacing.sm),
                        Wrap(
                          spacing: PragmaSpacing.sm,
                          runSpacing: PragmaSpacing.sm,
                          children: _buildCatalogBadges(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCatalogBadges() {
    final List<Widget> badges = <Widget>[];
    for (final PragmaBadgeTone tone in PragmaBadgeTone.values) {
      badges
        ..add(
          PragmaBadgeWidget(
            label: _toneLabel(tone),
            tone: tone,
          ),
        )
        ..add(
          PragmaBadgeWidget(
            label: '${_toneLabel(tone)} dark',
            tone: tone,
            brightness: PragmaBadgeBrightness.dark,
            dense: true,
            icon: Icons.dark_mode,
          ),
        );
    }
    return badges;
  }

  String _toneLabel(PragmaBadgeTone tone) {
    switch (tone) {
      case PragmaBadgeTone.brand:
        return 'Brand';
      case PragmaBadgeTone.success:
        return 'Success';
      case PragmaBadgeTone.warning:
        return 'Warning';
      case PragmaBadgeTone.info:
        return 'Info';
      case PragmaBadgeTone.neutral:
        return 'Neutral';
    }
  }
}

class _CheckboxShowcase extends StatefulWidget {
  const _CheckboxShowcase();

  @override
  State<_CheckboxShowcase> createState() => _CheckboxShowcaseState();
}

class _CheckboxShowcaseState extends State<_CheckboxShowcase> {
  final List<_CheckboxItem> _items = <_CheckboxItem>[
    const _CheckboxItem(
      id: 'design',
      label: 'Sprint de diseño',
      description: 'Sketching, testeo y handoff semanal.',
    ),
    const _CheckboxItem(
      id: 'research',
      label: 'Investigación continua',
      description: 'Entrevistas y análisis de hallazgos.',
    ),
    const _CheckboxItem(
      id: 'qa',
      label: 'QA dedicado',
      description: 'Validaciones en staging antes de cada release.',
    ),
  ];

  final Set<String> _selected = <String>{'design', 'qa'};
  bool _disabled = false;
  bool _dense = false;

  bool? get _allValue {
    if (_selected.isEmpty) {
      return false;
    }
    if (_selected.length == _items.length) {
      return true;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaCheckboxWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Tareas seleccionables',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Activa múltiples iniciativas del squad, incluyendo estado indeterminado para "Seleccionar todos".',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.lg,
                runSpacing: PragmaSpacing.lg,
                children: <Widget>[
                  SizedBox(
                    width: 420,
                    child: Column(
                      children: <Widget>[
                        PragmaCheckboxWidget(
                          value: _allValue,
                          tristate: true,
                          label: 'Seleccionar todos',
                          description:
                              'Activa cada frente del squad en una sola acción.',
                          dense: _dense,
                          enabled: !_disabled,
                          onChanged: _disabled
                              ? null
                              : (bool? value) => _toggleAll(value ?? false),
                        ),
                        Divider(
                            color:
                                scheme.outlineVariant.withValues(alpha: 0.3)),
                        ..._items.map(
                          (_CheckboxItem item) => PragmaCheckboxWidget(
                            value: _selected.contains(item.id),
                            label: item.label,
                            description: item.description,
                            dense: _dense,
                            enabled: !_disabled,
                            onChanged: _disabled
                                ? null
                                : (bool? value) =>
                                    _toggleItem(item, value ?? false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Modo denso'),
                          value: _dense,
                          onChanged: (bool value) =>
                              setState(() => _dense = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Deshabilitar grupo'),
                          value: _disabled,
                          onChanged: (bool value) =>
                              setState(() => _disabled = value),
                        ),
                        const SizedBox(height: PragmaSpacing.sm),
                        Text(
                          'Seleccionados (${_selected.length}/${_items.length})',
                          style: textTheme.labelMedium,
                        ),
                        const SizedBox(height: PragmaSpacing.xs),
                        Text(
                          _selectedLabels().isEmpty
                              ? 'Ninguna iniciativa activa'
                              : _selectedLabels().join(', '),
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleAll(bool selectAll) {
    setState(() {
      if (selectAll) {
        _selected
          ..clear()
          ..addAll(_items.map((_CheckboxItem item) => item.id));
      } else {
        _selected.clear();
      }
    });
  }

  void _toggleItem(_CheckboxItem item, bool selected) {
    setState(() {
      if (selected) {
        _selected.add(item.id);
      } else {
        _selected.remove(item.id);
      }
    });
  }

  List<String> _selectedLabels() {
    return _items
        .where((_CheckboxItem item) => _selected.contains(item.id))
        .map((_CheckboxItem item) => item.label)
        .toList();
  }
}

class _CheckboxItem {
  const _CheckboxItem({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

class _RadioButtonShowcase extends StatefulWidget {
  const _RadioButtonShowcase();

  @override
  State<_RadioButtonShowcase> createState() => _RadioButtonShowcaseState();
}

class _RadioButtonShowcaseState extends State<_RadioButtonShowcase> {
  String _selected = 'design';
  bool _disabled = false;
  bool _dense = false;
  bool _showDescription = true;

  List<_RadioOption> get _options => <_RadioOption>[
        const _RadioOption(
          value: 'design',
          label: 'Diseño lider',
          description: 'Aprueba specs y prioriza componentes.',
        ),
        const _RadioOption(
          value: 'product',
          label: 'Product management',
          description: 'Gestiona roadmap y stakeholders.',
        ),
        const _RadioOption(
          value: 'tech',
          label: 'Engineering',
          description: 'Activa despliegues y monitorea builds.',
        ),
        const _RadioOption(
          value: 'readonly',
          label: 'Solo lectura',
          description: 'Consulta métricas y descargas.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaRadioButtonWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Roles mutuamente excluyentes',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Elige un responsable por recurso y valida estados unselected/selected/hover/disabled.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.lg,
                runSpacing: PragmaSpacing.lg,
                children: <Widget>[
                  SizedBox(
                    width: 420,
                    child: Column(
                      children: _options
                          .map(
                            (_RadioOption option) =>
                                PragmaRadioButtonWidget<String>(
                              value: option.value,
                              groupValue: _selected,
                              label: option.label,
                              description:
                                  _showDescription ? option.description : null,
                              dense: _dense,
                              enabled: !_disabled,
                              onChanged: _disabled
                                  ? null
                                  : (String? value) {
                                      if (value != null) {
                                        setState(() => _selected = value);
                                      }
                                    },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Mostrar descripción'),
                          value: _showDescription,
                          onChanged: (bool value) =>
                              setState(() => _showDescription = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Modo denso'),
                          value: _dense,
                          onChanged: (bool value) =>
                              setState(() => _dense = value),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Deshabilitar radios'),
                          value: _disabled,
                          onChanged: (bool value) =>
                              setState(() => _disabled = value),
                        ),
                        const SizedBox(height: PragmaSpacing.sm),
                        Text(
                          'Seleccionado: $_selected',
                          style: textTheme.labelLarge?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadioOption {
  const _RadioOption({
    required this.value,
    required this.label,
    required this.description,
  });

  final String value;
  final String label;
  final String description;
}

class _DropdownPlayground extends StatefulWidget {
  const _DropdownPlayground();

  @override
  State<_DropdownPlayground> createState() => _DropdownPlaygroundState();
}

class _ToastPlayground extends StatefulWidget {
  const _ToastPlayground();

  @override
  State<_ToastPlayground> createState() => _ToastPlaygroundState();
}

class _ToastPlaygroundState extends State<_ToastPlayground> {
  final TextEditingController _titleController =
      TextEditingController(text: 'Default Toast');
  final TextEditingController _messageController =
      TextEditingController(text: 'Este es un mensaje contextual.');
  PragmaToastVariant _variant = PragmaToastVariant.success;
  PragmaToastAlignment _alignment = PragmaToastAlignment.topCenter;
  double _durationSeconds = 6;
  bool _includeAction = false;
  int _counter = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showToast(BuildContext context) {
    final Duration duration = Duration(
      milliseconds: (_durationSeconds * 1000).round(),
    );
    PragmaToastService.showToast(
      context: context,
      title: _titleController.text,
      message: _messageController.text,
      variant: _variant,
      duration: duration,
      alignment: _alignment,
      actionLabel: _includeAction ? 'Ver log' : null,
      onActionPressed: _includeAction
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Acción ${++_counter} confirmada'),
                ),
              );
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PragmaCard.section(
      headline: 'PragmaToastWidget',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Dispara toasts con variantes neon que caen desde la parte superior.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: PragmaSpacing.md),
          Wrap(
            spacing: PragmaSpacing.lg,
            runSpacing: PragmaSpacing.lg,
            children: <Widget>[
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
              ),
              SizedBox(
                width: 420,
                child: TextField(
                  controller: _messageController,
                  decoration:
                      const InputDecoration(labelText: 'Mensaje opcional'),
                ),
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.md),
          Wrap(
            spacing: PragmaSpacing.md,
            runSpacing: PragmaSpacing.sm,
            children: <Widget>[
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<PragmaToastVariant>(
                  initialValue: _variant,
                  decoration: const InputDecoration(labelText: 'Variant'),
                  items: PragmaToastVariant.values
                      .map(
                        (PragmaToastVariant value) =>
                            DropdownMenuItem<PragmaToastVariant>(
                          value: value,
                          child: Text(value.name),
                        ),
                      )
                      .toList(),
                  onChanged: (PragmaToastVariant? value) {
                    if (value != null) {
                      setState(() => _variant = value);
                    }
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<PragmaToastAlignment>(
                  initialValue: _alignment,
                  decoration: const InputDecoration(labelText: 'Alignment'),
                  items: PragmaToastAlignment.values
                      .map(
                        (PragmaToastAlignment value) =>
                            DropdownMenuItem<PragmaToastAlignment>(
                          value: value,
                          child: Text(value.name),
                        ),
                      )
                      .toList(),
                  onChanged: (PragmaToastAlignment? value) {
                    if (value != null) {
                      setState(() => _alignment = value);
                    }
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Duración ${_durationSeconds.toStringAsFixed(1)}s',
                        style: textTheme.labelSmall),
                    Slider(
                      value: _durationSeconds,
                      min: 2,
                      max: 10,
                      divisions: 16,
                      label: '${_durationSeconds.toStringAsFixed(1)}s',
                      onChanged: (double value) =>
                          setState(() => _durationSeconds = value),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 220,
                child: SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Incluir acción secundaria'),
                  value: _includeAction,
                  onChanged: (bool value) =>
                      setState(() => _includeAction = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.md),
          PragmaButton.icon(
            label: 'Mostrar toast',
            icon: Icons.play_arrow,
            hierarchy: PragmaButtonHierarchy.primary,
            onPressed: () => _showToast(context),
          ),
        ],
      ),
    );
  }
}

class _LoadingShowcase extends StatefulWidget {
  const _LoadingShowcase();

  @override
  State<_LoadingShowcase> createState() => _LoadingShowcaseState();
}

class _LoadingShowcaseState extends State<_LoadingShowcase> {
  double _value = 0.72;
  bool _showLabels = true;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PragmaCard.section(
      headline: 'PragmaLoadingWidget',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Replica los indicadores morados con resplandor suave para estados '
            'determinísticos.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: PragmaSpacing.md),
          Wrap(
            spacing: PragmaSpacing.lg,
            runSpacing: PragmaSpacing.lg,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              PragmaLoadingWidget(
                value: _value,
                caption: 'Circular',
                size: 136,
                strokeWidth: 14,
                showPercentageLabel: _showLabels,
              ),
              const SizedBox(
                width: PragmaSpacing.xl,
              ),
              SizedBox(
                width: 280,
                child: PragmaLoadingWidget(
                  variant: PragmaLoadingVariant.linear,
                  value: _value,
                  caption: 'Progress bar',
                  showPercentageLabel: _showLabels,
                ),
              ),
            ],
          ),
          const SizedBox(height: PragmaSpacing.md),
          Text('Valor ${(_value * 100).round()}%', style: textTheme.labelLarge),
          Slider(
            value: _value,
            min: 0,
            max: 1,
            divisions: 20,
            label: '${(_value * 100).round()}%',
            onChanged: (double value) => setState(() => _value = value),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mostrar porcentaje integrado'),
            value: _showLabels,
            onChanged: (bool value) => setState(() => _showLabels = value),
          ),
        ],
      ),
    );
  }
}

class _StepperShowcase extends StatefulWidget {
  const _StepperShowcase();

  @override
  State<_StepperShowcase> createState() => _StepperShowcaseState();
}

class _StepperShowcaseState extends State<_StepperShowcase> {
  PragmaStepperSize _size = PragmaStepperSize.big;
  bool _showFailure = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<PragmaStepperStep> steps = _buildSteps(compact: false);
    final List<PragmaStepperStep> compactSteps = _buildSteps(compact: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaStepperWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Configura el flujo',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Selecciona el tamaño y simula un escenario con error o con el flujo completo.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.sm),
              SegmentedButton<PragmaStepperSize>(
                segments: const <ButtonSegment<PragmaStepperSize>>[
                  ButtonSegment<PragmaStepperSize>(
                    value: PragmaStepperSize.big,
                    label: Text('Big'),
                  ),
                  ButtonSegment<PragmaStepperSize>(
                    value: PragmaStepperSize.small,
                    label: Text('Small'),
                  ),
                ],
                selected: <PragmaStepperSize>{_size},
                onSelectionChanged: (Set<PragmaStepperSize> values) {
                  setState(() => _size = values.first);
                },
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Simular error en el último paso'),
                value: _showFailure,
                onChanged: (bool value) => setState(() => _showFailure = value),
              ),
              const SizedBox(height: PragmaSpacing.md),
              PragmaStepperWidget(steps: steps, size: _size),
              const SizedBox(height: PragmaSpacing.md),
              Text('Preset compacto', style: textTheme.titleSmall),
              const SizedBox(height: PragmaSpacing.sm),
              PragmaStepperWidget(
                steps: compactSteps,
                size: PragmaStepperSize.small,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PragmaStepperStep> _buildSteps({required bool compact}) {
    return <PragmaStepperStep>[
      PragmaStepperStep(
        title: compact ? 'Brief' : 'Discovery & Briefing',
        description: compact ? null : 'Historias aprobadas',
        status: PragmaStepperStatus.success,
      ),
      PragmaStepperStep(
        title: compact ? 'UX' : 'Investigación UX',
        description: compact ? 'Validando' : 'Puestos en pruebas con usuarios',
        status: PragmaStepperStatus.currentPurple,
      ),
      PragmaStepperStep(
        title: compact ? 'Dev' : 'Implementación',
        description: compact ? 'Pendiente' : 'Se define backlog de sprint',
        status: PragmaStepperStatus.currentWhite,
      ),
      PragmaStepperStep(
        title: compact ? 'QA' : 'QA funcional',
        description: compact
            ? (_showFailure ? 'Bloqueado' : 'Esperando dev')
            : (_showFailure ? 'Bloqueado por bug crítico' : 'Listo tras dev'),
        status: _showFailure
            ? PragmaStepperStatus.fail
            : PragmaStepperStatus.disabled,
      ),
    ];
  }
}

class _TableShowcase extends StatefulWidget {
  const _TableShowcase();

  @override
  State<_TableShowcase> createState() => _TableShowcaseState();
}

class _TableShowcaseState extends State<_TableShowcase> {
  PragmaTableRowTone _tone = PragmaTableRowTone.light;
  bool _compact = false;
  bool _hoverLastRow = true;
  int? _selectedRow;

  static const List<_TableMember> _members = <_TableMember>[
    _TableMember(
      name: 'Andreina Yajaira Francesca Serrano',
      role: 'Discovery Research · Squad Atlas',
      project: 'Discovery Lab',
      icon: Icons.auto_awesome_outlined,
    ),
    _TableMember(
      name: 'Samuel Valencia',
      role: 'Engineering Manager · Squad Pulsar',
      project: 'Onboarding Web',
      icon: Icons.settings_backup_restore_outlined,
    ),
    _TableMember(
      name: 'Gabriela Torres',
      role: 'UX Writer · Squad Cosmos',
      project: 'Comms Platform',
      icon: Icons.translate_outlined,
    ),
    _TableMember(
      name: 'Felipe Gaitán',
      role: 'iOS Developer · Squad Orbit',
      project: 'Discovery Lab',
      icon: Icons.phone_iphone_outlined,
    ),
  ];

  List<PragmaTableColumn> get _columns => const <PragmaTableColumn>[
        PragmaTableColumn(label: '', flex: 1, alignment: Alignment.centerLeft),
        PragmaTableColumn(
            label: 'Nombre', flex: 4, alignment: Alignment.centerLeft),
        PragmaTableColumn(
            label: 'Proyecto', flex: 3, alignment: Alignment.centerLeft),
        PragmaTableColumn(
            label: 'Estado', flex: 2, alignment: Alignment.center),
        PragmaTableColumn(
          label: 'Acción',
          flex: 2,
          alignment: Alignment.centerRight,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaTableWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Tablas multi-paso',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Activa el modo oscuro/claro, reduce la densidad y simula el estado hover morado.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.sm),
              SegmentedButton<PragmaTableRowTone>(
                segments: const <ButtonSegment<PragmaTableRowTone>>[
                  ButtonSegment<PragmaTableRowTone>(
                    value: PragmaTableRowTone.light,
                    label: Text('Light'),
                  ),
                  ButtonSegment<PragmaTableRowTone>(
                    value: PragmaTableRowTone.dark,
                    label: Text('Dark'),
                  ),
                ],
                selected: <PragmaTableRowTone>{_tone},
                onSelectionChanged: (Set<PragmaTableRowTone> values) {
                  setState(() => _tone = values.first);
                },
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Modo compacto'),
                value: _compact,
                onChanged: (bool value) => setState(() => _compact = value),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hover en la última fila'),
                value: _hoverLastRow,
                onChanged: (bool value) =>
                    setState(() => _hoverLastRow = value),
              ),
              const SizedBox(height: PragmaSpacing.md),
              PragmaTableWidget(
                columns: _columns,
                rows: _buildRows(),
                compact: _compact,
              ),
              const SizedBox(height: PragmaSpacing.sm),
              Text(
                'Toca una fila para marcarla como seleccionada y replicar el highlight.',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PragmaTableRowData> _buildRows() {
    return List<PragmaTableRowData>.generate(_members.length, (int index) {
      final _TableMember member = _members[index];
      final bool isSelected = _selectedRow == index;
      final bool isHoverRow = _hoverLastRow && index == _members.length - 1;

      PragmaTableRowState state = PragmaTableRowState.idle;
      if (isHoverRow) {
        state = PragmaTableRowState.hover;
      }
      if (isSelected) {
        state = PragmaTableRowState.selected;
      }

      return PragmaTableRowData(
        tone: _tone,
        state: state,
        semanticLabel: '${member.name} asignada a ${member.project}',
        onTap: () => _toggleSelection(index),
        cells: <Widget>[
          Checkbox(
            value: isSelected,
            onChanged: (_) => _toggleSelection(index),
          ),
          _TableMemberCell(member: member),
          Text(member.project, overflow: TextOverflow.ellipsis),
          Icon(member.icon),
          const PragmaTertiaryButton(
            label: 'Ver ficha',
            size: PragmaButtonSize.small,
            onPressed: _noop,
          ),
        ],
      );
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      _selectedRow = _selectedRow == index ? null : index;
    });
  }
}

class _TableMember {
  const _TableMember({
    required this.name,
    required this.role,
    required this.project,
    required this.icon,
  });

  final String name;
  final String role;
  final String project;
  final IconData icon;

  String get initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'P';
    }
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    final String first = parts.first[0].toUpperCase();
    final String second = parts[1][0].toUpperCase();
    return '$first$second';
  }
}

class _TableMemberCell extends StatelessWidget {
  const _TableMemberCell({required this.member});

  final _TableMember member;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 18,
          backgroundColor: scheme.secondaryContainer,
          child: Text(
            member.initials,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: PragmaSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultTextStyle.merge(
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: Text(member.name),
              ),
              const SizedBox(height: 2),
              DefaultTextStyle.merge(
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: Text(member.role),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaginationShowcase extends StatefulWidget {
  const _PaginationShowcase();

  @override
  State<_PaginationShowcase> createState() => _PaginationShowcaseState();
}

class _PaginationShowcaseState extends State<_PaginationShowcase> {
  static const List<int> _perPageOptions = <int>[10, 25, 50, 100];
  static const List<String> _owners = <String>[
    'Andreina Serrano',
    'Luisa Granados',
    'Samuel Valencia',
    'Gabriela Torres',
    'Felipe Gaitán',
    'Diego Salazar',
    'Juliana Pardo',
  ];
  static const List<_PaginationStatus> _statuses = <_PaginationStatus>[
    _PaginationStatus(label: 'QA activo', tone: PragmaBadgeTone.info),
    _PaginationStatus(label: 'En curso', tone: PragmaBadgeTone.warning),
    _PaginationStatus(label: 'Deploy listo', tone: PragmaBadgeTone.success),
  ];

  PragmaPaginationTone _tone = PragmaPaginationTone.dark;
  bool _showSummary = true;
  int _currentPage = 2;
  int _itemsPerPage = 25;
  double _totalItemsSlider = 180;

  int get _totalRecords => _totalItemsSlider.round();
  int get _totalPages => math.max(1, (_totalRecords / _itemsPerPage).ceil());

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<_PaginationRecord> pageRecords = _buildRecordsForPage();
    final List<_PaginationRecord> preview = pageRecords.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaPaginationWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Paginación viva',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Alterna superficie, summary y registros por página para replicar catálogos extensos.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              SegmentedButton<PragmaPaginationTone>(
                segments: const <ButtonSegment<PragmaPaginationTone>>[
                  ButtonSegment<PragmaPaginationTone>(
                    value: PragmaPaginationTone.dark,
                    label: Text('Dark'),
                  ),
                  ButtonSegment<PragmaPaginationTone>(
                    value: PragmaPaginationTone.light,
                    label: Text('Light'),
                  ),
                ],
                selected: <PragmaPaginationTone>{_tone},
                onSelectionChanged: (Set<PragmaPaginationTone> value) {
                  setState(() => _tone = value.first);
                },
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mostrar summary'),
                value: _showSummary,
                onChanged: (bool value) => setState(() => _showSummary = value),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Total de registros: $_totalRecords'),
                subtitle:
                    const Text('Usa el slider para llegar hasta 400 items.'),
                trailing: Text('$_totalPages páginas'),
              ),
              Slider(
                value: _totalItemsSlider,
                min: 60,
                max: 400,
                divisions: 17,
                label: '$_totalRecords registros',
                onChanged: (double value) {
                  setState(() {
                    _totalItemsSlider = value;
                    _currentPage = math.min(_currentPage, _totalPages);
                  });
                },
              ),
              const SizedBox(height: PragmaSpacing.sm),
              PragmaPaginationWidget(
                currentPage: _currentPage,
                totalPages: _totalPages,
                tone: _tone,
                itemsPerPage: _itemsPerPage,
                itemsPerPageOptions: _perPageOptions,
                totalItems: _totalRecords,
                showSummary: _showSummary,
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                onItemsPerPageChanged: (int value) {
                  setState(() {
                    _itemsPerPage = value;
                    _currentPage = math.min(_currentPage, _totalPages);
                  });
                },
              ),
              const SizedBox(height: PragmaSpacing.md),
              _PaginationRecordsPreview(
                records: preview,
                pageSize: pageRecords.length,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<_PaginationRecord> _buildRecordsForPage() {
    final int startIndex = (_currentPage - 1) * _itemsPerPage;
    final int endIndexExclusive =
        math.min(startIndex + _itemsPerPage, _totalRecords);
    final List<_PaginationRecord> records = <_PaginationRecord>[];
    for (int index = startIndex; index < endIndexExclusive; index += 1) {
      final _PaginationStatus status = _statuses[index % _statuses.length];
      records.add(
        _PaginationRecord(
          ticket: 'Ticket ${(index + 1).toString().padLeft(3, '0')}',
          squad: 'Squad ${(index % 8) + 1}',
          owner: _owners[index % _owners.length],
          status: status,
        ),
      );
    }
    return records;
  }
}

class _PaginationRecord {
  const _PaginationRecord({
    required this.ticket,
    required this.squad,
    required this.owner,
    required this.status,
  });

  final String ticket;
  final String squad;
  final String owner;
  final _PaginationStatus status;
}

class _PaginationStatus {
  const _PaginationStatus({required this.label, required this.tone});

  final String label;
  final PragmaBadgeTone tone;
}

class _PaginationRecordsPreview extends StatelessWidget {
  const _PaginationRecordsPreview({
    required this.records,
    required this.pageSize,
  });

  final List<_PaginationRecord> records;
  final int pageSize;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color captionColor = Theme.of(context).colorScheme.onSurfaceVariant;
    if (records.isEmpty) {
      return Text(
        'Esta página no tiene registros cargados.',
        style: textTheme.bodyMedium,
      );
    }

    final bool isFullPreview = records.length == pageSize;
    final String subtitle = isFullPreview
        ? 'Mostrando $pageSize registros en esta página.'
        : 'Vista previa de ${records.length} de $pageSize registros.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Vista previa interactiva', style: textTheme.titleMedium),
        const SizedBox(height: PragmaSpacing.xs),
        Text(subtitle,
            style: textTheme.bodySmall?.copyWith(color: captionColor)),
        const SizedBox(height: PragmaSpacing.sm),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PragmaSpacing.md),
          ),
          child: Column(
            children: List<Widget>.generate(records.length, (int index) {
              final _PaginationRecord record = records[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    title: Text(record.ticket),
                    subtitle: Text('${record.squad} · ${record.owner}'),
                    trailing: PragmaBadgeWidget(
                      label: record.status.label,
                      tone: record.status.tone,
                    ),
                  ),
                  if (index != records.length - 1) const Divider(height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _FilterShowcase extends StatefulWidget {
  const _FilterShowcase();

  @override
  State<_FilterShowcase> createState() => _FilterShowcaseState();
}

class _FilterShowcaseState extends State<_FilterShowcase> {
  Set<String> _selectedSquads = <String>{'atlas'};
  Set<String> _selectedStatuses = <String>{'qa'};
  PragmaFilterTone _tone = PragmaFilterTone.dark;
  bool _showTags = true;
  bool _showHelper = true;
  bool _enabled = true;

  static const List<PragmaFilterOption> _squadOptions = <PragmaFilterOption>[
    PragmaFilterOption(value: 'atlas', label: 'Squad Atlas', meta: 'Discovery'),
    PragmaFilterOption(value: 'cosmos', label: 'Squad Cosmos', meta: 'Comms'),
    PragmaFilterOption(value: 'orbit', label: 'Squad Orbit', meta: 'Mobile'),
    PragmaFilterOption(value: 'pulsar', label: 'Squad Pulsar', meta: 'Growth'),
  ];

  static const List<PragmaFilterOption> _statusOptions = <PragmaFilterOption>[
    PragmaFilterOption(value: 'draft', label: 'Briefing', meta: 'Ideando'),
    PragmaFilterOption(value: 'qa', label: 'QA activo', meta: 'Validando'),
    PragmaFilterOption(value: 'ready', label: 'Listo para deploy', meta: '✅'),
  ];

  static const List<_FilterRecord> _records = <_FilterRecord>[
    _FilterRecord(
      name: 'Andreina Serrano',
      role: 'Product Designer',
      squad: 'atlas',
      status: _FilterStatus.qa,
    ),
    _FilterRecord(
      name: 'Gabriela Torres',
      role: 'UX Writer',
      squad: 'cosmos',
      status: _FilterStatus.draft,
    ),
    _FilterRecord(
      name: 'Samuel Valencia',
      role: 'Engineering Manager',
      squad: 'pulsar',
      status: _FilterStatus.ready,
    ),
    _FilterRecord(
      name: 'Luisa Granados',
      role: 'iOS Developer',
      squad: 'orbit',
      status: _FilterStatus.qa,
    ),
  ];

  static const List<PragmaTableColumn> _columns = <PragmaTableColumn>[
    PragmaTableColumn(label: 'Nombre', flex: 4),
    PragmaTableColumn(label: 'Squad', flex: 2),
    PragmaTableColumn(label: 'Estado', flex: 2, alignment: Alignment.center),
    PragmaTableColumn(
      label: 'Acción',
      flex: 2,
      alignment: Alignment.centerRight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<_FilterRecord> data = _filteredRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaFilterWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Filtros flotantes',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Combina cápsulas con contador, helper text, tags y una tabla reactiva.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.lg,
                runSpacing: PragmaSpacing.lg,
                children: <Widget>[
                  SizedBox(
                    width: 320,
                    child: PragmaFilterWidget(
                      label: 'Squad',
                      options: _squadOptions,
                      selectedValues: _selectedSquads,
                      tone: _tone,
                      summaryLabel: 'Squads activos',
                      helperText: _showHelper
                          ? 'Selecciona squads para acotar la tabla.'
                          : null,
                      showSummaryTags: _showTags,
                      enabled: _enabled,
                      onChanged: (Set<String> values) {
                        setState(() => _selectedSquads = values);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: PragmaFilterWidget(
                      label: 'Estado',
                      options: _statusOptions,
                      selectedValues: _selectedStatuses,
                      tone: _tone,
                      helperText: _showHelper
                          ? 'Puedes marcar varios estados a la vez.'
                          : null,
                      showSummaryTags: _showTags,
                      enabled: _enabled,
                      onChanged: (Set<String> values) {
                        setState(() => _selectedStatuses = values);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.md,
                runSpacing: PragmaSpacing.sm,
                children: <Widget>[
                  SegmentedButton<PragmaFilterTone>(
                    segments: const <ButtonSegment<PragmaFilterTone>>[
                      ButtonSegment<PragmaFilterTone>(
                        value: PragmaFilterTone.dark,
                        label: Text('Dark'),
                      ),
                      ButtonSegment<PragmaFilterTone>(
                        value: PragmaFilterTone.light,
                        label: Text('Light'),
                      ),
                    ],
                    selected: <PragmaFilterTone>{_tone},
                    onSelectionChanged: (Set<PragmaFilterTone> values) {
                      setState(() => _tone = values.first);
                    },
                  ),
                  SizedBox(
                    width: 240,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mostrar tags'),
                      value: _showTags,
                      onChanged: (bool value) =>
                          setState(() => _showTags = value),
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Helper text'),
                      value: _showHelper,
                      onChanged: (bool value) =>
                          setState(() => _showHelper = value),
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Habilitar filtros'),
                      value: _enabled,
                      onChanged: (bool value) =>
                          setState(() => _enabled = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PragmaSpacing.md),
              PragmaTableWidget(
                columns: _columns,
                rows: _buildRows(data),
                showHeader: true,
                emptyPlaceholder: const Text(
                  'Ninguna persona coincide con los filtros aplicados.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<_FilterRecord> get _filteredRecords {
    return _records.where((_FilterRecord record) {
      final bool squadMatch =
          _selectedSquads.isEmpty || _selectedSquads.contains(record.squad);
      final bool statusMatch = _selectedStatuses.isEmpty ||
          _selectedStatuses.contains(record.status.name);
      return squadMatch && statusMatch;
    }).toList(growable: false);
  }

  List<PragmaTableRowData> _buildRows(List<_FilterRecord> records) {
    return records.map(((_FilterRecord record) {
      return PragmaTableRowData(
        tone: PragmaTableRowTone.light,
        cells: <Widget>[
          _FilterRecordCell(record: record),
          Text(_squadLabel(record.squad)),
          Align(
            alignment: Alignment.center,
            child: PragmaBadgeWidget(
              label: record.status.label,
              tone: record.status.badgeTone,
              brightness: PragmaBadgeBrightness.light,
              dense: true,
            ),
          ),
          const PragmaSecondaryButton(
            label: 'Asignar',
            size: PragmaButtonSize.small,
            onPressed: _noop,
          ),
        ],
      );
    })).toList(growable: false);
  }

  String _squadLabel(String squad) {
    for (final PragmaFilterOption option in _squadOptions) {
      if (option.value == squad) {
        return option.label;
      }
    }
    return squad;
  }
}

class _FilterRecordCell extends StatelessWidget {
  const _FilterRecordCell({required this.record});

  final _FilterRecord record;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 18,
          backgroundColor: scheme.primaryContainer,
          child: Text(
            record.initials,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: PragmaSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultTextStyle.merge(
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: Text(record.name),
              ),
              const SizedBox(height: 2),
              DefaultTextStyle.merge(
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: Text(record.role),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TooltipShowcase extends StatefulWidget {
  const _TooltipShowcase();

  @override
  State<_TooltipShowcase> createState() => _TooltipShowcaseState();
}

class _TooltipShowcaseState extends State<_TooltipShowcase> {
  PragmaTooltipTone _tone = PragmaTooltipTone.dark;
  bool _showTitle = true;
  bool _showIcon = true;
  bool _showAction = true;
  bool _longCopy = false;

  String get _message => _longCopy
      ? 'Comparte instrucciones precisas sin saturar la UI. El tooltip desaparece después de unos segundos o al salir del hover.'
      : 'Copy breve y descriptivo para guiar acciones inmediatas.';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final IconData? icon = _showIcon ? Icons.lightbulb_outline : null;
    final PragmaTooltipAction? action = _showAction
        ? PragmaTooltipAction(
            label: 'Button',
            onPressed: () => debugPrint('Tooltip action fired'),
          )
        : null;
    final String? title = _showTitle ? 'Title (optional)' : null;

    final List<_TooltipTargetConfig> targets = <_TooltipTargetConfig>[
      const _TooltipTargetConfig(
        label: 'Bottom',
        placement: PragmaTooltipPlacement.bottom,
        icon: Icons.touch_app,
      ),
      const _TooltipTargetConfig(
        label: 'Top',
        placement: PragmaTooltipPlacement.top,
        icon: Icons.keyboard_arrow_up,
      ),
      const _TooltipTargetConfig(
        label: 'Left',
        placement: PragmaTooltipPlacement.left,
        icon: Icons.arrow_back,
      ),
      const _TooltipTargetConfig(
        label: 'Right',
        placement: PragmaTooltipPlacement.right,
        icon: Icons.arrow_forward,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaTooltipWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Tooltips multivariantes',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Combina título, ícono, botón interno y arrow para simular top/bottom/left/right en light o dark.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.md,
                runSpacing: PragmaSpacing.sm,
                children: <Widget>[
                  SegmentedButton<PragmaTooltipTone>(
                    segments: const <ButtonSegment<PragmaTooltipTone>>[
                      ButtonSegment<PragmaTooltipTone>(
                        value: PragmaTooltipTone.dark,
                        label: Text('Dark'),
                      ),
                      ButtonSegment<PragmaTooltipTone>(
                        value: PragmaTooltipTone.light,
                        label: Text('Light'),
                      ),
                    ],
                    selected: <PragmaTooltipTone>{_tone},
                    onSelectionChanged: (Set<PragmaTooltipTone> values) {
                      setState(() => _tone = values.first);
                    },
                  ),
                  SizedBox(
                    width: 220,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mostrar título'),
                      value: _showTitle,
                      onChanged: (bool value) =>
                          setState(() => _showTitle = value),
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ícono inicial'),
                      value: _showIcon,
                      onChanged: (bool value) =>
                          setState(() => _showIcon = value),
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Botón interno'),
                      value: _showAction,
                      onChanged: (bool value) =>
                          setState(() => _showAction = value),
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Texto largo'),
                      value: _longCopy,
                      onChanged: (bool value) =>
                          setState(() => _longCopy = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PragmaSpacing.lg),
              Container(
                width: double.infinity,
                padding: PragmaSpacing.insetAll(PragmaSpacing.lg),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius:
                      BorderRadius.circular(PragmaBorderRadiusTokens.l.value),
                ),
                child: Wrap(
                  spacing: PragmaSpacing.lg,
                  runSpacing: PragmaSpacing.lg,
                  alignment: WrapAlignment.center,
                  children: targets.map((value) {
                    return PragmaTooltipWidget(
                      tone: _tone,
                      placement: value.placement,
                      title: title,
                      message: _message,
                      icon: icon,
                      action: action,
                      child: PragmaButton.icon(
                        label: '${value.label} tooltip',
                        icon: value.icon,
                        hierarchy: PragmaButtonHierarchy.secondary,
                        onPressed: _noop,
                        size: PragmaButtonSize.small,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TooltipTargetConfig {
  const _TooltipTargetConfig({
    required this.label,
    required this.placement,
    required this.icon,
  });

  final String label;
  final PragmaTooltipPlacement placement;
  final IconData icon;
}

class _FilterRecord {
  const _FilterRecord({
    required this.name,
    required this.role,
    required this.squad,
    required this.status,
  });

  final String name;
  final String role;
  final String squad;
  final _FilterStatus status;

  String get initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'P';
    }
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return parts.first[0].toUpperCase() + parts[1][0].toUpperCase();
  }
}

enum _FilterStatus { draft, qa, ready }

extension _FilterStatusX on _FilterStatus {
  String get label {
    switch (this) {
      case _FilterStatus.draft:
        return 'Briefing';
      case _FilterStatus.qa:
        return 'QA activo';
      case _FilterStatus.ready:
        return 'Listo para deploy';
    }
  }

  PragmaBadgeTone get badgeTone {
    switch (this) {
      case _FilterStatus.draft:
        return PragmaBadgeTone.info;
      case _FilterStatus.qa:
        return PragmaBadgeTone.warning;
      case _FilterStatus.ready:
        return PragmaBadgeTone.success;
    }
  }
}

class _SearchShowcase extends StatefulWidget {
  const _SearchShowcase();

  @override
  State<_SearchShowcase> createState() => _SearchShowcaseState();
}

class _SearchShowcaseState extends State<_SearchShowcase> {
  final TextEditingController _darkController = TextEditingController();
  final TextEditingController _lightController = TextEditingController();
  PragmaSearchSize _size = PragmaSearchSize.large;
  bool _disabled = false;
  bool _showInfo = true;

  @override
  void dispose() {
    _darkController.dispose();
    _lightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<String> darkSuggestions = _filtered(_darkController.text);
    final List<String> lightSuggestions = _filtered(_lightController.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('PragmaSearchWidget', style: textTheme.headlineSmall),
        const SizedBox(height: PragmaSpacing.md),
        PragmaCard.section(
          headline: 'Búsqueda con glow',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Explora los estados default/hover/filled usando los tonos light y dark. '
                'Al escribir mostramos sugerencias tipo “dropdown list” para simular el flujo del spec.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: PragmaSpacing.sm),
              SegmentedButton<PragmaSearchSize>(
                segments: const <ButtonSegment<PragmaSearchSize>>[
                  ButtonSegment<PragmaSearchSize>(
                    value: PragmaSearchSize.small,
                    label: Text('Small'),
                  ),
                  ButtonSegment<PragmaSearchSize>(
                    value: PragmaSearchSize.large,
                    label: Text('Large'),
                  ),
                ],
                selected: <PragmaSearchSize>{_size},
                onSelectionChanged: (Set<PragmaSearchSize> values) {
                  setState(() => _size = values.first);
                },
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Deshabilitar campo'),
                value: _disabled,
                onChanged: (bool value) => setState(() => _disabled = value),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mostrar texto informativo'),
                value: _showInfo,
                onChanged: (bool value) => setState(() => _showInfo = value),
              ),
              const SizedBox(height: PragmaSpacing.md),
              Wrap(
                spacing: PragmaSpacing.lg,
                runSpacing: PragmaSpacing.lg,
                children: <Widget>[
                  _buildSearchColumn(
                    context: context,
                    title: 'Dark preset',
                    controller: _darkController,
                    tone: PragmaSearchTone.dark,
                    suggestions: darkSuggestions,
                  ),
                  _buildSearchColumn(
                    context: context,
                    title: 'Light preset',
                    controller: _lightController,
                    tone: PragmaSearchTone.light,
                    suggestions: lightSuggestions,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchColumn({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required PragmaSearchTone tone,
    required List<String> suggestions,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: textTheme.titleSmall),
          const SizedBox(height: PragmaSpacing.xs),
          PragmaSearchWidget(
            controller: controller,
            placeholder: 'Placeholder text here...',
            tone: tone,
            size: _size,
            enabled: !_disabled,
            infoText: _showInfo
                ? 'Usa palabras clave o despliega opciones con Dropdown list.'
                : null,
            onChanged: (_) => setState(() {}),
            onSubmitted: (String value) => _announceSearch(context, value),
            onClear: () => _announceSearch(context, ''),
          ),
          if (suggestions.isNotEmpty) ...<Widget>[
            const SizedBox(height: PragmaSpacing.xs),
            _SearchSuggestionPanel(
              items: suggestions,
              onSelected: (String value) {
                controller
                  ..text = value
                  ..selection = TextSelection.collapsed(offset: value.length);
                setState(() {});
                _announceSearch(context, value);
              },
            ),
          ],
        ],
      ),
    );
  }

  List<String> _filtered(String query) {
    if (query.trim().isEmpty) {
      return const <String>[];
    }
    final String normalized = query.toLowerCase();
    return _searchTopics
        .where((String topic) => topic.toLowerCase().contains(normalized))
        .take(4)
        .toList(growable: false);
  }

  void _announceSearch(BuildContext context, String query) {
    if (!mounted) {
      return;
    }
    final String message =
        query.isEmpty ? 'Búsqueda reiniciada' : 'Buscar "$query"';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
  }
}

class _SearchSuggestionPanel extends StatelessWidget {
  const _SearchSuggestionPanel({
    required this.items,
    required this.onSelected,
  });

  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PragmaSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
        color: scheme.surfaceContainerLowest,
        border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (String item) => ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.search, size: 16),
                title: Text(item),
                onTap: () => onSelected(item),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
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
        const SizedBox(height: PragmaSpacing.md),
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
        const SizedBox(height: PragmaSpacing.md),
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

class _ColorTokenRowPlayground extends StatefulWidget {
  const _ColorTokenRowPlayground();

  @override
  State<_ColorTokenRowPlayground> createState() =>
      _ColorTokenRowPlaygroundState();
}

class _LogoShowcase extends StatefulWidget {
  const _LogoShowcase();

  @override
  State<_LogoShowcase> createState() => _LogoShowcaseState();
}

class _LogoShowcaseState extends State<_LogoShowcase> {
  PragmaLogoVariant _variant = PragmaLogoVariant.wordmark;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PragmaCard.section(
      headline: 'PragmaLogoWidget',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Visualiza las variantes oficiales y cómo responden al tema. El widget detecta automáticamente si debe usar el asset claro u oscuro.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: PragmaSpacing.md),
          PragmaLogoWidget(
            width: 220,
            variant: _variant,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: PragmaSpacing.md),
          SegmentedButton<PragmaLogoVariant>(
            segments: PragmaLogoVariant.values
                .map(
                  (PragmaLogoVariant variant) =>
                      ButtonSegment<PragmaLogoVariant>(
                    value: variant,
                    label: Text(_labelForVariant(variant)),
                  ),
                )
                .toList(),
            selected: <PragmaLogoVariant>{_variant},
            showSelectedIcon: false,
            onSelectionChanged: (Set<PragmaLogoVariant> selection) {
              setState(() => _variant = selection.first);
            },
          ),
        ],
      ),
    );
  }

  String _labelForVariant(PragmaLogoVariant variant) {
    switch (variant) {
      case PragmaLogoVariant.wordmark:
        return 'Wordmark';
      case PragmaLogoVariant.app:
        return 'App logo';
      case PragmaLogoVariant.isotypeCircle:
        return 'Isotipo circular';
      case PragmaLogoVariant.isotypeCircles:
        return 'Isotipo círculos';
    }
  }
}

class _ColorTokenRowPlaygroundState extends State<_ColorTokenRowPlayground> {
  late final List<ModelColorToken> _tokens;

  @override
  void initState() {
    super.initState();
    _tokens = <ModelColorToken>[
      ModelColorToken(label: 'Primary', color: '#6750A4'),
      ModelColorToken(label: 'Secondary', color: '#625B71'),
      ModelColorToken(label: 'Tertiary', color: '#7D5260'),
      ModelColorToken(label: 'Neutral', color: '#1C1B1F'),
    ];
  }

  void _updateToken(int index, ModelColorToken updated) {
    setState(() => _tokens[index] = updated);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PragmaSpacing.md),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PragmaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Editor rápido de tokens', style: textTheme.titleLarge),
            const SizedBox(height: PragmaSpacing.xs),
            Text(
              'Modifica el valor HEX y observa cómo los previews reflejan el color.',
              style: textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: PragmaSpacing.md),
            ...List<Widget>.generate(_tokens.length, (int index) {
              return PragmaColorTokenRowWidget(
                key: ValueKey('color-token-row-$index'),
                token: _tokens[index],
                onChanged: (ModelColorToken updated) =>
                    _updateToken(index, updated),
              );
            }),
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
              dataRowMinHeight: PragmaSpacing.xl,
              dataRowMaxHeight: PragmaSpacing.xl + (PragmaSpacing.xxxs * 2),
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
                        DataCell(
                          _PaletteCell(
                            child: _ColorPreview(color: color.color),
                          ),
                        ),
                        DataCell(
                          _PaletteCell(child: Text(color.name)),
                        ),
                        DataCell(
                          _PaletteCell(child: Text(color.hex)),
                        ),
                        DataCell(
                          _PaletteCell(child: Text(color.token)),
                        ),
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

class _PaletteCell extends StatelessWidget {
  const _PaletteCell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PragmaSpacing.xxxs),
      child: child,
    );
  }
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: PragmaSpacing.xl,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(PragmaSpacing.sm),
        ),
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
  <String, dynamic>{
    'titleComponent': 'PragmaBadgeWidget',
    'description':
        'Capsulas informativas con tonos brand/success/warning/info/neutral listos para superfícies claras u oscuras.',
    'anatomy': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Contenedor',
        'description': 'Capsula full radius con borde de 1dp.',
        'value': 0.4,
      },
      <String, dynamic>{
        'title': 'Ícono opcional',
        'description': 'Elemento de 16px que refuerza el estado.',
        'value': 0.15,
      },
      <String, dynamic>{
        'title': 'Label',
        'description': 'Texto bold 12px truncado a una línea.',
        'value': 0.45,
      },
    ],
    'useCases': <String>[
      'Etiquetas de estado',
      'Dashboards',
      'Metadatos en tarjetas',
    ],
    'urlImages': <String>[
      'https://cdn.pragma.co/components/badge/cover.png',
    ],
  },
  <String, dynamic>{
    'titleComponent': 'PragmaFilterWidget',
    'description':
        'Filtro mejorado para tablas que despliega un panel flotante multi-select, contador y tags persistentes.',
    'anatomy': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Cápsula',
        'description': 'Surface con contador e ícono para abrir el panel.',
        'value': 0.3,
      },
      <String, dynamic>{
        'title': 'Panel',
        'description':
            'Lista de checkboxes, helper text y acciones Filtrar/Limpiar.',
        'value': 0.45,
      },
      <String, dynamic>{
        'title': 'Tags activos',
        'description': 'Resumen de opciones aplicadas fuera de la tabla.',
        'value': 0.25,
      },
    ],
    'useCases': <String>[
      'Tablas extensas',
      'Dashboards de datos',
      'Listas jerarquizadas'
    ],
    'urlImages': <String>[
      'https://cdn.pragma.co/components/filter/cover.png',
    ],
  },
  <String, dynamic>{
    'titleComponent': 'PragmaPaginationWidget',
    'description':
        'Paginador con cápsula glow, flechas, páginas numeradas y dropdown "por página" sincronizado con el summary.',
    'anatomy': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Cápsula principal',
        'description': 'Surface light/dark con degradado, flechas y números.',
        'value': 0.4,
      },
      <String, dynamic>{
        'title': 'Dropdown por página',
        'description': 'Control comprimido para elegir 10/25/50/100 registros.',
        'value': 0.25,
      },
      <String, dynamic>{
        'title': 'Summary',
        'description': 'Etiqueta accesible con rango (1-25 de 240).',
        'value': 0.35,
      },
    ],
    'useCases': <String>['Tablas extensas', 'Listas de catálogo', 'Reportes'],
    'urlImages': <String>[
      'https://cdn.pragma.co/components/pagination/cover.png',
    ],
  },
  <String, dynamic>{
    'titleComponent': 'PragmaTooltipWidget',
    'description':
        'Tooltip con gradiente morado o surface clara, título opcional, ícono y botón interno más arrow en las cuatro direcciones.',
    'anatomy': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Cápsula',
        'description':
            'Surface 16dp con glow y borde para alojar el contenido.',
        'value': 0.4,
      },
      <String, dynamic>{
        'title': 'Contenido',
        'description': 'Ícono, título y copy principal.',
        'value': 0.35,
      },
      <String, dynamic>{
        'title': 'Botón interno',
        'description': 'Acción terciaria opcional.',
        'value': 0.15,
      },
      <String, dynamic>{
        'title': 'Arrow',
        'description': 'Triángulo que apunta al elemento asociado.',
        'value': 0.1,
      },
    ],
    'useCases': <String>[
      'Formularios densos',
      'Icon buttons sin label',
      'Atajos rápidos',
    ],
    'urlImages': <String>[
      'https://cdn.pragma.co/components/tooltip/cover.png',
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

const List<String> _searchTopics = <String>[
  'Discovery Lab',
  'Growth Squad',
  'Research Guild',
  'Design System backlog',
  'Mobile Core initiatives',
  'Onboarding Web',
  'Analytics Squad',
  'QA Automation',
  'Payments Platform',
  'Content Studio',
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
