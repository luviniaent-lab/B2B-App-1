import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_nav.dart';



class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);


    final typeCounts = <String, int>{};
    for (final p in state.properties) {
      typeCounts[p.type] = (typeCounts[p.type] ?? 0) + 1;
    }

    return Scaffold(
      appBar: const AppHeader(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile photo at top
                  const CircleAvatar(radius: 64, child: Icon(Icons.person, size: 56)),
                  const SizedBox(height: 16),
                  Text(state.profile.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 24),

                  // Details section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _nonEditableRow(context, 'Name', state.profile.name),
                      _nonEditableRow(context, 'Phone', state.profile.phone),
                      _verificationRow(context, 'Aadhaar', state.profile.aadhaar, 'pending'),
                      _editableRow(context, ref, 'Email', state.profile.email, (v) => {}),
                      _editableRow(context, ref, 'Address', state.profile.address, (v) => {}),
                      _verificationRow(context, 'Company Verified', state.profile.businessId, state.profile.companyVerified ? 'verified' : 'pending'),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  // Navigation buttons with consistent design
                  _profileNavButton(
                    context,
                    icon: Icons.analytics_outlined,
                    label: 'Analytics',
                    onPressed: () => context.go('/profile/analytics'),
                    isPrimary: true,
                  ),
                  const SizedBox(height: 12),
                  _profileNavButton(
                    context,
                    icon: Icons.group_outlined,
                    label: 'Manage Agents',
                    onPressed: () => context.go('/profile/agents'),
                  ),
                  const SizedBox(height: 12),
                  _profileNavButton(
                    context,
                    icon: Icons.star_outline,
                    label: 'Ratings & Reviews',
                    onPressed: () => context.go('/profile/ratings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 4),
    );
  }


  Widget _nonEditableRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 150, child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          const SizedBox(width: 12),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _verificationRow(BuildContext context, String label, String value, String status) {
    Widget statusIcon;
    switch (status) {
      case 'verified':
        statusIcon = const Icon(Icons.verified, color: Colors.green, size: 16);
        break;
      case 'pending':
        statusIcon = const Icon(Icons.schedule, color: Colors.orange, size: 16);
        break;
      case 'unverified':
      default:
        statusIcon = const Icon(Icons.cancel, color: Colors.red, size: 16);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 150, child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Text(value)),
                const SizedBox(width: 8),
                statusIcon,
                if (label == 'Aadhaar')
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('DigiLocker verification coming soon')),
                      );
                    },
                    child: const Text('Verify'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableRow(BuildContext context, WidgetRef ref, String label, String value, ValueChanged<String> onSave) {
    final controller = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 150, child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        const SizedBox(width: 12),
        Expanded(
          child: Row(children: [
            Expanded(child: Text(value)),
            TextButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Edit $label'),
                    content: TextField(controller: controller, decoration: InputDecoration(labelText: label)),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                      FilledButton(
                        onPressed: () {
                          onSave(controller.text.trim());
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Edit'),
            ),
          ]),
        ),
      ]),
    );
  }


  Widget _profileNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(inherit: false),
              ),
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label, style: const TextStyle(inherit: false)),
            )
          : OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(inherit: false),
              ),
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label, style: const TextStyle(inherit: false)),
            ),
    );
  }
}
