import 'package:flutter/material.dart';

class GruposPage extends StatelessWidget {
  const GruposPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('grupos_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(),
          const SizedBox(height: 20),
          const _FilterRow(),
          const SizedBox(height: 20),
          for (final g in _grupos)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _GrupoCard(grupo: g),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Datos
// ---------------------------------------------------------------------------

class _GrupoData {
  const _GrupoData({
    required this.nombre,
    required this.subtitulo,
    required this.icono,
    required this.categoria,
    required this.descripcion,
    required this.reunion,
    required this.contacto,
    required this.color,
  });

  final String nombre;
  final String subtitulo;
  final IconData icono;
  final _Categoria categoria;
  final String descripcion;
  final String reunion;
  final String contacto;
  final _GrupoColor color;
}

enum _Categoria { jovenes, familias, formacion, servicio }
enum _GrupoColor { primary, secondary, tertiary, neutral }

extension _CategoriaLabel on _Categoria {
  String get label => switch (this) {
        _Categoria.jovenes => 'Jóvenes',
        _Categoria.familias => 'Familias',
        _Categoria.formacion => 'Formación',
        _Categoria.servicio => 'Servicio',
      };

  IconData get icon => switch (this) {
        _Categoria.jovenes => Icons.bolt,
        _Categoria.familias => Icons.family_restroom,
        _Categoria.formacion => Icons.menu_book,
        _Categoria.servicio => Icons.volunteer_activism,
      };
}

const _grupos = <_GrupoData>[
  _GrupoData(
    nombre: 'Emanuel',
    subtitulo: '"Dios con nosotros"',
    icono: Icons.flare,
    categoria: _Categoria.jovenes,
    descripcion:
        'Grupo de jóvenes que viven su fe con alegría y compromiso. '
        'A través de la oración, el servicio y el encuentro fraterno, '
        'anuncian que Cristo es la respuesta a las preguntas profundas '
        'de la vida. Abierto a jóvenes de 16 a 30 años.',
    reunion: 'Viernes 7:00 PM — Salón principal',
    contacto: 'Coordinador: Hnos. del grupo',
    color: _GrupoColor.secondary,
  ),
  _GrupoData(
    nombre: 'Sagrada Familia',
    subtitulo: 'Pastoral familiar',
    icono: Icons.family_restroom,
    categoria: _Categoria.familias,
    descripcion:
        'Espacio de encuentro y formación para matrimonios y familias. '
        'Reflexionan el Evangelio desde la vida cotidiana del hogar, '
        'fortaleciendo los vínculos conyugales y la educación cristiana '
        'de los hijos.',
    reunion: 'Sábados 5:00 PM — Capilla lateral',
    contacto: 'Coordinadores: Matrimonios del grupo',
    color: _GrupoColor.tertiary,
  ),
  _GrupoData(
    nombre: 'Movimiento de la Esperanza',
    subtitulo: 'MOVES',
    icono: Icons.wb_sunny,
    categoria: _Categoria.jovenes,
    descripcion:
        'El MOVES es un movimiento de renovación espiritual que convoca '
        'a jóvenes y adultos jóvenes en torno a la esperanza cristiana. '
        'Sus retiros y jornadas de oración son reconocidos como momentos '
        'de gracia en la comunidad.',
    reunion: 'Domingos 4:00 PM — Salón de reuniones',
    contacto: 'Coordinador: Equipo MOVES',
    color: _GrupoColor.primary,
  ),
  _GrupoData(
    nombre: 'Catequesis Familiar',
    subtitulo: 'Formación para padres e hijos',
    icono: Icons.menu_book,
    categoria: _Categoria.formacion,
    descripcion:
        'Prepara a niños y sus familias para recibir los sacramentos de '
        'la Iniciación Cristiana: Bautismo, Primera Comunión y Confirmación. '
        'Los padres participan activamente como primeros catequistas de sus hijos.',
    reunion: 'Sábados 9:00 AM — Aulas de catequesis',
    contacto: 'Coordinadora: Equipo de catequistas',
    color: _GrupoColor.neutral,
  ),
  _GrupoData(
    nombre: 'Agua Viva',
    subtitulo: 'Renovación carismática',
    icono: Icons.waves,
    categoria: _Categoria.formacion,
    descripcion:
        'Grupo de oración carismática que celebra la acción del Espíritu '
        'Santo en la vida de cada persona. Sus reuniones se caracterizan '
        'por la alabanza, la adoración, el testimonio y la intercesión '
        'comunitaria.',
    reunion: 'Miércoles 7:30 PM — Iglesia principal',
    contacto: 'Coordinador: Líderes del grupo',
    color: _GrupoColor.secondary,
  ),
  _GrupoData(
    nombre: 'Adulto Mayor',
    subtitulo: 'Pastoral de la tercera edad',
    icono: Icons.elderly,
    categoria: _Categoria.servicio,
    descripcion:
        'Acompaña a los hermanos de la tercera edad en su camino de fe, '
        'brindando espacio de encuentro, escucha y oración. Organiza visitas '
        'domiciliarias a quienes no pueden asistir a la capilla por motivos '
        'de salud.',
    reunion: 'Martes 10:00 AM — Salón parroquial',
    contacto: 'Coordinadora: Voluntarios del grupo',
    color: _GrupoColor.tertiary,
  ),
  _GrupoData(
    nombre: 'Pastoral de Confirmación',
    subtitulo: 'Iniciación cristiana para adolescentes',
    icono: Icons.local_fire_department,
    categoria: _Categoria.formacion,
    descripcion:
        'Acompaña a adolescentes en su proceso de maduración de la fe para '
        'recibir el sacramento de la Confirmación. El itinerario incluye '
        'catequesis, convivencias, servicio comunitario y un retiro de '
        'profundización.',
    reunion: 'Sábados 3:00 PM — Aulas de catequesis',
    contacto: 'Coordinador: Equipo de confirmación',
    color: _GrupoColor.primary,
  ),
];

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

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: _Categoria.values.map((cat) {
        return Chip(
          avatar: Icon(cat.icon, size: 15, color: colorScheme.primary),
          label: Text(cat.label, style: const TextStyle(fontSize: 12)),
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }
}

class _GrupoCard extends StatelessWidget {
  const _GrupoCard({required this.grupo});

  final _GrupoData grupo;

  (Color, Color) _resolveContainer(ColorScheme cs) => switch (grupo.color) {
        _GrupoColor.primary => (cs.primaryContainer, cs.onPrimaryContainer),
        _GrupoColor.secondary => (
            cs.secondaryContainer,
            cs.onSecondaryContainer
          ),
        _GrupoColor.tertiary => (cs.tertiaryContainer, cs.onTertiaryContainer),
        _GrupoColor.neutral => (
            cs.surfaceContainerHighest,
            cs.onSurface,
          ),
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
                _CategoriaChip(
                  categoria: grupo.categoria,
                  accentColor: accentColor,
                  onContainerColor: onContainerColor,
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

class _CategoriaChip extends StatelessWidget {
  const _CategoriaChip({
    required this.categoria,
    required this.accentColor,
    required this.onContainerColor,
  });

  final _Categoria categoria;
  final Color accentColor;
  final Color onContainerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(categoria.icon, size: 12, color: accentColor),
          const SizedBox(width: 4),
          Text(
            categoria.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accentColor,
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
