import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeCtrl extends StateNotifier<ThemeMode> {
  ThemeCtrl() : super(ThemeMode.system);
  void set(ThemeMode mode) => state = mode;
  void toggle() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      // system -> switch to dark as a visible toggle
      state = ThemeMode.dark;
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeCtrl, ThemeMode>((ref) => ThemeCtrl());

