import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/app_state.dart';
import '../models/agent.dart';
import '../models/property.dart';
import '../forms/agent_form.dart';
import '../widgets/app_header.dart';

import '../widgets/app_bottom_nav.dart';
import '../widgets/dialog_shell.dart';



class AgentDetailsPage extends ConsumerWidget {
  final String id;
  const AgentDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final agent = state.agents.firstWhere((a) => a.id == id);
    final assigned = state.properties.where((p) => (p.agentIds ?? const []).contains(agent.id)).toList();
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const AppHeader(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: agent.avatar == null
                      ? null
                      : (agent.avatar!.startsWith('data:')
                          ? MemoryImage(base64Decode(agent.avatar!.split(',').last))
                          : NetworkImage(agent.avatar!) as ImageProvider),
                  child: agent.avatar == null ? const Icon(Icons.person, size: 32) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(agent.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('ID: ${agent.agentId}', style: const TextStyle(color: Colors.grey)),
                  ]),
                ),
                const SizedBox(width: 12),
                Wrap(spacing: 8, children: [
                  OutlinedButton.icon(
                    onPressed: () => _openAgentEditDialog(context, ref, agent),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _openAssignProperties(context, ref, agent.id),
                    icon: const Icon(Icons.playlist_add_check),
                    label: const Text('Assign Properties'),
                  ),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Text('Assigned Properties', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (assigned.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text('No properties assigned'),
                subtitle: Text('Assign this agent from property edit form'),
              ),
            )
          else
            ...[
              for (final p in assigned)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: Text(p.name),
                    subtitle: Text(p.location),
                    trailing: Icon(Icons.chevron_right, color: scheme.outline),
                    onTap: () => context.go('/properties/${p.id}'),
                  ),
                ),
            ],
        ],
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 4),
    );
  }

  void _openAgentEditDialog(BuildContext context, WidgetRef ref, Agent agent) {
    final existing = ref.read(appStateProvider).agents;
    showDialog(
      context: context,
      builder: (_) => DialogShell(
        title: 'Edit Agent',
        child: SizedBox(
          width: 460,
          child: AgentForm(
            initial: agent,
            existing: existing,
            onSubmit: (name, code, pass, avatar) {
              final generated = (code.trim().isEmpty) ? _generateAgentCode(name) : code.trim();
              ref.read(appStateProvider.notifier).updateAgent(agent.id, Agent(id: agent.id, name: name, agentId: generated, password: pass, avatar: avatar ?? agent.avatar));
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  String _generateAgentCode(String name) {
    final base = name.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '').padRight(3, 'x').substring(0, 3);
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(9);
    return 'AG-${base.toUpperCase()}$suffix';
  }

  void _openAssignProperties(BuildContext context, WidgetRef ref, String agentId) async {
    final state = ref.read(appStateProvider);
    final assigned = state.properties.where((p) => (p.agentIds ?? const []).contains(agentId)).map((p) => p.id).toList();
    final all = state.properties;
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _AssignPropertiesSheet(initial: assigned, allProps: all),
    );
    if (result == null) return;

    final ctrl = ref.read(appStateProvider.notifier);
    for (final p in all) {
      final want = result.contains(p.id);
      final has = (p.agentIds ?? const []).contains(agentId);
      if (want == has) continue;
      final updated = List<String>.from(p.agentIds ?? const []);
      if (want) {
        if (!updated.contains(agentId)) updated.add(agentId);
      } else {
        updated.remove(agentId);
      }
      ctrl.updateProperty(
        p.id,
        Property(
          id: p.id,
          name: p.name,
          location: p.location,
          type: p.type,
          occupancy: p.occupancy,
          agentName: p.agentName,
          agentIds: updated.isEmpty ? null : updated,
          themes: p.themes,
          amenities: p.amenities,
          image: p.image,
          media: p.media,
          price24h: p.price24h,
          priceWeekend: p.priceWeekend,
          eventPriceDelta: p.eventPriceDelta,
          entryFee: p.entryFee,
          entryFee24h: p.entryFee24h,
          entryFeePerHour: p.entryFeePerHour,
          weekendPrice24h: p.weekendPrice24h,
          weekendPricePerHour: p.weekendPricePerHour,
          priceRangeHours: p.priceRangeHours,
          priceRangeDays: p.priceRangeDays,
          discountPercent: p.discountPercent,
          verified: p.verified,
          totalBookings: p.totalBookings,
        ),
      );
    }
  }
}

class _AssignPropertiesSheet extends StatefulWidget {
  final List<String> initial;
  final List<Property> allProps;
  const _AssignPropertiesSheet({required this.initial, required this.allProps});
  @override
  State<_AssignPropertiesSheet> createState() => _AssignPropertiesSheetState();
}

class _AssignPropertiesSheetState extends State<_AssignPropertiesSheet> {
  late List<String> sel;
  @override
  void initState() {
    super.initState();
    sel = [...widget.initial];
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Assign Properties', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 320,
          child: ListView(children: [
            for (final p in widget.allProps)
              CheckboxListTile(
                value: sel.contains(p.id),
                onChanged: (v) => setState(() => v == true ? sel.add(p.id) : sel.remove(p.id)),
                title: Text(p.name),
                subtitle: Text(p.location),
                secondary: const Icon(Icons.home_outlined),
                controlAffinity: ListTileControlAffinity.leading,
              ),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          const Spacer(),
          FilledButton(onPressed: () => Navigator.of(context).pop(sel), child: const Text('Done')),
        ])
      ]),
    );
  }
}




