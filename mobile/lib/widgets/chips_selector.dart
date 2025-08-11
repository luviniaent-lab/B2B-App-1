import 'package:flutter/material.dart';

class ChipsSelector extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> initial;
  final ValueChanged<List<String>> onChanged;
  final String? hintAddCustom; // comma separated

  const ChipsSelector({
    super.key,
    required this.label,
    required this.options,
    required this.initial,
    required this.onChanged,
    this.hintAddCustom,
  });

  @override
  State<ChipsSelector> createState() => _ChipsSelectorState();
}

class _ChipsSelectorState extends State<ChipsSelector> {
  late List<String> selected;
  final _customCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selected = [...widget.initial];
  }

  void _toggle(String v) {
    setState(() {
      if (selected.contains(v)) {
        selected.remove(v);
      } else {
        selected.add(v);
      }
    });
    widget.onChanged(selected);
  }

  void _addCustom() {
    final parts = _customCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
    for (final p in parts) {
      if (!selected.contains(p)) selected.add(p);
    }
    _customCtrl.clear();
    setState(() {});
    widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final options = {...widget.options, ...selected}.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final o in options)
              FilterChip(
                label: Text(o),
                selected: selected.contains(o),
                onSelected: (_) => _toggle(o),
              ),
          ],
        ),
        if (widget.hintAddCustom != null) ...[
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _customCtrl,
                decoration: InputDecoration(
                  hintText: widget.hintAddCustom,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _addCustom, child: const Text('Add')),
          ]),
        ],
      ],
    );
  }
}

