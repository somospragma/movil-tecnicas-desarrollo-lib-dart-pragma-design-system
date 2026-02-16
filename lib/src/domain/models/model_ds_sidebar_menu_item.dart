import 'package:flutter/foundation.dart';

/// Enumerates serialized keys for [ModelDsSidebarMenuItem].
enum DsSidebarMenuItemEnum {
  id,
  label,
  iconToken,
  enabled,
  semanticLabel,
}

/// Approved icon tokens for the sidebar menu in Pragma DS.
enum DsSidebarIconToken {
  dashboard,
  projects,
  reports,
  settings,
  back,
  home,
  analytics,
  lock,
}

/// Immutable model for sidebar menu entries with JSON roundtrip support.
@immutable
class ModelDsSidebarMenuItem {
  factory ModelDsSidebarMenuItem({
    required String id,
    required String label,
    required DsSidebarIconToken iconToken,
    bool enabled = true,
    String? semanticLabel,
  }) {
    return ModelDsSidebarMenuItem._(
      id: id.trim(),
      label: label.trim(),
      iconToken: iconToken,
      enabled: enabled,
      semanticLabel: _nullableString(semanticLabel),
    );
  }

  /// Builds an item from raw JSON.
  factory ModelDsSidebarMenuItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return empty;
    }

    return ModelDsSidebarMenuItem(
      id: _string(json[DsSidebarMenuItemEnum.id.name]),
      label: _string(json[DsSidebarMenuItemEnum.label.name]),
      iconToken: _iconToken(json[DsSidebarMenuItemEnum.iconToken.name]),
      enabled: _bool(json[DsSidebarMenuItemEnum.enabled.name], fallback: true),
      semanticLabel:
          _nullableString(json[DsSidebarMenuItemEnum.semanticLabel.name]),
    );
  }

  const ModelDsSidebarMenuItem._({
    required this.id,
    required this.label,
    required this.iconToken,
    required this.enabled,
    required this.semanticLabel,
  });

  /// Empty item useful for defaults in deserialization fallback scenarios.
  static const ModelDsSidebarMenuItem empty = ModelDsSidebarMenuItem._(
    id: '',
    label: '',
    iconToken: DsSidebarIconToken.home,
    enabled: true,
    semanticLabel: null,
  );

  /// Stable id for selection/state handling.
  final String id;

  /// Visible text used in expanded mode and tooltip fallback.
  final String label;

  /// Approved token of the icon rendered by the DS.
  final DsSidebarIconToken iconToken;

  /// Whether the row can be interacted with.
  final bool enabled;

  /// Optional override for accessibility label.
  final String? semanticLabel;

  /// Serializes the model to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      DsSidebarMenuItemEnum.id.name: id,
      DsSidebarMenuItemEnum.label.name: label,
      DsSidebarMenuItemEnum.iconToken.name: iconToken.name,
      DsSidebarMenuItemEnum.enabled.name: enabled,
      DsSidebarMenuItemEnum.semanticLabel.name: semanticLabel,
    };
  }

  /// Returns a clone overriding the provided fields.
  ModelDsSidebarMenuItem copyWith({
    String? id,
    String? label,
    DsSidebarIconToken? iconToken,
    bool? enabled,
    String? semanticLabel,
  }) {
    return ModelDsSidebarMenuItem(
      id: id ?? this.id,
      label: label ?? this.label,
      iconToken: iconToken ?? this.iconToken,
      enabled: enabled ?? this.enabled,
      semanticLabel: semanticLabel ?? this.semanticLabel,
    );
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelDsSidebarMenuItem &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            label == other.label &&
            iconToken == other.iconToken &&
            enabled == other.enabled &&
            semanticLabel == other.semanticLabel;
  }

  @override
  int get hashCode => Object.hash(
        id,
        label,
        iconToken,
        enabled,
        semanticLabel,
      );

  static String _string(dynamic value) {
    if (value is String) {
      return value;
    }
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static String? _nullableString(dynamic value) {
    final String resolved = _string(value).trim();
    if (resolved.isEmpty) {
      return null;
    }
    return resolved;
  }

  static bool _bool(dynamic value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final String normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
    return fallback;
  }

  static DsSidebarIconToken _iconToken(dynamic value) {
    final String serialized = _string(value).trim();
    for (final DsSidebarIconToken token in DsSidebarIconToken.values) {
      if (token.name == serialized) {
        return token;
      }
    }
    return DsSidebarIconToken.home;
  }
}
