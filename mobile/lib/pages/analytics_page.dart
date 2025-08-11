import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final bookings = state.bookings.where((b) => b.status == 'Confirmed').toList();

    // Calculate earnings
    double totalEarnings = 0;
    double thisMonthEarnings = 0;
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);

    final earningsData = <Map<String, dynamic>>[];

    for (final booking in bookings) {
      final amount = double.tryParse(booking.price ?? '0') ?? 0;
      totalEarnings += amount;

      // Parse booking date (assuming DDMMYYYY format)
      try {
        final dateStr = booking.date;
        if (dateStr.length == 8) {
          final day = int.parse(dateStr.substring(0, 2));
          final month = int.parse(dateStr.substring(2, 4));
          final year = int.parse(dateStr.substring(4, 8));
          final bookingDate = DateTime(year, month, day);

          if (bookingDate.isAfter(thisMonth)) {
            thisMonthEarnings += amount;
          }

          earningsData.add({
            'date': dateStr,
            'amount': amount,
            'event': booking.eventName,
            'customer': booking.customerName ?? 'Customer',
            'people': booking.people,
          });
        }
      } catch (e) {
        // Skip invalid dates
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Earnings Overview Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Earnings', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Text('₹${totalEarnings.toStringAsFixed(0)}',
                             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                               color: Theme.of(context).colorScheme.primary,
                               fontWeight: FontWeight.bold,
                             )),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('This Month', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Text('₹${thisMonthEarnings.toStringAsFixed(0)}',
                             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                               color: Theme.of(context).colorScheme.secondary,
                               fontWeight: FontWeight.bold,
                             )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Earnings Details
          Text('Earnings Details', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          if (earningsData.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No earnings yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('Confirmed bookings will appear here', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            )
          else
            ...earningsData.map((earning) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.currency_rupee, color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(earning['event']),
                subtitle: Text('${earning['customer']} • ${earning['people']} people • ${earning['date']}'),
                trailing: Text(
                  '₹${earning['amount'].toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            )),
        ],
      ),
    );
  }
}

