import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';

class AgentsSelector extends ConsumerStatefulWidget {
  final List<String> initial;
  final ValueChanged<List<String>> onChanged;
  const AgentsSelector({super.key, required this.initial, required this.onChanged});

  @override
  ConsumerState<AgentsSelector> createState() => _AgentsSelectorState();
}

class _AgentsSelectorState extends ConsumerState<AgentsSelector> {
  late List<String> selected;
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlay;
  final GlobalKey _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selected = [...widget.initial];
  }

  void _toggleOverlay(List agents) {
    if (_overlay == null) {
      _showOverlay(context, agents);
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay(BuildContext context, List agents) {
    final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? const Size(0, 0);

    _overlay = OverlayEntry(
      builder: (ctx) => Stack(children: [
        Positioned.fill(
          child: GestureDetector(onTap: _removeOverlay, child: Container(color: Colors.transparent)),
        ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 6),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520, maxHeight: 320),
              child: Container(
                width: (renderBox?.size.width ?? 320),
                color: Theme.of(context).colorScheme.surface,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      children: [
                        for (final a in agents)
                          CheckboxListTile(
                            value: selected.contains(a.id),
                            onChanged: (v) => setState(() {
                              if (v == true) {
                                selected.add(a.id);
                              } else {
                                selected.remove(a.id);
                              }
                            }),
                            title: Text(a.name),
                            subtitle: Text(a.agentId),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(children: [
                      TextButton(onPressed: () => setState(() => selected.clear()), child: const Text('Clear')),
                      const Spacer(),
                      FilledButton(onPressed: () { widget.onChanged(selected); _removeOverlay(); }, child: const Text('Done')),
                    ]),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
    Overlay.of(context, debugRequiredFor: widget).insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agents = ref.watch(appStateProvider).agents;
    final scheme = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CompositedTransformTarget(
        link: _link,
        child: GestureDetector(
          onTap: () => _toggleOverlay(agents),
          child: InputDecorator(
            key: _fieldKey,
            decoration: InputDecoration(
              labelText: 'Assign agents (optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: const Icon(Icons.expand_more),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (selected.isEmpty) Text('None selected', style: TextStyle(color: scheme.onSurfaceVariant)),
                for (final id in selected)
                  InputChip(
                    selected: true,
                    label: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.person, size: 18),
                      const SizedBox(width: 6),
                      Text(agents.firstWhere((a) => a.id == id).name),
                    ]),
                    onDeleted: () {
                      setState(() {
                        selected.remove(id);
                        widget.onChanged(selected);
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class _AgentMultiSelectSheet extends StatefulWidget {
  final List<String> initial;
  final List<dynamic> agents;
  const _AgentMultiSelectSheet({required this.initial, required this.agents});
  @override
  State<_AgentMultiSelectSheet> createState() => _AgentMultiSelectSheetState();
}

class _AgentMultiSelectSheetState extends State<_AgentMultiSelectSheet> {
  late List<String> sel;
  @override
  void initState() {
    super.initState();
    sel = [...widget.initial];
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        top: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select agents', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView(
              children: [
                for (final a in widget.agents)
                  CheckboxListTile(
                    value: sel.contains(a.id),
                    onChanged: (v) => setState(() => v == true ? sel.add(a.id) : sel.remove(a.id)),
                    title: Text(a.name),
                    subtitle: Text(a.agentId),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            const Spacer(),
            FilledButton(onPressed: () => Navigator.of(context).pop(sel), child: const Text('Done')),
          ])
        ],
      ),
    );
  }

}

