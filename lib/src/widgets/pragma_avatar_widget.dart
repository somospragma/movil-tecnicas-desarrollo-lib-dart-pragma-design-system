import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

/// Visual avatar that follows the Pragma guidelines.
///
/// The widget accepts an image URL/provider, an icon, or initials. Radius is a
/// double value (in logical pixels) so squads can match custom grids while
/// staying within the spacing tokens defined by the system.
class PragmaAvatarWidget extends StatelessWidget {
  const PragmaAvatarWidget({
    super.key,
    this.imageUrl,
    this.image,
    this.initials,
    this.icon,
    this.tooltip,
    this.onTap,
    this.semanticLabel,
    this.radius = PragmaSpacing.md,
    this.style = PragmaAvatarStyle.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 0,
  });

  /// URL that points to the avatar image.
  final String? imageUrl;

  /// Provide a custom image provider when you already have the bytes loaded.
  final ImageProvider? image;

  /// Initials displayed when there is no image available.
  final String? initials;

  /// Icon used when neither image nor initials are available.
  final IconData? icon;

  /// Optional tooltip message.
  final String? tooltip;

  /// Tap handler to turn the avatar into an interactive surface.
  final VoidCallback? onTap;

  /// Extra semantics label for screen readers.
  final String? semanticLabel;

  /// Avatar visual style (maps to the color palette).
  final PragmaAvatarStyle style;

  /// Overrides the surface color (usually not needed).
  final Color? backgroundColor;

  /// Overrides the text/icon color.
  final Color? foregroundColor;

  /// Custom border color.
  final Color? borderColor;

  /// Custom border width.
  final double borderWidth;

  /// Radius of the avatar (logical pixels). Clamped to spacing tokens.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final _PragmaAvatarPalette palette = _paletteForStyle(scheme);
    final double diameter = radius * 2;
    final bool hasImageSource =
        image != null || (imageUrl != null && imageUrl!.isNotEmpty);
    final String? sanitizedInitials = _initialsToDisplay(initials);

    Widget content;
    if (hasImageSource) {
      content = ClipOval(
        child: Image(
          image: image ?? NetworkImage(imageUrl!),
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stack) {
            return _buildFallbackContent(context, palette, sanitizedInitials);
          },
        ),
      );
    } else {
      content = _buildFallbackContent(context, palette, sanitizedInitials);
    }

    Widget avatarSurface = Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.background,
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? palette.border,
                width: borderWidth,
              )
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    final String semanticsValue = semanticLabel ??
        sanitizedInitials ??
        (hasImageSource ? 'User avatar' : 'Avatar placeholder');

    avatarSurface = Semantics(
      label: semanticsValue,
      child: avatarSurface,
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      avatarSurface = Tooltip(message: tooltip, child: avatarSurface);
    }

    if (onTap != null) {
      avatarSurface = Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: avatarSurface,
        ),
      );
    }

    return avatarSurface;
  }

  Widget _buildFallbackContent(
    BuildContext context,
    _PragmaAvatarPalette palette,
    String? sanitizedInitials,
  ) {
    if (sanitizedInitials != null) {
      final TextStyle baseStyle =
          Theme.of(context).textTheme.titleMedium ?? const TextStyle();
      return Text(
        sanitizedInitials,
        style: baseStyle.copyWith(
          fontSize: radius * 0.9,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? palette.foreground,
        ),
      );
    }

    final IconData resolvedIcon = icon ?? Icons.person;
    return Icon(
      resolvedIcon,
      size: radius,
      color: foregroundColor ?? palette.foreground,
    );
  }

  String? _initialsToDisplay(String? value) {
    if (value == null) {
      return null;
    }
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (trimmed.length <= 2) {
      return trimmed.toUpperCase();
    }
    return trimmed.substring(0, 2).toUpperCase();
  }

  _PragmaAvatarPalette _paletteForStyle(ColorScheme scheme) {
    switch (style) {
      case PragmaAvatarStyle.inverse:
        return _PragmaAvatarPalette(
          background: scheme.onSurface,
          foreground: scheme.surface,
          border: Colors.transparent,
        );
      case PragmaAvatarStyle.neutral:
        return _PragmaAvatarPalette(
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurfaceVariant,
          border: scheme.outlineVariant,
        );
      case PragmaAvatarStyle.primary:
        return _PragmaAvatarPalette(
          background: scheme.primary,
          foreground: scheme.onPrimary,
          border: Colors.transparent,
        );
    }
  }
}

/// Visual variants available for the avatar widget.
enum PragmaAvatarStyle { primary, inverse, neutral }

class _PragmaAvatarPalette {
  const _PragmaAvatarPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
