import 'package:flutter/material.dart';

/// Entry that describes an option inside dropdown-based widgets.
class PragmaDropdownOption<T> {
  const PragmaDropdownOption({
    required this.label,
    required this.value,
    this.icon,
    this.enabled = true,
  });

  final String label;
  final T value;
  final IconData? icon;
  final bool enabled;
}
