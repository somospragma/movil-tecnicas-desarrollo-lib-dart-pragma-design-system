import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Visual variants supported by [PragmaToastWidget].
enum PragmaToastVariant { success, error, alert, information }

/// Alignments supported by [PragmaToastService].
enum PragmaToastAlignment { topCenter, topRight }

/// Configuration object describing the toast content and behavior.
class PragmaToastConfig {
  const PragmaToastConfig({
    required this.title,
    this.message,
    this.variant = PragmaToastVariant.information,
    this.duration = const Duration(milliseconds: 5000),
    this.leadingIcon,
    this.iconColor,
    this.closeIcon,
    this.closeIconColor,
    this.actionLabel,
    this.onActionPressed,
    this.onCloseIconPressed,
    this.onIconClick,
    this.semanticsLabel,
  });

  /// Primary headline displayed inside the toast.
  final String title;

  /// Secondary body text.
  final String? message;

  /// Variant that controls palette and icon defaults.
  final PragmaToastVariant variant;

  /// Time the toast remains visible before auto-dismissing.
  final Duration duration;

  /// Optional icon that overrides the variant default.
  final IconData? leadingIcon;

  /// Color override for the leading icon.
  final Color? iconColor;

  /// Optional custom icon for the close/dismiss button.
  final IconData? closeIcon;

  /// Color override for the close icon.
  final Color? closeIconColor;

  /// Optional action label rendered as a ghost button.
  final String? actionLabel;

  /// Callback when the action button is pressed.
  final VoidCallback? onActionPressed;

  /// Callback fired after the close icon is tapped.
  final VoidCallback? onCloseIconPressed;

  /// Callback fired when the leading icon is tapped.
  final VoidCallback? onIconClick;

  /// Custom semantics label announced by accessibility services.
  final String? semanticsLabel;

  PragmaToastConfig copyWith({
    String? title,
    String? message,
    PragmaToastVariant? variant,
    Duration? duration,
    IconData? leadingIcon,
    Color? iconColor,
    IconData? closeIcon,
    Color? closeIconColor,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onCloseIconPressed,
    VoidCallback? onIconClick,
    String? semanticsLabel,
  }) {
    return PragmaToastConfig(
      title: title ?? this.title,
      message: message ?? this.message,
      variant: variant ?? this.variant,
      duration: duration ?? this.duration,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      iconColor: iconColor ?? this.iconColor,
      closeIcon: closeIcon ?? this.closeIcon,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      actionLabel: actionLabel ?? this.actionLabel,
      onActionPressed: onActionPressed ?? this.onActionPressed,
      onCloseIconPressed: onCloseIconPressed ?? this.onCloseIconPressed,
      onIconClick: onIconClick ?? this.onIconClick,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
    );
  }
}

/// Handle returned by [PragmaToastService.show] that allows manual dismissal.
class PragmaToastHandle {
  PragmaToastHandle._(this._queue, this._id);

  final _PragmaToastQueue _queue;
  final int _id;

  /// Whether the toast is still visible or in the process of being dismissed.
  bool get isActive => _queue.contains(_id);

  /// Dismisses the toast before the auto-dismiss duration ends.
  void dismiss() {
    _queue.scheduleRemoval(_id);
  }
}

/// Global service that injects Pragma toasts using overlay entries.
class PragmaToastService {
  PragmaToastService._();

  static final PragmaToastService instance = PragmaToastService._();

  final Map<_ToastOverlayKey, _PragmaToastQueue> _queues =
      <_ToastOverlayKey, _PragmaToastQueue>{};

  /// Displays a toast overlay tied to the nearest root [Overlay].
  PragmaToastHandle show({
    required BuildContext context,
    required String title,
    String? message,
    PragmaToastVariant variant = PragmaToastVariant.information,
    Duration duration = const Duration(milliseconds: 5000),
    IconData? leadingIcon,
    Color? iconColor,
    IconData? closeIcon,
    Color? closeIconColor,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onCloseIconPressed,
    VoidCallback? onIconClick,
    String? semanticsLabel,
    PragmaToastAlignment alignment = PragmaToastAlignment.topCenter,
  }) {
    final OverlayState overlay = Overlay.of(
      context,
      rootOverlay: true,
    );
    if (overlay == null) {
      throw StateError(
          'PragmaToastService.show requires an Overlay in context');
    }
    final _ToastOverlayKey key = _ToastOverlayKey(overlay, alignment);
    final _PragmaToastQueue queue = _queues.putIfAbsent(key, () {
      return _PragmaToastQueue(
        overlay: overlay,
        alignment: alignment,
        onEmpty: () => _queues.remove(key),
      );
    });

    final PragmaToastConfig config = PragmaToastConfig(
      title: title,
      message: message,
      variant: variant,
      duration: duration,
      leadingIcon: leadingIcon,
      iconColor: iconColor,
      closeIcon: closeIcon,
      closeIconColor: closeIconColor,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onCloseIconPressed: onCloseIconPressed,
      onIconClick: onIconClick,
      semanticsLabel: semanticsLabel,
    );

    return queue.enqueue(config);
  }

  /// Convenience static wrapper.
  static PragmaToastHandle showToast({
    required BuildContext context,
    required String title,
    String? message,
    PragmaToastVariant variant = PragmaToastVariant.information,
    Duration duration = const Duration(milliseconds: 5000),
    IconData? leadingIcon,
    Color? iconColor,
    IconData? closeIcon,
    Color? closeIconColor,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onCloseIconPressed,
    VoidCallback? onIconClick,
    String? semanticsLabel,
    PragmaToastAlignment alignment = PragmaToastAlignment.topCenter,
  }) {
    return instance.show(
      context: context,
      title: title,
      message: message,
      variant: variant,
      duration: duration,
      leadingIcon: leadingIcon,
      iconColor: iconColor,
      closeIcon: closeIcon,
      closeIconColor: closeIconColor,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onCloseIconPressed: onCloseIconPressed,
      onIconClick: onIconClick,
      semanticsLabel: semanticsLabel,
      alignment: alignment,
    );
  }
}

class _ToastOverlayKey {
  _ToastOverlayKey(this.overlay, this.alignment);

  final OverlayState overlay;
  final PragmaToastAlignment alignment;

  @override
  bool operator ==(Object other) {
    return other is _ToastOverlayKey &&
        identical(other.overlay, overlay) &&
        other.alignment == alignment;
  }

  @override
  int get hashCode => Object.hash(overlay, alignment);
}

class _PragmaToastQueue extends ChangeNotifier {
  _PragmaToastQueue({
    required this.overlay,
    required this.alignment,
    required this.onEmpty,
  });

  final OverlayState overlay;
  final PragmaToastAlignment alignment;
  final VoidCallback onEmpty;
  final List<_ActiveToast> _toasts = <_ActiveToast>[];
  OverlayEntry? _entry;
  int _seed = 0;

  UnmodifiableListView<_ActiveToast> get toasts =>
      UnmodifiableListView<_ActiveToast>(_toasts);

  PragmaToastHandle enqueue(PragmaToastConfig config) {
    _ensureEntry();
    final _ActiveToast toast = _ActiveToast(
      id: _seed++,
      config: config,
    );
    _toasts.add(toast);
    notifyListeners();
    toast.startTimer(() => scheduleRemoval(toast.id));
    return PragmaToastHandle._(this, toast.id);
  }

  void _ensureEntry() {
    if (_entry != null) {
      _entry!.markNeedsBuild();
      return;
    }
    _entry = OverlayEntry(
      builder: (BuildContext context) {
        return _PragmaToastStack(queue: this);
      },
    );
    overlay.insert(_entry!);
  }

  void scheduleRemoval(int id) {
    final _ActiveToast? toast = _toasts.cast<_ActiveToast?>().firstWhere(
          (_ActiveToast? candidate) => candidate?.id == id,
          orElse: () => null,
        );
    if (toast == null || toast.closing.value) {
      return;
    }
    toast.markClosing();
  }

  bool contains(int id) => _toasts.any((_) => _.id == id);

  void finalizeRemoval(_ActiveToast toast) {
    final bool removed = _toasts.remove(toast);
    if (!removed) {
      return;
    }
    toast.disposeTimer();
    notifyListeners();
    if (_toasts.isEmpty) {
      _entry?.remove();
      _entry = null;
      onEmpty();
    }
  }

  @override
  void dispose() {
    for (final _ActiveToast toast in _toasts) {
      toast.disposeTimer();
    }
    _toasts.clear();
    _entry?.remove();
    _entry = null;
    super.dispose();
  }
}

class _ActiveToast {
  _ActiveToast({
    required this.id,
    required this.config,
  }) : closing = ValueNotifier<bool>(false);

  final int id;
  final PragmaToastConfig config;
  final ValueNotifier<bool> closing;
  Timer? _timer;
  bool _removed = false;
  bool _notifierDisposed = false;

  void startTimer(VoidCallback callback) {
    _timer = Timer(config.duration, callback);
  }

  void markClosing() {
    if (_removed) {
      return;
    }
    _timer?.cancel();
    if (_notifierDisposed) {
      return;
    }
    if (!closing.value) {
      closing.value = true;
    }
  }

  void disposeTimer() {
    _removed = true;
    _timer?.cancel();
  }

  void disposeNotifier() {
    if (_notifierDisposed) {
      return;
    }
    _notifierDisposed = true;
    closing.dispose();
  }
}

class _PragmaToastStack extends StatefulWidget {
  const _PragmaToastStack({required this.queue});

  final _PragmaToastQueue queue;

  @override
  State<_PragmaToastStack> createState() => _PragmaToastStackState();
}

class _PragmaToastStackState extends State<_PragmaToastStack> {
  @override
  void initState() {
    super.initState();
    widget.queue.addListener(_onQueueChanged);
  }

  @override
  void didUpdateWidget(covariant _PragmaToastStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queue != widget.queue) {
      oldWidget.queue.removeListener(_onQueueChanged);
      widget.queue.addListener(_onQueueChanged);
    }
  }

  @override
  void dispose() {
    widget.queue.removeListener(_onQueueChanged);
    super.dispose();
  }

  void _onQueueChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.queue.toasts.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<_ActiveToast> toasts = widget.queue.toasts;
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < toasts.length; i++) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : PragmaSpacing.md),
          child: _PragmaToastHost(
            key: ValueKey<int>(toasts[i].id),
            toast: toasts[i],
            onRemoved: () => widget.queue.finalizeRemoval(toasts[i]),
            onRequestClose: () => widget.queue.scheduleRemoval(toasts[i].id),
          ),
        ),
      );
    }

    final _ToastAlignmentMetrics metrics =
        _ToastAlignmentMetrics.resolve(widget.queue.alignment);

    return SafeArea(
      minimum: const EdgeInsets.symmetric(
        horizontal: PragmaSpacing.xl,
        vertical: PragmaSpacing.lg,
      ),
      child: Align(
        alignment: metrics.alignment,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: metrics.crossAxisAlignment,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _PragmaToastHost extends StatefulWidget {
  const _PragmaToastHost({
    required this.toast,
    required this.onRemoved,
    required this.onRequestClose,
    super.key,
  });

  final _ActiveToast toast;
  final VoidCallback onRemoved;
  final VoidCallback onRequestClose;

  @override
  State<_PragmaToastHost> createState() => _PragmaToastHostState();
}

class _PragmaToastHostState extends State<_PragmaToastHost>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 320);

  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
      reverseDuration: _animationDuration,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    widget.toast.closing.addListener(_handleClosingChanged);
    _controller.addStatusListener(_handleStatusChanged);
    unawaited(_controller.forward());
  }

  @override
  void didUpdateWidget(covariant _PragmaToastHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.toast != widget.toast) {
      oldWidget.toast.closing.removeListener(_handleClosingChanged);
      widget.toast.closing.addListener(_handleClosingChanged);
    }
  }

  @override
  void dispose() {
    widget.toast.closing.removeListener(_handleClosingChanged);
    widget.toast.disposeNotifier();
    _controller.removeStatusListener(_handleStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleClosingChanged() {
    if (!mounted) {
      return;
    }
    if (widget.toast.closing.value) {
      _controller.reverse();
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && widget.toast.closing.value) {
      widget.onRemoved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: PragmaToastWidget(
          key: ValueKey<String>('pragma_toast_${widget.toast.id}'),
          config: widget.toast.config,
          onClose: widget.onRequestClose,
        ),
      ),
    );
  }
}

class _ToastAlignmentMetrics {
  const _ToastAlignmentMetrics({
    required this.alignment,
    required this.crossAxisAlignment,
  });

  final Alignment alignment;
  final CrossAxisAlignment crossAxisAlignment;

  static _ToastAlignmentMetrics resolve(PragmaToastAlignment alignment) {
    switch (alignment) {
      case PragmaToastAlignment.topRight:
        return const _ToastAlignmentMetrics(
          alignment: Alignment.topRight,
          crossAxisAlignment: CrossAxisAlignment.end,
        );
      case PragmaToastAlignment.topCenter:
      default:
        return const _ToastAlignmentMetrics(
          alignment: Alignment.topCenter,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
    }
  }
}

/// Public widget that renders the toast surface aligned to the Pragma spec.
class PragmaToastWidget extends StatelessWidget {
  const PragmaToastWidget({
    required this.config,
    required this.onClose,
    super.key,
  });

  final PragmaToastConfig config;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final _ToastPalette palette =
        _ToastPalette.resolve(theme.colorScheme, config.variant);

    final IconData? iconData = config.leadingIcon ?? palette.icon;
    final IconData closeIcon = config.closeIcon ?? Icons.close_rounded;
    final String semanticsLabel = config.semanticsLabel ??
        '${palette.label} toast: ${config.title}${config.message == null ? '' : ", ${config.message}"}';

    return FocusTraversalGroup(
      child: Semantics(
        label: semanticsLabel,
        liveRegion: true,
        container: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: palette.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(PragmaBorderRadius.full),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.glow,
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PragmaSpacing.lg,
                vertical: PragmaSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (iconData != null)
                    GestureDetector(
                      onTap: config.onIconClick,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: palette.iconBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconData,
                          color: config.iconColor ?? palette.iconColor,
                          size: 20,
                        ),
                      ),
                    ),
                  const SizedBox(width: PragmaSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          config.title,
                          style: textTheme.titleMedium?.copyWith(
                            color: palette.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (config.message != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: PragmaSpacing.xs),
                            child: Text(
                              config.message!,
                              style: textTheme.bodyMedium?.copyWith(
                                color:
                                    palette.textColor.withValues(alpha: 0.92),
                              ),
                            ),
                          ),
                        if (config.actionLabel != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: PragmaSpacing.sm),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: palette.textColor,
                                backgroundColor:
                                    palette.textColor.withValues(alpha: 0.12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PragmaSpacing.md,
                                  vertical: PragmaSpacing.xs,
                                ),
                              ),
                              onPressed: config.onActionPressed,
                              child: Text(config.actionLabel!),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    onPressed: () {
                      config.onCloseIconPressed?.call();
                      onClose();
                    },
                    icon: Icon(
                      closeIcon,
                      color: config.closeIconColor ?? palette.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastPalette {
  const _ToastPalette({
    required this.gradient,
    required this.glow,
    required this.textColor,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
  });

  final List<Color> gradient;
  final Color glow;
  final Color textColor;
  final IconData? icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;

  static _ToastPalette resolve(ColorScheme scheme, PragmaToastVariant variant) {
    switch (variant) {
      case PragmaToastVariant.success:
        return _ToastPalette(
          gradient: <Color>[scheme.tertiary, scheme.tertiaryContainer],
          glow: scheme.tertiary.withValues(alpha: 0.45),
          textColor: scheme.onTertiaryContainer,
          icon: Icons.check_circle,
          iconColor: scheme.onTertiary,
          iconBackground: scheme.onTertiary.withValues(alpha: 0.18),
          label: 'Success',
        );
      case PragmaToastVariant.error:
        return _ToastPalette(
          gradient: <Color>[scheme.error, scheme.errorContainer],
          glow: scheme.error.withValues(alpha: 0.4),
          textColor: scheme.onError,
          icon: Icons.error_outline,
          iconColor: scheme.onError,
          iconBackground: scheme.onError.withValues(alpha: 0.18),
          label: 'Error',
        );
      case PragmaToastVariant.alert:
        return _ToastPalette(
          gradient: <Color>[scheme.secondary, scheme.secondaryContainer],
          glow: scheme.secondary.withValues(alpha: 0.35),
          textColor: scheme.onSecondary,
          icon: Icons.warning_amber_outlined,
          iconColor: scheme.onSecondary,
          iconBackground: scheme.onSecondary.withValues(alpha: 0.18),
          label: 'Alert',
        );
      case PragmaToastVariant.information:
      default:
        return _ToastPalette(
          gradient: <Color>[scheme.primary, scheme.primaryContainer],
          glow: scheme.primary.withValues(alpha: 0.4),
          textColor: scheme.onPrimary,
          icon: Icons.info_outline,
          iconColor: scheme.onPrimary,
          iconBackground: scheme.onPrimary.withValues(alpha: 0.18),
          label: 'Information',
        );
    }
  }
}
