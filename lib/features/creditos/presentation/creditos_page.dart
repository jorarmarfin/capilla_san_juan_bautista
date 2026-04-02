import 'package:capilla_san_juan_bautista/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditosPage extends StatelessWidget {
  const CreditosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      key: const ValueKey('creditos_page'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary.withValues(
                      alpha: 0.14,
                    ),
                    child: Icon(Icons.favorite, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Gracias por apoyar esta aplicacion para la comunidad de la capilla.',
                      style: textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Desarrollador', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.code,
            title: 'Ing. Software',
            subtitle: 'Luis Fernando Mayta Campos',
          ),
          const SizedBox(height: 10),
          _InfoTile(
            icon: Icons.language,
            title: 'Sitio Web',
            subtitle: 'luisitomayta.com',
            onTap: () => launchUrl(
              Uri.parse('https://luisitomayta.com'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          const SizedBox(height: 18),
          Text('Tecnologia', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.flutter_dash,
            title: 'Framework',
            subtitle: 'Flutter',
          ),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.data_object,
            title: 'Lenguaje',
            subtitle: 'Dart',
          ),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.design_services,
            title: 'Diseno',
            subtitle: 'Material 3 y arquitectura modular por features',
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Hecho con corazon para la Capilla San Juan Bautista',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppConfig.appVersion,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: onTap != null
              ? TextStyle(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                )
              : null,
        ),
        onTap: onTap,
      ),
    );
  }
}
