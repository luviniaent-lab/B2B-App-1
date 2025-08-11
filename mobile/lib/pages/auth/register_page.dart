import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final aadhaarCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Register')), body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 10),
          TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number')),
          const SizedBox(height: 10),
          TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Gmail')),
          const SizedBox(height: 10),
          TextField(controller: aadhaarCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Aadhaar')),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: otpCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'OTP (for Aadhaar verification)'))),
            const SizedBox(width: 10),
            FilledButton(onPressed: () async { await ref.read(authProvider.notifier).sendOtp(phoneCtrl.text); if (!context.mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent'))); }, child: const Text('Send OTP')),
          ]),
          const SizedBox(height: 10),
          FilledButton(onPressed: () async { final ok = await ref.read(authProvider.notifier).register(name: nameCtrl.text, phone: phoneCtrl.text, email: emailCtrl.text, aadhaar: aadhaarCtrl.text, otp: otpCtrl.text); if (!context.mounted) return; if (!ok) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid details'))); } }, child: const Text('Create account')),
        ]))),
        const SizedBox(height: 16),
        Center(child: Text('By continuing, you agree to our Terms & Privacy', style: TextStyle(color: scheme.onSurfaceVariant))),
      ]),
    );
  }
}

