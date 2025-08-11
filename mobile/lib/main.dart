import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/theme_controller.dart';

import 'app_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final base = ThemeData(useMaterial3: true);

    // Semantic palette applied
    final light = ColorScheme.light(
      primary: const Color(0xFF6E84FF),
      onPrimary: const Color(0xFF0A0C14),
      secondary: const Color(0xFF00E5A8),
      onSecondary: const Color(0xFF05110D),
      surface: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF0B1221),
      error: const Color(0xFFEF4444),
      onError: const Color(0xFF140808),
    ).copyWith(
      tertiary: const Color(0xFFFF6B6B),
      outline: const Color(0xFFE7EAF3),
    );

    // Dark scheme from Semantic palette
    final dark = ColorScheme.dark(
      primary: const Color(0xFF91A0FF),
      onPrimary: const Color(0xFF07090F),
      secondary: const Color(0xFF00D6A0),
      onSecondary: const Color(0xFF03100C),
      surface: const Color(0xFF121622),
      onSurface: const Color(0xFFE6EAF5),
      surfaceContainerHighest: const Color(0xFF1A2033),
      surfaceContainer: const Color(0xFF151A2A),
      onSurfaceVariant: const Color(0xFF8892B0),
      outlineVariant: const Color(0xFF242A3D),
    ).copyWith(
      tertiary: const Color(0xFFFF7D7D),
      outline: const Color(0xFF242A3D),
    );

    final scheme = light;

    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'EventXchange B2B',
      themeMode: themeMode,
      builder: (context, child) {
        final cs = Theme.of(context).colorScheme;
        return Stack(children: [
          // Primary radial glow top center
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -1.2),
                    radius: 1.2,
                    colors: [cs.primary.withValues(alpha: 0.08), Colors.transparent],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Secondary radial glow top-right
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(1.0, -0.6),
                    radius: 0.9,
                    colors: [cs.tertiary.withValues(alpha: 0.06), Colors.transparent],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          if (child != null) child,
        ]);
      },
      darkTheme: base.copyWith(
        colorScheme: dark,
        scaffoldBackgroundColor: dark.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: dark.surface,
          foregroundColor: dark.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: dark.primary.withValues(alpha: 0.16),
          labelTextStyle: WidgetStatePropertyAll(TextStyle(
            color: dark.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          )),
          iconTheme: WidgetStatePropertyAll(IconThemeData(
            color: dark.primary.withValues(alpha: 0.85),
            size: 24,
          )),
          height: 70,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xFF1A2033),
          surfaceTintColor: dark.surfaceTint,
        ),
        dividerTheme: DividerThemeData(color: dark.outline.withValues(alpha: 0.3)),
      ),
      theme: base.copyWith(
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
        textTheme: base.textTheme.copyWith(
          titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.2),
          titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.25),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.3),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
        cardTheme: base.cardTheme.copyWith(
          elevation: 0,
          color: scheme.surface.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: scheme.outline.withValues(alpha: 0.25))),
          margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: scheme.primary.withValues(alpha: 0.16),
          labelTextStyle: WidgetStatePropertyAll(TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          )),
          iconTheme: WidgetStatePropertyAll(IconThemeData(
            color: scheme.primary.withValues(alpha: 0.85),
            size: 24,
          )),
          height: 70,
        ),
        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.35)), borderRadius: const BorderRadius.all(Radius.circular(16))),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.60)), borderRadius: const BorderRadius.all(Radius.circular(16))),
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(overlayColor: WidgetStatePropertyAll(scheme.secondary.withValues(alpha: 0.08))),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: scheme.secondary,
            foregroundColor: scheme.onSecondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
        chipTheme: base.chipTheme.copyWith(shape: const StadiumBorder()),
        dividerTheme: DividerThemeData(color: scheme.outlineVariant.withValues(alpha: 0.25)),
      ),
      routerConfig: router,
    );
  }
}

