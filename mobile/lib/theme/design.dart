import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
}

class AppRadii {
  static const BorderRadius r8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius r12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius r14 = BorderRadius.all(Radius.circular(14));
  static const BorderRadius r16 = BorderRadius.all(Radius.circular(16));
}

class StatusColors {
  static Color forStatus(String s, ColorScheme scheme) {
    switch (s) {
      case 'Confirmed':
        return scheme.primary;
      case 'Pending':
        return scheme.tertiary;
      case 'Cancelled':
        return scheme.error;
      default:
        return scheme.onSurfaceVariant;
    }
  }
}

