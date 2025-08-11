import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';
import '../forms/event_form.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/hero_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/dialog_shell.dart';
import 'dart:convert';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});
  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final events = state.events.where((e) => e.title.toLowerCase().contains(q.toLowerCase()) || e.date.contains(q)).toList();
    return Scaffold(
      appBar: const AppHeader(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search, size: 20), hintText: 'Search events'),
                onChanged: (v) => setState(() => q = v),
              ),
            ),
            const SizedBox(width: 10),
            HeroButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => DialogShell(
                  title: 'Create Event',
                  child: SizedBox(
                    width: 520,
                    child: EventForm(
                      onSubmit: (e) {
                        ref.read(appStateProvider.notifier).addEvent(e);
                        Navigator.of(context).pop();
                      },
                      submitLabel: 'Create',
                    ),
                  ),
                ),
              ),
              child: const Text('Create'),
            ),
          ]),
        ),
        Expanded(
          child: events.isEmpty
              ? const EmptyState(icon: Icons.event_busy, title: 'No events found', subtitle: 'Create your first event')
              : ListView.separated(
                  itemCount: events.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final e = events[i];
                    final propNames = state.properties.where((p) => e.propertyIds.contains(p.id)).map((p) => p.name).toList();
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => DialogShell(
                            title: 'Edit Event',
                            child: SizedBox(
                              width: 520,
                              child: SingleChildScrollView(
                                child: EventForm(
                                  initial: e,
                                  onSubmit: (ne) {
                                    ref.read(appStateProvider.notifier).updateEvent(e.id, ne);
                                    Navigator.of(context).pop();
                                  },
                                  submitLabel: 'Save',
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            if (e.image != null)
                              Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(base64Decode(e.image!.split(',').last)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w700))),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: e.published ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                e.published ? 'PUBLISHED' : 'DRAFT',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: e.published ? Colors.green : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        if (e.description != null && e.description!.isNotEmpty)
                                          Text(e.description!, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(e.date, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                            if (e.startTime != null) ...[
                                              const SizedBox(width: 8),
                                              Text('• ${e.startTime}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                            ],
                                          ],
                                        ),
                                        if (e.price != null || e.bookingLimit != null) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              if (e.price != null)
                                                Text('Price: ${e.price}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
                                              if (e.price != null && e.bookingLimit != null)
                                                const SizedBox(width: 12),
                                              if (e.bookingLimit != null)
                                                Text('Max: ${e.bookingLimit}', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        if (propNames.isNotEmpty)
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: [
                                              for (final n in propNames)
                                                _themedChip(context, n),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      PopupMenuButton(
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'postpone',
                                            child: Row(
                                              children: [
                                                Icon(Icons.schedule, color: Colors.orange),
                                                SizedBox(width: 8),
                                                Text('Postpone'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, color: Colors.red),
                                                SizedBox(width: 8),
                                                Text('Delete', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (value) {
                                          if (value == 'delete') {
                                            _showDeleteConfirmation(e);
                                          } else if (value == 'postpone') {
                                            _showPostponeDialog(e);
                                          }
                                        },
                                      ),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 2),
    );
  }

  Widget _themedChip(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      backgroundColor: scheme.primary.withValues(alpha: 0.06),
      side: BorderSide(color: scheme.primary.withValues(alpha: 0.25)),
      labelStyle: TextStyle(color: scheme.primary),
      shape: const StadiumBorder(),
    );
  }

  void _showDeleteConfirmation(dynamic event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(appStateProvider.notifier).deleteEvent(event.id);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPostponeDialog(dynamic event) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Postpone Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to postpone "${event.title}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                hintText: 'Enter reason for postponement',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // In a real app, you'd update the event status to postponed
              // For now, we'll just show a snackbar
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Event "${event.title}" has been postponed'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                  ),
                ),
              );
            },
            child: const Text('Postpone'),
          ),
        ],
      ),
    );
  }

}

