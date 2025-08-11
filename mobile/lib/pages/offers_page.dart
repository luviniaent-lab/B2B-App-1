import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';
import '../forms/offer_form.dart';
import '../widgets/empty_state.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/hero_button.dart';
import '../widgets/dialog_shell.dart';
import '../models/offer.dart';
import 'dart:convert';

class OffersPage extends ConsumerStatefulWidget {
  const OffersPage({super.key});
  @override
  ConsumerState<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends ConsumerState<OffersPage> {
  String q = '';
  String filter = 'All';
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final allOffers = state.offers.where((o) => o.name.toLowerCase().contains(q.toLowerCase()) || o.startDate.contains(q) || o.endDate.contains(q)).toList();
    final offers = filter == 'All' ? allOffers : allOffers.where((o) => o.status == filter.toLowerCase()).toList();
    return Scaffold(
      appBar: const AppHeader(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search, size: 20), hintText: 'Search offers'),
                    onChanged: (v) => setState(() => q = v),
                  ),
                ),
                const SizedBox(width: 10),
                HeroButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => DialogShell(
                      title: 'Create Offer',
                      child: SizedBox(
                        width: 520,
                        child: OfferForm(
                          onSubmit: (o) {
                            ref.read(appStateProvider.notifier).addOffer(o);
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
              const SizedBox(height: 12),
              Row(children: [
                Text('Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(width: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final s in ['All', 'Active', 'Deactivated']) _filterChip(s),
                ]),
              ]),
            ],
          ),
        ),
        Expanded(
          child: offers.isEmpty
              ? const EmptyState(icon: Icons.local_offer_outlined, title: 'No offers found', subtitle: 'Create your first offer')
              : ListView.separated(
                  itemCount: offers.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final o = offers[i];
                    final propNames = state.properties.where((p) => o.propertyIds.contains(p.id)).map((p) => p.name).toList();
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => DialogShell(
                            title: 'Edit Offer',
                            child: SizedBox(
                              width: 520,
                              child: SingleChildScrollView(
                                child: OfferForm(
                                  initial: o,
                                  onSubmit: (no) {
                                    ref.read(appStateProvider.notifier).updateOffer(o.id, no);
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
                            if (o.image != null)
                              Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(base64Decode(o.image!.split(',').last)),
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
                                            Expanded(child: Text(o.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: o.status == 'active' ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                o.status.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: o.status == 'active' ? Colors.green : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        if (o.description != null && o.description!.isNotEmpty)
                                          Text(o.description!, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text('${o.startDate} → ${o.endDate}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                        if (o.discountType != null && o.amount != null)
                                          Text('${o.discountType}: ${o.amount}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
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
                                      IconButton(
                                        icon: Icon(o.status == 'active' ? Icons.toggle_on : Icons.toggle_off),
                                        color: o.status == 'active' ? Colors.green : Colors.grey,
                                        iconSize: 32,
                                        onPressed: () {
                                          final newStatus = o.status == 'active' ? 'deactivated' : 'active';
                                          final updatedOffer = Offer(
                                            id: o.id,
                                            name: o.name,
                                            description: o.description,
                                            startDate: o.startDate,
                                            endDate: o.endDate,
                                            discountType: o.discountType,
                                            amount: o.amount,
                                            image: o.image,
                                            status: newStatus,
                                            bookingsCount: o.bookingsCount,
                                            propertyIds: o.propertyIds,
                                          );
                                          ref.read(appStateProvider.notifier).updateOffer(o.id, updatedOffer);
                                        },
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (context) => [
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
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text('Delete Offer'),
                                                content: Text('Are you sure you want to delete "${o.name}"?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () {
                                                      ref.read(appStateProvider.notifier).deleteOffer(o.id);
                                                      Navigator.of(context).pop();
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
      bottomNavigationBar: const AppBottomNav(selectedIndex: 1),
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

  Widget _filterChip(String s) {
    final bool selected = filter == s;
    Color color;
    switch (s) {
      case 'Active':
        color = Colors.green;
        break;
      case 'Deactivated':
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

}

