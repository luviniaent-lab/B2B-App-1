import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authProvider);
    if (auth.isLoggedIn) {
      // Ensure redirect even if button navigation missed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/');
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Login')), body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number')),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: otpCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'OTP (6 digits)'))),
            const SizedBox(width: 10),
            FilledButton(onPressed: () async { await ref.read(authProvider.notifier).sendOtp(phoneCtrl.text); setState(() => sent = true); }, child: Text(sent ? 'Resend' : 'Send OTP')),
          ]),
          const SizedBox(height: 10),
          FilledButton(onPressed: () async { final ok = await ref.read(authProvider.notifier).verifyOtpAndLogin(phoneCtrl.text, otpCtrl.text); if (!context.mounted) return; if (ok) { context.go('/'); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP'))); } }, child: const Text('Login with OTP')),
        ]))),
        const SizedBox(height: 16),
        Center(child: Text('or', style: TextStyle(color: scheme.onSurfaceVariant))),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Gmail')),
          const SizedBox(height: 10),
          FilledButton(onPressed: () async { final ok = await ref.read(authProvider.notifier).loginWithGoogle(emailCtrl.text); if (!context.mounted) return; if (ok) { context.go('/'); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email'))); } }, child: const Text('Continue with Google')),
        ]))),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage())), child: const Text('Create a new account')),
      ]),
    );
  }
}

