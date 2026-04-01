import 'package:flutter/material.dart';

class SectionPlaceholder extends StatelessWidget {
  const SectionPlaceholder({
    required this.title,
    required this.description,
    required this.highlights,
    super.key,
  });

  final String title;
  final String description;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      key: ValueKey(title),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vista previa',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: highlights
                        .map(
                          (item) => Chip(
                            label: Text(item),
                            avatar: const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.tertiary.withValues(alpha: 0.16),
                child: Icon(Icons.auto_awesome, color: colorScheme.tertiary),
              ),
              title: const Text('Maqueta UX'),
              subtitle: const Text(
                'Esta seccion es demostrativa para validar estructura y navegacion.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
