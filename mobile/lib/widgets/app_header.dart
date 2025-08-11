import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/app_state.dart';
import '../theme/theme_controller.dart';


class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final List<Widget>? trailing;
  const AppHeader({super.key, this.trailing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final pending = ref.watch(appStateProvider).bookings.where((b) => b.status == 'Pending').length;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              color: scheme.surface.withValues(alpha: 0.55),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                    child: Row(
                      children: [
                        // Brand with gradient text (primary -> tertiary)
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [scheme.primary, scheme.tertiary],
                          ).createShader(bounds),
                          blendMode: BlendMode.srcIn,
                          child: const Text(
                            'EventXchange',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Notification bell with badge
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              tooltip: 'Notifications',
                              icon: const Icon(Icons.notifications_none_rounded),
                              onPressed: () => _showNotifications(context, ref),
                            ),
                            if (pending > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                  child: Center(
                                    child: Text('$pending', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        IconButton(
                          tooltip: 'Profile',
                          icon: const Icon(Icons.person_outline),
                          onPressed: () => context.go('/profile'),
                        ),
                        IconButton(
                          tooltip: 'Theme',
                          icon: const Icon(Icons.nights_stay_outlined),
                          onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
                        ),
                        if (trailing != null) ...trailing!,
                      ],
                    ),
                  ),
                  // Lower header bar with rounded edges (glass-like separator)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          top: BorderSide(color: scheme.primary.withValues(alpha: 0.35), width: 2),
                        ),
                      ),
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

  @override
  Size get preferredSize => const Size.fromHeight(88);

  void _showNotifications(BuildContext context, WidgetRef ref) {
    final pendingBookings = ref.read(appStateProvider).bookings.where((b) => b.status == 'Pending').toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: 300,
          child: pendingBookings.isEmpty
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No pending notifications'),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${pendingBookings.length} pending booking${pendingBookings.length == 1 ? '' : 's'}'),
                    const SizedBox(height: 16),
                    ...pendingBookings.map((booking) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.event_note, color: Colors.orange),
                        title: Text(booking.eventName),
                        subtitle: Text('${booking.people} people • ${booking.contact}'),
                        trailing: const Icon(Icons.schedule, color: Colors.orange),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/bookings');
                        },
                      ),
                    )),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (pendingBookings.isNotEmpty)
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/bookings');
              },
              child: const Text('View All'),
            ),
        ],
      ),
    );
  }
}

