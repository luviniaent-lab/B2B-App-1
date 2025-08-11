import 'package:flutter/material.dart';

class DialogShell extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;
  const DialogShell({super.key, required this.title, required this.child, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxH = MediaQuery.of(context).size.height * 0.85;
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: SingleChildScrollView(child: child),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: actions,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: scheme.surface,
    );
  }
}

