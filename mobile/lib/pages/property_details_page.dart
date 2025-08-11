import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';
import '../widgets/media_scroller.dart';
import '../forms/property_form.dart';
import '../widgets/dialog_shell.dart';



class PropertyDetailsPage extends ConsumerWidget {
  final String id;
  const PropertyDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final p = state.properties.firstWhere((x) => x.id == id);
    final events = state.events.where((e) => e.propertyIds.contains(p.id)).toList();
    final offers = state.offers.where((o) => o.propertyIds.contains(p.id)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => DialogShell(
                title: 'Edit Property',
                child: SizedBox(
                  width: 520,
                  child: PropertyForm(
                    initial: p,
                    submitLabel: 'Save',
                    onSubmit: (np) {
                      ref.read(appStateProvider.notifier).updateProperty(p.id, np);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Property', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete Property'),
                    content: Text('Are you sure you want to delete "${p.name}"? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          ref.read(appStateProvider.notifier).deleteProperty(p.id);
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(); // Go back to properties list
                        },
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        children: [
          SizedBox(height: 220, child: MediaScroller(media: p.media, image: p.image)),
          const SizedBox(height: 12),
          Text(p.location, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          if ((p.agentIds ?? []).isNotEmpty || p.agentName != null) ...[
            Text('Agents', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (p.agentName != null) _pill(context, p.agentName!),
              for (final id in (p.agentIds ?? []))
                _pill(
                  context,
                  (state.agents.where((a) => a.id == id).map((a) => a.name).firstOrNull) ?? 'Unknown Agent',
                ),
            ]),
            const SizedBox(height: 12),
          ],
          Text('Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          _detailsGrid(context, p),
          const SizedBox(height: 12),
          if ((p.themes ?? []).isNotEmpty) ...[
            Text('Themes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(p.themes!.join(', ')),
            const SizedBox(height: 12),
          ],
          if ((p.amenities ?? []).isNotEmpty) ...[
            Text('Amenities', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(p.amenities!.join(', ')),
            const SizedBox(height: 12),
          ],
          Text('Events', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          if (events.isEmpty) Text('No events linked', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          for (final e in events) ListTile(title: Text(e.title), subtitle: Text(e.date)),
          const SizedBox(height: 12),
          Text('Offers', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          if (offers.isEmpty) Text('No offers linked', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          for (final o in offers) ListTile(title: Text(o.name), subtitle: Text('${o.startDate} → ${o.endDate}')),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
    );
  }

  Widget _labelValue(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
      const SizedBox(height: 2),
      Text(value, style: theme.textTheme.bodyMedium),
    ]);
  }

  Widget _detailsGrid(BuildContext context, dynamic p) {
    return GridView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.6,
      ),
      children: [
        _labelValue(context, 'Type', p.type),
        _labelValue(context, 'Verified', (p.verified ?? false) ? 'Yes' : 'No'),
        _labelValue(context, 'Occupancy', p.occupancy?.toString() ?? '–'),
        _labelValue(context, 'Total Bookings', (p.totalBookings ?? 0).toString()),
        _labelValue(context, 'Price (24h)', p.price24h ?? '–'),
        _labelValue(context, 'Weekend', p.priceWeekend ?? '–'),
        _labelValue(context, 'Event Adj (%)', p.eventPriceDelta?.toString() ?? '–'),
      ],
    );
  }

}

