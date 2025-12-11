import 'package:flutter/widgets.dart';

/// Sistema de espaciados basado en una cuadrícula de 4px.
class PragmaSpacing {
  const PragmaSpacing._();

  static const double zero = 0;
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  static EdgeInsets insetAll(double value) => EdgeInsets.all(value);

  static EdgeInsets insetSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets insetOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }
}
