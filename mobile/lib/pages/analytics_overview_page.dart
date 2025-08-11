import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';
import 'package:go_router/go_router.dart';
import '../widgets/charts.dart';

class AnalyticsOverviewPage extends ConsumerWidget {
  const AnalyticsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final bookings = state.bookings;
    final total = bookings.length;
    final confirmed = bookings.where((b) => b.status == 'Confirmed').length;
    final pending = bookings.where((b) => b.status == 'Pending').length;
    final cancelled = bookings.where((b) => b.status == 'Cancelled').length;
    final byStatus = {
      'Confirmed': confirmed,
      'Pending': pending,
      'Cancelled': cancelled,
    };
    final typeCounts = <String, int>{};
    for (final p in state.properties) {
      typeCounts[p.type] = (typeCounts[p.type] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Overview')),
      body: ListView(padding: const EdgeInsets.fromLTRB(12, 12, 12, 20), children: [
        Wrap(spacing: 12, runSpacing: 12, children: [
          _metric(context, 'Total Bookings', total.toString()),
          _metric(context, 'Confirmed', confirmed.toString()),
          _metric(context, 'Pending', pending.toString()),
          _metric(context, 'Cancelled', cancelled.toString()),
        ]),
        const SizedBox(height: 16),
        Text('Bookings by Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        BarChartSimple(data: byStatus),
        const SizedBox(height: 16),
        Text('Properties by Type', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        BarChartSimple(data: typeCounts),
      ]),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Props'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.local_offer), label: 'Offers'),
          NavigationDestination(icon: Icon(Icons.book_online_outlined), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        selectedIndex: 4,
        onDestinationSelected: (idx) {
          if (idx == 0) context.go('/');
          if (idx == 1) context.go('/events');
          if (idx == 2) context.go('/offers');
          if (idx == 3) context.go('/bookings');
          if (idx == 4) context.go('/profile');
        },
      ),
    );
  }

  Widget _metric(BuildContext context, String title, String value) => SizedBox(
        width: 160,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      );
}

