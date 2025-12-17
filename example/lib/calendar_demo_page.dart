import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class CalendarDemoPage extends StatefulWidget {
  const CalendarDemoPage({super.key});

  @override
  State<CalendarDemoPage> createState() => _CalendarDemoPageState();
}

class _CalendarDemoPageState extends State<CalendarDemoPage> {
  late final PragmaCalendarController _controller;
  PragmaCalendarSelectionMode _selectionMode =
      PragmaCalendarSelectionMode.range;
  PragmaCalendarSelection _selection = const PragmaCalendarSelection();
  bool _limitRange = false;
  DateTime? _minDate;
  DateTime? _maxDate;

  @override
  void initState() {
    super.initState();
    _controller = PragmaCalendarController(
      initialMonth: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int? totalDays = _selectedDayCount();
    final String totalLabel = totalDays == null
        ? '—'
        : totalDays == 1
            ? '1 día'
            : '$totalDays días';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar demo'),
      ),
      body: ListView(
        padding: PragmaSpacing.insetSymmetric(
          horizontal: PragmaSpacing.xl,
          vertical: PragmaSpacing.lg,
        ),
        children: <Widget>[
          Text(
            'Explora las capacidades del PragmaCalendarWidget',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: PragmaSpacing.sm),
          Text(
            'Ajusta el modo de selección, aplica atajos rápidos y revisa los estados '
            'deshabilitados dentro de un contexto con tokens de Pragma.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: PragmaSpacing.lg),
          PragmaCard.section(
            headline: 'Controles',
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Modo de selección', style: textTheme.titleMedium),
                const SizedBox(height: PragmaSpacing.xs),
                SegmentedButton<PragmaCalendarSelectionMode>(
                  segments: const <ButtonSegment<PragmaCalendarSelectionMode>>[
                    ButtonSegment<PragmaCalendarSelectionMode>(
                      value: PragmaCalendarSelectionMode.single,
                      label: Text('Único'),
                      icon: Icon(Icons.radio_button_checked),
                    ),
                    ButtonSegment<PragmaCalendarSelectionMode>(
                      value: PragmaCalendarSelectionMode.range,
                      label: Text('Rango'),
                      icon: Icon(Icons.all_inclusive),
                    ),
                  ],
                  showSelectedIcon: false,
                  selected: <PragmaCalendarSelectionMode>{_selectionMode},
                  onSelectionChanged: _handleModeChanged,
                ),
                const SizedBox(height: PragmaSpacing.md),
                SwitchListTile.adaptive(
                  value: _limitRange,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Limitar fechas disponibles'),
                  subtitle: const Text(
                    'Resalta fechas deshabilitadas con un rango relativo a la fecha actual.',
                  ),
                  onChanged: _toggleLimitRange,
                ),
                if (_limitRange)
                  Padding(
                    padding: const EdgeInsets.only(top: PragmaSpacing.xs),
                    child: Wrap(
                      spacing: PragmaSpacing.sm,
                      runSpacing: PragmaSpacing.sm,
                      children: <Widget>[
                        if (_minDate != null)
                          Chip(
                            avatar: const Icon(Icons.arrow_downward, size: 16),
                            label: Text(
                              'Mínimo: ${localizations.formatMediumDate(_minDate!)}',
                            ),
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                          ),
                        if (_maxDate != null)
                          Chip(
                            avatar: const Icon(Icons.arrow_upward, size: 16),
                            label: Text(
                              'Máximo: ${localizations.formatMediumDate(_maxDate!)}',
                            ),
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                          ),
                      ],
                    ),
                  ),
                const Divider(height: PragmaSpacing.xl),
                Text('Atajos', style: textTheme.titleMedium),
                const SizedBox(height: PragmaSpacing.xs),
                Wrap(
                  spacing: PragmaSpacing.sm,
                  runSpacing: PragmaSpacing.sm,
                  children: <Widget>[
                    PragmaButton.icon(
                      label: 'Hoy',
                      icon: Icons.today,
                      hierarchy: PragmaButtonHierarchy.tertiary,
                      onPressed: _selectToday,
                    ),
                    PragmaButton.icon(
                      label: 'Semana actual',
                      icon: Icons.view_week,
                      hierarchy: PragmaButtonHierarchy.tertiary,
                      onPressed: _selectCurrentWeek,
                    ),
                    PragmaButton.icon(
                      label: 'Próximos 10 días',
                      icon: Icons.event_available,
                      hierarchy: PragmaButtonHierarchy.tertiary,
                      onPressed: _selectNextTenDays,
                    ),
                    PragmaTertiaryButton(
                      label: 'Limpiar selección',
                      onPressed: _clearSelection,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: PragmaSpacing.lg),
          PragmaCalendarWidget(
            controller: _controller,
            selectionMode: _selectionMode,
            minDate: _minDate,
            maxDate: _maxDate,
            onSelectionChanged: _handleSelectionChanged,
          ),
          const SizedBox(height: PragmaSpacing.lg),
          PragmaCard.section(
            headline: 'Selección activa',
            action: PragmaButton.icon(
              label: 'Copiar rango',
              icon: Icons.content_copy,
              hierarchy: PragmaButtonHierarchy.tertiary,
              onPressed: _selection.start == null
                  ? null
                  : () => _copySelection(localizations),
            ),
            body: Column(
              children: <Widget>[
                _SummaryTile(
                  icon: Icons.flag_outlined,
                  label: 'Inicio',
                  value: _formatDate(localizations, _selection.start),
                ),
                const Divider(height: PragmaSpacing.md),
                _SummaryTile(
                  icon: Icons.flag_outlined,
                  label: 'Fin',
                  value: _formatDate(
                    localizations,
                    _selection.end ?? _selection.start,
                  ),
                ),
                const Divider(height: PragmaSpacing.md),
                _SummaryTile(
                  icon: Icons.timelapse,
                  label: 'Total',
                  value: totalLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleModeChanged(Set<PragmaCalendarSelectionMode> values) {
    final PragmaCalendarSelectionMode mode = values.first;
    if (mode == _selectionMode) {
      return;
    }
    setState(() {
      _selectionMode = mode;
    });
    if (mode == PragmaCalendarSelectionMode.single) {
      final DateTime fallback = _selection.start ?? _selection.end ?? _today();
      _controller.setSelection(start: fallback, end: fallback);
    }
    _updateSelectionFromController();
  }

  void _handleSelectionChanged(PragmaCalendarSelection value) {
    if (!mounted) {
      return;
    }
    setState(() {
      _selection = value;
    });
  }

  void _toggleLimitRange(bool value) {
    setState(() {
      _limitRange = value;
      if (value) {
        final DateTime today = _today();
        _minDate = today.subtract(const Duration(days: 45));
        _maxDate = today.add(const Duration(days: 60));
      } else {
        _minDate = null;
        _maxDate = null;
      }
    });
    if (value) {
      _clampSelectionToBounds();
    }
  }

  void _selectToday() {
    final DateTime today = _today();
    _controller.setMonth(DateTime(today.year, today.month, 1));
    _controller.setSelection(start: today, end: today);
    _updateSelectionFromController();
  }

  void _selectCurrentWeek() {
    final DateTime today = _today();
    final DateTime start = today.subtract(Duration(days: today.weekday - 1));
    final DateTime end = start.add(const Duration(days: 6));
    _applyRange(start, end);
  }

  void _selectNextTenDays() {
    final DateTime today = _today();
    _applyRange(today, today.add(const Duration(days: 9)));
  }

  void _clearSelection() {
    _controller.clearSelection();
    _updateSelectionFromController();
  }

  void _copySelection(MaterialLocalizations localizations) {
    final DateTime? start = _selection.start;
    if (start == null) {
      return;
    }
    final DateTime end = _selection.end ?? start;
    final String label =
        '${localizations.formatFullDate(start)} - ${localizations.formatFullDate(end)}';
    Clipboard.setData(ClipboardData(text: label));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copiado: $label'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _applyRange(DateTime start, DateTime end) {
    DateTime normalizedStart = _dateOnly(start);
    DateTime normalizedEnd = _dateOnly(end);
    if (normalizedEnd.isBefore(normalizedStart)) {
      final DateTime temp = normalizedStart;
      normalizedStart = normalizedEnd;
      normalizedEnd = temp;
    }
    if (_selectionMode == PragmaCalendarSelectionMode.single) {
      normalizedEnd = normalizedStart;
    }
    _controller.setMonth(
      DateTime(normalizedStart.year, normalizedStart.month, 1),
    );
    _controller.setSelection(
      start: normalizedStart,
      end: normalizedEnd,
    );
    _updateSelectionFromController();
  }

  void _clampSelectionToBounds() {
    if (_minDate == null && _maxDate == null) {
      return;
    }
    DateTime? start = _controller.startDate;
    DateTime? end = _controller.endDate;

    if (_minDate != null) {
      if (start != null && start.isBefore(_minDate!)) {
        start = _minDate;
      }
      if (end != null && end.isBefore(_minDate!)) {
        end = _minDate;
      }
    }

    if (_maxDate != null) {
      if (start != null && start.isAfter(_maxDate!)) {
        start = _maxDate;
      }
      if (end != null && end.isAfter(_maxDate!)) {
        end = _maxDate;
      }
    }

    if (start != null && end != null && end.isBefore(start)) {
      final DateTime temp = start;
      start = end;
      end = temp;
    }

    _controller.setSelection(start: start, end: end);
    _updateSelectionFromController();
  }

  void _updateSelectionFromController() {
    if (!mounted) {
      return;
    }
    setState(() {
      _selection = PragmaCalendarSelection(
        start: _controller.startDate,
        end: _controller.endDate,
      );
    });
  }

  int? _selectedDayCount() {
    final DateTime? start = _selection.start;
    if (start == null) {
      return null;
    }
    final DateTime end = _selection.end ?? start;
    return end.difference(start).inDays.abs() + 1;
  }

  String _formatDate(MaterialLocalizations localizations, DateTime? date) {
    if (date == null) {
      return 'Sin selección';
    }
    return localizations.formatFullDate(date);
  }

  DateTime _today() => DateUtils.dateOnly(DateTime.now());

  DateTime _dateOnly(DateTime date) => DateUtils.dateOnly(date);
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: theme.textTheme.labelLarge,
      ),
      subtitle: Text(value),
    );
  }
}
