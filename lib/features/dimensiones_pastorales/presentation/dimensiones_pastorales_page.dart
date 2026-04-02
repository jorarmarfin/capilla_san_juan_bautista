import 'package:flutter/material.dart';

class DimensionesPastoralesPage extends StatelessWidget {
  const DimensionesPastoralesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('dimensiones_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _PageHeader(),
          SizedBox(height: 20),
          _StatsRow(),
          SizedBox(height: 24),
          _DimensionCard(data: _liturgia),
          SizedBox(height: 14),
          _DimensionCard(data: _koinonia),
          SizedBox(height: 14),
          _DimensionCard(data: _martyria),
          SizedBox(height: 14),
          _DimensionCard(data: _diakonia),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Datos de cada dimension
// ---------------------------------------------------------------------------

class _DimensionData {
  const _DimensionData({
    required this.nombre,
    required this.traduccion,
    required this.icono,
    required this.color,
    required this.descripcion,
    required this.actividades,
    required this.responsable,
  });

  final String nombre;
  final String traduccion;
  final IconData icono;
  final _DimensionColor color;
  final String descripcion;
  final List<String> actividades;
  final String responsable;
}

enum _DimensionColor { primary, secondary, tertiary, success }

const _liturgia = _DimensionData(
  nombre: 'Liturgia',
  traduccion: 'Celebración y oración',
  icono: Icons.church,
  color: _DimensionColor.primary,
  descripcion:
      'La dimensión litúrgica es el corazón de la vida comunitaria. '
      'Celebramos los sacramentos, la Eucaristía y el año litúrgico como '
      'encuentro vivo con Dios. La oración comunitaria, la adoración eucarística '
      'y los cantos litúrgicos alimentan la fe del pueblo.',
  actividades: [
    'Misa diaria',
    'Adoración eucarística',
    'Coro parroquial',
    'Grupos de oración',
    'Semana Santa',
    'Novenas',
  ],
  responsable: 'Coordinado por las Carmelitas Descalzas',
);

const _koinonia = _DimensionData(
  nombre: 'Koinonia',
  traduccion: 'Comunidad y fraternidad',
  icono: Icons.people,
  color: _DimensionColor.secondary,
  descripcion:
      'La comunión entre los miembros de la capilla es signo visible del amor '
      'de Dios. Cultivamos relaciones de fraternidad a través de encuentros, '
      'retiros y celebraciones que fortalecen la identidad como pueblo de Dios '
      'y hacen de la capilla un hogar para todos.',
  actividades: [
    'Encuentro de familias',
    'Retiros comunitarios',
    'Grupos de jóvenes',
    'Grupos de adultos mayores',
    'Fiestas patronales',
    'Convivencias',
  ],
  responsable: 'Coordinado por el Consejo Pastoral',
);

const _martyria = _DimensionData(
  nombre: 'Martyria',
  traduccion: 'Anuncio y testimonio',
  icono: Icons.record_voice_over,
  color: _DimensionColor.tertiary,
  descripcion:
      'Somos llamados a anunciar el Evangelio con nuestra vida y con la palabra. '
      'La catequesis, la formación bíblica y el testimonio cristiano en el barrio '
      'son expresiones de esta dimensión. Cada bautizado es misionero en su '
      'entorno familiar, laboral y social.',
  actividades: [
    'Catequesis infantil',
    'Confirmación',
    'Bíblia viva',
    'Misión barrial',
    'Evangelización digital',
    'Preparación sacramental',
  ],
  responsable: 'Coordinado por el equipo de catequistas',
);

const _diakonia = _DimensionData(
  nombre: 'Diakonia',
  traduccion: 'Servicio y caridad',
  icono: Icons.volunteer_activism,
  color: _DimensionColor.success,
  descripcion:
      'El servicio al prójimo es inseparable del amor a Dios. La capilla '
      'impulsa acciones concretas de solidaridad: apoyo a familias vulnerables, '
      'colectas, visitas a enfermos y ancianos. Siguiendo el ejemplo de Cristo, '
      'ponemos nuestros dones al servicio de los más necesitados.',
  actividades: [
    'Comedor solidario',
    'Visitas a enfermos',
    'Colecta de víveres',
    'Apoyo escolar',
    'Cáritas parroquial',
    'Fondo de emergencia',
  ],
  responsable: 'Coordinado por Cáritas y voluntarios',
);

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
        Text('Dimensiones Pastorales', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Cuatro ejes que articulan toda la vida de nuestra comunidad: '
          'la oración, la fraternidad, el anuncio y el servicio.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatChip(value: '4', label: 'Dimensiones')),
        SizedBox(width: 8),
        Expanded(child: _StatChip(value: '12', label: 'Grupos activos')),
        SizedBox(width: 8),
        Expanded(child: _StatChip(value: '+200', label: 'Personas')),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.75),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.data});

  final _DimensionData data;

  (Color, Color) _resolveColors(ColorScheme cs) => switch (data.color) {
        _DimensionColor.primary => (cs.primaryContainer, cs.onPrimaryContainer),
        _DimensionColor.secondary => (
            cs.secondaryContainer,
            cs.onSecondaryContainer
          ),
        _DimensionColor.tertiary => (
            cs.tertiaryContainer,
            cs.onTertiaryContainer
          ),
        _DimensionColor.success => (
            cs.surfaceContainerHighest,
            cs.onSurface
          ),
      };

  Color _resolveAccent(ColorScheme cs) => switch (data.color) {
        _DimensionColor.primary => cs.primary,
        _DimensionColor.secondary => cs.secondary,
        _DimensionColor.tertiary => cs.tertiary,
        _DimensionColor.success => cs.primary,
      };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final (containerColor, onContainerColor) = _resolveColors(colorScheme);
    final accentColor = _resolveAccent(colorScheme);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            color: containerColor,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: accentColor.withValues(alpha: 0.18),
                  child: Icon(data.icono, color: accentColor, size: 26),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.nombre,
                      style: textTheme.titleMedium?.copyWith(
                        color: onContainerColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data.traduccion,
                      style: textTheme.bodySmall?.copyWith(
                        color: onContainerColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Cuerpo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.descripcion,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 14),
                _Label(text: 'Actividades', color: accentColor),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: data.actividades
                      .map(
                        (a) => Chip(
                          label: Text(a, style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 15, color: accentColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        data.responsable,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.8,
      ),
    );
  }
}
