import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Selection behaviors supported by [PragmaCalendarWidget].
enum PragmaCalendarSelectionMode { single, range }

/// Display modes that control the current view of the calendar UI.
enum PragmaCalendarDisplayMode { month, year, decade }

/// Value object that carries the current selection range.
@immutable
class PragmaCalendarSelection {
  const PragmaCalendarSelection({this.start, this.end});

  final DateTime? start;
  final DateTime? end;

  bool get hasRange =>
      start != null && end != null && !DateUtils.isSameDay(start, end);
}

/// Central controller that stores the calendar state and notifies listeners.
class PragmaCalendarController extends ChangeNotifier {
  PragmaCalendarController({
    DateTime? initialMonth,
    DateTime? startDate,
    DateTime? endDate,
    this.displayMode = PragmaCalendarDisplayMode.month,
  })  : _currentMonth = _normalizeMonth(initialMonth ?? DateTime.now()),
        _startDate = _normalizeDateNullable(startDate),
        _endDate = _normalizeDateNullable(endDate);

  DateTime _currentMonth;
  DateTime? _startDate;
  DateTime? _endDate;
  PragmaCalendarDisplayMode displayMode;

  DateTime get currentMonth => _currentMonth;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setMonth(DateTime month) {
    final DateTime normalized = _normalizeMonth(month);
    if (_currentMonth == normalized) {
      return;
    }
    _currentMonth = normalized;
    notifyListeners();
  }

  void setDisplayMode(PragmaCalendarDisplayMode mode) {
    if (displayMode == mode) {
      return;
    }
    displayMode = mode;
    notifyListeners();
  }

  void setSelection({DateTime? start, DateTime? end}) {
    final DateTime? normalizedStart = _normalizeDateNullable(start);
    final DateTime? normalizedEnd = _normalizeDateNullable(end);
    if (_datesEqual(_startDate, normalizedStart) &&
        _datesEqual(_endDate, normalizedEnd)) {
      return;
    }
    _startDate = normalizedStart;
    _endDate = normalizedEnd;
    notifyListeners();
  }

  void clearSelection() => setSelection();

  void next() {
    switch (displayMode) {
      case PragmaCalendarDisplayMode.month:
        setMonth(_addMonths(_currentMonth, 1));
        break;
      case PragmaCalendarDisplayMode.year:
        setMonth(DateTime(_currentMonth.year + 1, _currentMonth.month));
        break;
      case PragmaCalendarDisplayMode.decade:
        setMonth(DateTime(_currentMonth.year + 12, _currentMonth.month));
        break;
    }
  }

  void previous() {
    switch (displayMode) {
      case PragmaCalendarDisplayMode.month:
        setMonth(_addMonths(_currentMonth, -1));
        break;
      case PragmaCalendarDisplayMode.year:
        setMonth(DateTime(_currentMonth.year - 1, _currentMonth.month));
        break;
      case PragmaCalendarDisplayMode.decade:
        setMonth(DateTime(_currentMonth.year - 12, _currentMonth.month));
        break;
    }
  }
}

/// Calendar widget aligned with Pragma's desktop/mobile guidelines.
class PragmaCalendarWidget extends StatefulWidget {
  const PragmaCalendarWidget({
    super.key,
    this.controller,
    this.initialMonth,
    this.initialStartDate,
    this.initialEndDate,
    this.minDate,
    this.maxDate,
    this.selectionMode = PragmaCalendarSelectionMode.range,
    this.onSelectionChanged,
  });

  final PragmaCalendarController? controller;
  final DateTime? initialMonth;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final PragmaCalendarSelectionMode selectionMode;
  final ValueChanged<PragmaCalendarSelection>? onSelectionChanged;

  @override
  State<PragmaCalendarWidget> createState() => _PragmaCalendarWidgetState();
}

class _PragmaCalendarWidgetState extends State<PragmaCalendarWidget> {
  late PragmaCalendarController _controller;
  late DateTime? _minDate;
  late DateTime? _maxDate;
  bool _ownController = false;

  @override
  void initState() {
    super.initState();
    _initController();
    _minDate = _normalizeDateNullable(widget.minDate);
    _maxDate = _normalizeDateNullable(widget.maxDate);
  }

  @override
  void didUpdateWidget(covariant PragmaCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detachController(oldWidget.controller);
      _initController();
    }
    if (oldWidget.minDate != widget.minDate) {
      setState(() => _minDate = _normalizeDateNullable(widget.minDate));
    }
    if (oldWidget.maxDate != widget.maxDate) {
      setState(() => _maxDate = _normalizeDateNullable(widget.maxDate));
    }
    if (oldWidget.selectionMode != widget.selectionMode &&
        widget.selectionMode == PragmaCalendarSelectionMode.single) {
      final DateTime? activeDate = _controller.startDate ?? _controller.endDate;
      _controller.setSelection(start: activeDate, end: activeDate);
    }
  }

  @override
  void dispose() {
    _detachController(_controller);
    super.dispose();
  }

  void _initController() {
    _controller = widget.controller ??
        PragmaCalendarController(
          initialMonth: widget.initialMonth,
          startDate: widget.initialStartDate,
          endDate: widget.selectionMode == PragmaCalendarSelectionMode.single
              ? widget.initialStartDate
              : widget.initialEndDate,
        );
    _ownController = widget.controller == null;
    _controller.addListener(_handleControllerChanged);
  }

  void _detachController(PragmaCalendarController? controller) {
    if (controller == null) {
      return;
    }
    controller.removeListener(_handleControllerChanged);
    if (_ownController) {
      controller.dispose();
    }
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String? summary = _selectionSummary(localizations);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PragmaSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeader(theme, localizations, summary),
            const SizedBox(height: PragmaSpacing.md),
            if (_controller.displayMode == PragmaCalendarDisplayMode.month)
              _buildMonthGrid(localizations)
            else if (_controller.displayMode == PragmaCalendarDisplayMode.year)
              _buildYearGrid(theme)
            else
              _buildDecadeGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    MaterialLocalizations localizations,
    String? summary,
  ) {
    final TextTheme textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Mes anterior',
              onPressed: _controller.previous,
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    localizations.formatMonthYear(_controller.currentMonth),
                    style: textTheme.titleLarge,
                  ),
                  if (summary != null)
                    Padding(
                      padding: const EdgeInsets.only(top: PragmaSpacing.xxxs),
                      child: Text(
                        summary,
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Mes siguiente',
              onPressed: _controller.next,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: PragmaSpacing.sm),
        SegmentedButton<PragmaCalendarDisplayMode>(
          segments: const <ButtonSegment<PragmaCalendarDisplayMode>>[
            ButtonSegment<PragmaCalendarDisplayMode>(
              value: PragmaCalendarDisplayMode.month,
              label: Text('Mes'),
              icon: Icon(Icons.calendar_view_month),
            ),
            ButtonSegment<PragmaCalendarDisplayMode>(
              value: PragmaCalendarDisplayMode.year,
              label: Text('Año'),
              icon: Icon(Icons.calendar_view_week),
            ),
            ButtonSegment<PragmaCalendarDisplayMode>(
              value: PragmaCalendarDisplayMode.decade,
              label: Text('Décadas'),
              icon: Icon(Icons.calendar_month),
            ),
          ],
          showSelectedIcon: false,
          selected: <PragmaCalendarDisplayMode>{_controller.displayMode},
          onSelectionChanged: (Set<PragmaCalendarDisplayMode> values) {
            _controller.setDisplayMode(values.first);
          },
        ),
      ],
    );
  }

  Widget _buildMonthGrid(MaterialLocalizations localizations) {
    final int firstDayOfWeek = localizations.firstDayOfWeekIndex;
    final List<String> weekdayLabels = List<String>.generate(7, (int index) {
      final int weekday = (firstDayOfWeek + index) % 7;
      return localizations.narrowWeekdays[weekday];
    });
    final List<_CalendarDay> days =
        _generateMonthDays(_controller.currentMonth, firstDayOfWeek);

    return Column(
      children: <Widget>[
        Row(
          children: weekdayLabels
              .map(
                (String label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: PragmaSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: PragmaSpacing.xs,
            crossAxisSpacing: PragmaSpacing.xs,
          ),
          itemCount: days.length,
          itemBuilder: (BuildContext context, int index) {
            final _CalendarDay day = days[index];
            final bool disabled = _isDisabled(day.date);
            final DateTime? start = _controller.startDate;
            final DateTime? end = _controller.endDate;
            final bool isStart =
                start != null && DateUtils.isSameDay(day.date, start);
            final bool isEnd =
                end != null && DateUtils.isSameDay(day.date, end);
            final bool inRange = start != null &&
                end != null &&
                day.date.isAfter(start) &&
                day.date.isBefore(end);
            final bool isToday = DateUtils.isSameDay(day.date, DateTime.now());

            return _CalendarDayButton(
              key: ValueKey<String>(
                'pragma_calendar_day_${day.date.toIso8601String()}',
              ),
              date: day.date,
              isCurrentMonth: day.isCurrentMonth,
              isDisabled: disabled,
              isStart: isStart,
              isEnd: isEnd,
              isInRange: inRange,
              isToday: isToday,
              onTap: disabled ? null : () => _handleDateTap(day),
            );
          },
        ),
      ],
    );
  }

  Widget _buildYearGrid(ThemeData theme) {
    final String localeName = _resolveLocaleName(context);
    final DateFormat formatter = DateFormat.MMM(localeName);
    final DateTime month = _controller.currentMonth;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: PragmaSpacing.sm,
        crossAxisSpacing: PragmaSpacing.sm,
        childAspectRatio: 2.6,
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        final DateTime candidate = DateTime(month.year, index + 1);
        final bool isActiveMonth = candidate.month == month.month;
        return _CalendarChip(
          label: formatter.format(candidate),
          isActive: isActiveMonth,
          onTap: () {
            _controller
              ..setMonth(candidate)
              ..setDisplayMode(PragmaCalendarDisplayMode.month);
          },
        );
      },
    );
  }

  Widget _buildDecadeGrid(ThemeData theme) {
    final int startYear = _decadeStartFor(_controller.currentMonth.year);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: PragmaSpacing.sm,
        crossAxisSpacing: PragmaSpacing.sm,
        childAspectRatio: 2.6,
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        final int year = startYear + index;
        final bool isActiveYear = year == _controller.currentMonth.year;
        final bool isCurrentYear = year == DateTime.now().year;
        return _CalendarChip(
          label: '$year',
          isActive: isActiveYear,
          isOutlined: isCurrentYear && !isActiveYear,
          onTap: () {
            _controller
              ..setMonth(DateTime(year, _controller.currentMonth.month))
              ..setDisplayMode(PragmaCalendarDisplayMode.year);
          },
        );
      },
    );
  }

  void _handleDateTap(_CalendarDay day) {
    if (!day.isCurrentMonth) {
      _controller.setMonth(DateTime(day.date.year, day.date.month));
    }

    if (widget.selectionMode == PragmaCalendarSelectionMode.single) {
      _applySelection(day.date, day.date);
      return;
    }

    final DateTime? start = _controller.startDate;
    final DateTime? end = _controller.endDate;

    if (start == null || (end != null)) {
      _applySelection(day.date, null);
      return;
    }

    if (day.date.isBefore(start)) {
      _applySelection(day.date, start);
    } else {
      _applySelection(start, day.date);
    }
  }

  void _applySelection(DateTime? start, DateTime? end) {
    final DateTime? normalizedStart = _normalizeDateNullable(start);
    DateTime? normalizedEnd = _normalizeDateNullable(end);

    if (widget.selectionMode == PragmaCalendarSelectionMode.single &&
        normalizedStart != null) {
      normalizedEnd = normalizedStart;
    }

    _controller.setSelection(start: normalizedStart, end: normalizedEnd);
    widget.onSelectionChanged?.call(
      PragmaCalendarSelection(
        start: normalizedStart,
        end: normalizedEnd,
      ),
    );
  }

  bool _isDisabled(DateTime date) {
    final DateTime normalized = _normalizeDate(date);
    if (_minDate != null && normalized.isBefore(_minDate!)) {
      return true;
    }
    if (_maxDate != null && normalized.isAfter(_maxDate!)) {
      return true;
    }
    return false;
  }

  String? _selectionSummary(MaterialLocalizations localizations) {
    final DateTime? start = _controller.startDate;
    if (start == null) {
      return null;
    }
    final DateTime? end = _controller.endDate;
    if (widget.selectionMode == PragmaCalendarSelectionMode.single ||
        end == null) {
      return localizations.formatCompactDate(start);
    }
    if (DateUtils.isSameDay(start, end)) {
      return localizations.formatCompactDate(start);
    }
    final String startLabel = localizations.formatCompactDate(start);
    final String endLabel = localizations.formatCompactDate(end);
    return '$startLabel – $endLabel';
  }
}

class _CalendarDay {
  const _CalendarDay({required this.date, required this.isCurrentMonth});

  final DateTime date;
  final bool isCurrentMonth;
}

class _CalendarDayButton extends StatelessWidget {
  const _CalendarDayButton({
    required this.date,
    required this.isCurrentMonth,
    required this.isDisabled,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.isToday,
    required this.onTap,
    super.key,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isDisabled;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    Color textColor = scheme.onSurface;
    if (!isCurrentMonth) {
      textColor = scheme.onSurface.withValues(alpha: 0.6);
    }
    if (isDisabled) {
      textColor = scheme.onSurface.withValues(alpha: 0.7);
    }
    Color? background;
    if (isInRange) {
      background = scheme.primary.withValues(alpha: 0.12);
    }
    if (isStart || isEnd) {
      background = scheme.primary;
      textColor = scheme.onPrimary;
    }

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Widget child = Semantics(
      selected: isStart || isEnd,
      button: true,
      label: localizations.formatMediumDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${date.day}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight:
                          isStart || isEnd ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: PragmaSpacing.xxxs),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isStart || isEnd
                            ? scheme.onPrimary
                            : scheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return child;
  }
}

class _CalendarChip extends StatelessWidget {
  const _CalendarChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isOutlined = false,
  });

  final String label;
  final bool isActive;
  final bool isOutlined;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color foreground = isActive ? scheme.onPrimary : scheme.onSurface;
    final Color background = isActive
        ? scheme.primary
        : (isOutlined ? Colors.transparent : scheme.surfaceContainerHighest);

    final OutlinedBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
      side: isOutlined
          ? BorderSide(color: scheme.primary.withValues(alpha: 0.5))
          : BorderSide.none,
    );

    return Material(
      color: background,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PragmaBorderRadius.m),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}

List<_CalendarDay> _generateMonthDays(DateTime month, int firstDayOfWeek) {
  final DateTime firstOfMonth = DateTime(month.year, month.month);
  final int weekdayIndex = _weekdayIndex(firstOfMonth);
  final int offset = (weekdayIndex - firstDayOfWeek + 7) % 7;
  final DateTime firstDisplay = firstOfMonth.subtract(Duration(days: offset));
  return List<_CalendarDay>.generate(42, (int i) {
    final DateTime date = firstDisplay.add(Duration(days: i));
    return _CalendarDay(
      date: date,
      isCurrentMonth: date.month == month.month,
    );
  });
}

int _weekdayIndex(DateTime date) => date.weekday % 7;

DateTime _addMonths(DateTime month, int months) {
  final int totalMonths = month.month - 1 + months;
  final int newYear = month.year + totalMonths ~/ 12;
  final int newMonth = (totalMonths % 12 + 12) % 12 + 1;
  return DateTime(newYear, newMonth);
}

DateTime _normalizeMonth(DateTime date) => DateTime(date.year, date.month);

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

DateTime? _normalizeDateNullable(DateTime? date) =>
    date == null ? null : _normalizeDate(date);

bool _datesEqual(DateTime? a, DateTime? b) {
  if (identical(a, b)) {
    return true;
  }
  if (a == null || b == null) {
    return false;
  }
  return a.isAtSameMomentAs(b);
}

int _decadeStartFor(int year) => (year ~/ 12) * 12;

String _resolveLocaleName(BuildContext context) {
  final Locale? locale = Localizations.maybeLocaleOf(context);
  return locale?.toLanguageTag() ?? 'en';
}
