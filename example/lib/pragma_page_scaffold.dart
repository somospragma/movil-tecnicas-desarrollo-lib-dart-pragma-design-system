import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class PragmaPageScaffold extends StatefulWidget {
  const PragmaPageScaffold({super.key});

  @override
  State<PragmaPageScaffold> createState() => _PragmaPageScaffoldState();
}

class _PragmaPageScaffoldState extends State<PragmaPageScaffold> {
  bool _collapsed = false;
  String _activeId = 'dashboard';

  static final List<ModelDsSidebarMenuItem> _items = <ModelDsSidebarMenuItem>[
    ModelDsSidebarMenuItem(
      id: 'back',
      label: 'Volver',
      iconToken: DsSidebarIconToken.back,
    ),
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
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme scheme = theme.colorScheme;

    return Scaffold(
      body: SizedBox.expand(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsSidebarMenuWidget(
              title: 'Creci',
              items: _items,
              activeId: _activeId,
              collapsed: _collapsed,
              onItemTap: (String id) {
                if (id == 'back') {
                  Navigator.of(context).maybePop();
                  return;
                }
                setState(() => _activeId = id);
              },
              footer: Center(
                child: Text(
                  _collapsed ? '©' : '© Pragma',
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ),
              showCollapseToggle: false,
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border(
                    left: BorderSide(color: scheme.outlineVariant),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(PragmaSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Area de trabajo',
                            style: textTheme.headlineSmall,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _collapsed = !_collapsed),
                            icon: Icon(
                              _collapsed
                                  ? Icons.keyboard_double_arrow_right
                                  : Icons.keyboard_double_arrow_left,
                            ),
                            label: Text(
                              _collapsed ? 'Expandir' : 'Contraer',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: PragmaSpacing.xs),
                      Text(
                        'Vista activa: $_activeId',
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: PragmaSpacing.md),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: PragmaSpacing.md,
                          mainAxisSpacing: PragmaSpacing.md,
                          childAspectRatio: 1.6,
                          children: const <Widget>[
                            _WorkspaceCard(
                              title: 'Resumen',
                              subtitle: 'KPIs y estado general del squad',
                              icon: Icons.insights_outlined,
                            ),
                            _WorkspaceCard(
                              title: 'Tareas',
                              subtitle: 'Backlog y seguimiento de issues',
                              icon: Icons.task_alt,
                            ),
                            _WorkspaceCard(
                              title: 'Releases',
                              subtitle: 'Versionado y cambios pendientes',
                              icon: Icons.rocket_launch_outlined,
                            ),
                            _WorkspaceCard(
                              title: 'Alertas',
                              subtitle: 'Eventos de QA y observabilidad',
                              icon: Icons.notifications_active_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius:
            PragmaBorderRadius.circularToken(PragmaBorderRadiusTokens.l),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PragmaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: scheme.primary),
            const SizedBox(height: PragmaSpacing.xs),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: PragmaSpacing.xs),
            Expanded(
              child: Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
