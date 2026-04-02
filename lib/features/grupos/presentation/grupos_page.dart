import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GruposPage extends StatefulWidget {
  const GruposPage({super.key});

  @override
  State<GruposPage> createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  late final Future<List<_GrupoData>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadGrupos();
  }

  static Future<List<_GrupoData>> _loadGrupos() async {
    final raw = await rootBundle.loadString('assets/data/grupos.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => _GrupoData.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_GrupoData>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar grupos: ${snapshot.error}'));
        }
        final grupos = snapshot.data!;
        return SingleChildScrollView(
          key: const ValueKey('grupos_page'),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeader(),
              const SizedBox(height: 20),
              for (final g in grupos)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _GrupoCard(grupo: g),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Modelo
// ---------------------------------------------------------------------------

class _GrupoData {
  const _GrupoData({
    required this.nombre,
    required this.subtitulo,
    required this.icono,
    required this.descripcion,
    required this.reunion,
    required this.contacto,
    required this.color,
  });

  final String nombre;
  final String subtitulo;
  final IconData icono;
  final String descripcion;
  final String reunion;
  final String contacto;
  final _GrupoColor color;

  factory _GrupoData.fromJson(Map<String, dynamic> json) {
    return _GrupoData(
      nombre: json['nombre'] as String,
      subtitulo: json['subtitulo'] as String,
      icono: _iconFromString(json['icono'] as String),
      descripcion: json['descripcion'] as String,
      reunion: json['reunion'] as String,
      contacto: json['contacto'] as String,
      color: _colorFromString(json['color'] as String),
    );
  }

  static IconData _iconFromString(String name) => switch (name) {
        'flare' => Icons.flare,
        'family_restroom' => Icons.family_restroom,
        'wb_sunny' => Icons.wb_sunny,
        'menu_book' => Icons.menu_book,
        'waves' => Icons.waves,
        'elderly' => Icons.elderly,
        'local_fire_department' => Icons.local_fire_department,
        'church' => Icons.church,
        'groups' => Icons.groups,
        'volunteer_activism' => Icons.volunteer_activism,
        _ => Icons.people,
      };

  static _GrupoColor _colorFromString(String value) => switch (value) {
        'primary' => _GrupoColor.primary,
        'secondary' => _GrupoColor.secondary,
        'tertiary' => _GrupoColor.tertiary,
        _ => _GrupoColor.neutral,
      };
}

enum _GrupoColor { primary, secondary, tertiary, neutral }

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grupos de la Capilla', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Espacios de encuentro, formación y servicio abiertos a toda la comunidad. '
          'Encontrá el grupo que resuene con tu etapa de vida.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _GrupoCard extends StatelessWidget {
  const _GrupoCard({required this.grupo});

  final _GrupoData grupo;

  (Color, Color) _resolveContainer(ColorScheme cs) => switch (grupo.color) {
        _GrupoColor.primary => (cs.primaryContainer, cs.onPrimaryContainer),
        _GrupoColor.secondary => (cs.secondaryContainer, cs.onSecondaryContainer),
        _GrupoColor.tertiary => (cs.tertiaryContainer, cs.onTertiaryContainer),
        _GrupoColor.neutral => (cs.surfaceContainerHighest, cs.onSurface),
      };

  Color _resolveAccent(ColorScheme cs) => switch (grupo.color) {
        _GrupoColor.primary => cs.primary,
        _GrupoColor.secondary => cs.secondary,
        _GrupoColor.tertiary => cs.tertiary,
        _GrupoColor.neutral => cs.outline,
      };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final (containerColor, onContainerColor) = _resolveContainer(colorScheme);
    final accentColor = _resolveAccent(colorScheme);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            color: containerColor,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentColor.withValues(alpha: 0.18),
                  child: Icon(grupo.icono, color: accentColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        grupo.nombre,
                        style: textTheme.titleMedium?.copyWith(
                          color: onContainerColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        grupo.subtitulo,
                        style: textTheme.bodySmall?.copyWith(
                          color: onContainerColor.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Cuerpo
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grupo.descripcion,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.schedule,
                  text: grupo.reunion,
                  color: accentColor,
                ),
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Icons.person_outline,
                  text: grupo.contacto,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }
}
