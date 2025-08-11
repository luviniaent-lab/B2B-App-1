import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/agent.dart';

class AgentForm extends StatefulWidget {
  final Agent? initial;
  final List<Agent> existing;
  final void Function(String name, String agentId, String password, String? avatar) onSubmit;
  final String submitLabel;
  const AgentForm({super.key, this.initial, required this.existing, required this.onSubmit, this.submitLabel = 'Save'});

  @override
  State<AgentForm> createState() => _AgentFormState();
}

class _AgentFormState extends State<AgentForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  String? _avatar;

  @override
  void initState() {
    super.initState();
    _name.text = widget.initial?.name ?? '';
    _code.text = widget.initial?.agentId ?? '';
    _password.text = widget.initial?.password ?? '';
    _avatar = widget.initial?.avatar;
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final f = await picker.pickImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 600, imageQuality: 80);
    if (f == null) return;
    final bytes = await f.readAsBytes();
    setState(() => _avatar = 'data:image/${f.path.split('.').last};base64,${base64Encode(bytes)}');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: _avatar == null
                  ? null
                  : (_avatar!.startsWith('data:')
                      ? MemoryImage(base64Decode(_avatar!.split(',').last))
                      : NetworkImage(_avatar!) as ImageProvider),
              child: _avatar == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(onPressed: _pickAvatar, icon: const Icon(Icons.upload), label: Text(widget.initial == null ? 'Add photo (optional)' : 'Change photo')),
          ]),
          const SizedBox(height: 12),
          TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Agent Name'), validator: (v) => v!.trim().isEmpty ? 'Enter agent name' : null),
          const SizedBox(height: 10),
          TextFormField(
            controller: _code,
            decoration: const InputDecoration(labelText: 'Agent ID (leave blank to auto-generate)'),
            validator: (v) {
              final code = (v ?? '').trim();
              if (code.isEmpty) return null; // allow auto-generate
              final existing = widget.existing;
              final clash = existing.any((a) => a.agentId.toLowerCase() == code.toLowerCase() && a.id != widget.initial?.id);
              if (clash) return 'Agent ID already exists';
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v) => v!.trim().isEmpty ? 'Enter password' : null),
          const SizedBox(height: 16),
          Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: _submit, child: Text(widget.submitLabel))),
        ]),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_name.text.trim(), _code.text.trim(), _password.text.trim(), _avatar);
  }
}

