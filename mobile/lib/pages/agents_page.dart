import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/app_state.dart';
import '../models/agent.dart';
import '../utils/uid.dart';
import '../widgets/dialog_shell.dart';
import '../widgets/empty_state.dart';
import '../forms/agent_form.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_nav.dart';



class AgentsPage extends ConsumerStatefulWidget {
  const AgentsPage({super.key});
  @override
  ConsumerState<AgentsPage> createState() => _AgentsPageState();
}

class _AgentsPageState extends ConsumerState<AgentsPage> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final agents = state.agents
        .where((a) => a.name.toLowerCase().contains(q.toLowerCase()) || a.agentId.toLowerCase().contains(q.toLowerCase()))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Scaffold(
      appBar: const AppHeader(),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search agents'),
                onChanged: (v) => setState(() => q = v),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () => _openCreate(),
              child: const Text('Create'),
            ),
          ]),
        ),
        Expanded(
          child: agents.isEmpty
              ? const EmptyState(icon: Icons.group_outlined, title: 'No agents created', subtitle: 'Create your first agent')
              : ListView.separated(
                  itemCount: agents.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final a = agents[i];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.go('/agents/${a.id}'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundImage: a.avatar == null
                                  ? null
                                  : (a.avatar!.startsWith('data:')
                                      ? MemoryImage(base64Decode(a.avatar!.split(',').last))
                                      : NetworkImage(a.avatar!) as ImageProvider),
                              child: a.avatar == null ? const Icon(Icons.person) : null,
                            ),
                            title: Text(a.name),
                            subtitle: Text('ID: ${a.agentId}'),
                            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Delete', onPressed: () => _attemptDelete(a)),
                              const Icon(Icons.chevron_right),
                            ]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 4),
    );
  }

  void _openCreate() {
    final existing = ref.read(appStateProvider).agents;
    showDialog(
      context: context,
      builder: (_) => DialogShell(
        title: 'Create Agent',
        child: AgentForm(
          existing: existing,
          onSubmit: (name, code, pass, avatar) {
            final generated = code.trim().isEmpty ? _generateAgentCode(name) : code.trim();
            ref.read(appStateProvider.notifier).addAgent(Agent(id: uid(), name: name, agentId: generated, password: pass, avatar: avatar));
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  String _generateAgentCode(String name) {
    final base = name.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '').padRight(3, 'x').substring(0, 3);
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(9);
    return 'AG-${base.toUpperCase()}$suffix';
  }



  void _attemptDelete(Agent a) {
    final assignedCount = ref.read(appStateProvider).properties.where((p) => (p.agentIds ?? const []).contains(a.id)).length;
    if (assignedCount > 0) {
      showDialog(
        context: context,
        builder: (_) => DialogShell(
          title: 'Cannot delete',
          child: Text('This agent is assigned to $assignedCount propert${assignedCount == 1 ? 'y' : 'ies'}. Remove assignments first.'),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => DialogShell(
        title: 'Delete Agent',
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(appStateProvider.notifier).deleteAgent(a.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
        child: const Text('Are you sure you want to delete this agent?'),
      ),
    );
  }
}

