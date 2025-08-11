import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  const AppBottomNav({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(color: scheme.primary.withValues(alpha: 0.10), blurRadius: 20, offset: const Offset(0, 6)),
                ],
              ),
              child: NavigationBar(
                height: 70,
                backgroundColor: Colors.transparent,
                indicatorColor: scheme.primary.withValues(alpha: 0.14),
                selectedIndex: selectedIndex,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.business_outlined),
                    selectedIcon: Icon(Icons.business, size: 26),
                    label: 'Properties'
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.local_offer_outlined),
                    selectedIcon: Icon(Icons.local_offer, size: 26),
                    label: 'Offers'
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.celebration_outlined),
                    selectedIcon: Icon(Icons.celebration, size: 26),
                    label: 'Events'
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.event_note_outlined),
                    selectedIcon: Icon(Icons.event_note, size: 26),
                    label: 'Bookings'
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.account_circle_outlined),
                    selectedIcon: Icon(Icons.account_circle, size: 26),
                    label: 'Profile'
                  ),
                ],
                onDestinationSelected: (idx) {
                  switch (idx) {
                    case 0:
                      context.go('/');
                      break;
                    case 1:
                      context.go('/offers');
                      break;
                    case 2:
                      context.go('/events');
                      break;
                    case 3:
                      context.go('/bookings');
                      break;
                    case 4:
                      context.go('/profile');
                      break;
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

