import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';
import 'package:go_router/go_router.dart';
import '../widgets/empty_state.dart';
import '../widgets/app_header.dart';


import '../widgets/dialog_shell.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});
  @override
  ConsumerState<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage> {
  String filter = 'All';
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final bookings = state.bookings.where((b) => filter == 'All' || b.status == filter).toList();
    return Scaffold(
      appBar: const AppHeader(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(children: [
            Text('Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(width: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in ['All','Confirmed','Pending','Cancelled']) _chip(s),
            ]),
          ]),
        ),
        Expanded(
          child: bookings.isEmpty
              ? const EmptyState(icon: Icons.book_online_outlined, title: 'No bookings yet', subtitle: 'Bookings will appear here')
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final b = bookings[i];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => _showBookingDetails(b),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              _statusDot(b.status),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(b.eventName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text('${b.date} • ${b.people} people'),
                                  Text(b.contact, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                ]),
                              ),
                              const SizedBox(width: 8),
                              if (b.status != 'Confirmed')
                                TextButton.icon(onPressed: () => ref.read(appStateProvider.notifier).setBookingStatus(b.id, 'Confirmed'), icon: const Icon(Icons.check, size: 20), label: const Text('Confirm')),
                              if (b.status != 'Cancelled')
                                TextButton.icon(onPressed: () => ref.read(appStateProvider.notifier).setBookingStatus(b.id, 'Cancelled'), icon: const Icon(Icons.close, size: 20), label: const Text('Cancel')),
                              const Icon(Icons.chevron_right, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Props'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.local_offer), label: 'Offers'),
          NavigationDestination(icon: Icon(Icons.book_online_outlined), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onDestinationSelected: (idx) {
          if (idx == 0) context.go('/');
          if (idx == 1) context.go('/events');
          if (idx == 2) context.go('/offers');
          if (idx == 4) context.go('/profile');
        },
        selectedIndex: 3,
      ),
    );
  }

  Widget _chip(String s) {
    final bool selected = filter == s;
    Color color;
    switch (s) {
      case 'Confirmed':
        color = Colors.green;
        break;
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.blueGrey;
    }
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(s),
      selected: selected,
      selectedColor: (selected ? color : scheme.surfaceTint).withValues(alpha: 0.12),
      onSelected: (_) => setState(() => filter = s),
      side: BorderSide(color: selected ? color : scheme.outlineVariant),
      labelStyle: TextStyle(color: selected ? color : scheme.onSurfaceVariant),
      backgroundColor: scheme.surface,
      shape: const StadiumBorder(),
    );
  }

  Widget _statusDot(String status) {
    Color color;
    switch (status) {
      case 'Confirmed':
        color = Colors.green;
        break;
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.blueGrey;
    }
    return Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }

  void _showBookingDetails(dynamic b) {
    showDialog(
      context: context,
      builder: (_) => DialogShell(
        title: b.eventName,
        actions: [
          if (b.status != 'Confirmed')
            TextButton.icon(onPressed: () { ref.read(appStateProvider.notifier).setBookingStatus(b.id, 'Confirmed'); Navigator.of(context).pop(); }, icon: const Icon(Icons.check), label: const Text('Confirm')),
          if (b.status != 'Cancelled')
            TextButton.icon(onPressed: () { ref.read(appStateProvider.notifier).setBookingStatus(b.id, 'Cancelled'); Navigator.of(context).pop(); }, icon: const Icon(Icons.close), label: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const Icon(Icons.event), const SizedBox(width: 8), Text(b.date)]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.group), const SizedBox(width: 8), Text('${b.people} people')]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.flag), const SizedBox(width: 8), Text(b.status)]),
            const SizedBox(height: 16),
            Text('Customer Details', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 8),
                Expanded(child: Text(b.customerName ?? 'Customer')),
                if (b.isVerified == true)
                  const Icon(Icons.verified, color: Colors.green, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.phone), const SizedBox(width: 8), Text(b.contact)]),
            if (b.customerEmail != null) ...[
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.email), const SizedBox(width: 8), Text(b.customerEmail!)]),
            ],
            if (b.specialRequests != null && b.specialRequests!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Special Requests', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(b.specialRequests!),
            ],
          ],
        ),
      ),
    );
  }
}
