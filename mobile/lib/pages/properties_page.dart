import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/app_state.dart';
import '../widgets/media_scroller.dart';
import '../forms/property_form.dart';
import '../widgets/app_header.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/hero_button.dart';
import '../widgets/dialog_shell.dart';





class PropertiesPage extends ConsumerWidget {
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final props = state.properties;
    return Scaffold(
      appBar: const AppHeader(),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: props.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return Row(
              children: [
                Expanded(child: TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search properties'))),
                const SizedBox(width: 10),
                HeroButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (_) => DialogShell(
                        title: 'Add Property',
                        child: SizedBox(
                          width: 520,
                          child: PropertyForm(
                            onSubmit: (p) {
                              ref.read(appStateProvider.notifier).addProperty(p);
                              Navigator.of(context).pop();
                            },
                            submitLabel: 'Create',
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Add+'),
                ),
              ],
            );
          }
          final p = props[i - 1];
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3))),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push('/properties/${p.id}'),
              splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 160, child: MediaScroller(media: p.media, image: p.image)),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.name, style: Theme.of(context).textTheme.titleMedium),
                          Text(p.location, style: Theme.of(context).textTheme.bodySmall),
                        ])),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  if ((p.agentIds ?? []).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final id in (p.agentIds ?? [])) ...[
                            Builder(builder: (context) {
                              final scheme = Theme.of(context).colorScheme;
                              final match = state.agents.where((a) => a.id == id);
                              final name = match.isNotEmpty ? match.first.name : 'Unknown Agent';
                              return Chip(
                                label: Text(name),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: scheme.primary.withValues(alpha: 0.06),
                                side: BorderSide(color: scheme.primary.withValues(alpha: 0.25)),
                                labelStyle: TextStyle(color: scheme.primary),
                                shape: const StadiumBorder(),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 0),
    );
  }
}

