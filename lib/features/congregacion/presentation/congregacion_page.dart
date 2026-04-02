import 'package:flutter/material.dart';

class CongregacionPage extends StatelessWidget {
  const CongregacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('congregacion_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _PageHeader(),
          SizedBox(height: 28),
          _CongregacionCard(data: _carmelitas),
          SizedBox(height: 16),
          _SecularesCard(),
          SizedBox(height: 28),
          _Divider(label: 'Presencia anterior'),
          SizedBox(height: 16),
          _CongregacionCard(data: _hijasStaAna),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Datos
// ---------------------------------------------------------------------------

class _CongregacionData {
  const _CongregacionData({
    required this.nombre,
    required this.subtitulo,
    required this.periodo,
    required this.icono,
    required this.carisma,
    required this.mision,
    required this.actividades,
    this.activa = true,
    this.imagen,
  });

  final String nombre;
  final String subtitulo;
  final String periodo;
  final IconData icono;
  final String carisma;
  final String mision;
  final List<String> actividades;
  final bool activa;
  final String? imagen;
}

const _carmelitas = _CongregacionData(
  nombre: 'Carmelitas Descalzas',
  subtitulo: 'Orden de Nuestra Señora del Monte Carmelo',
  periodo: 'Desde 2019',
  icono: Icons.spa,
  imagen: 'assets/carmelitas.jpeg',
  carisma:
      'Las Carmelitas Descalzas viven el carisma contemplativo heredado de '
      'Santa Teresa de Jesús y San Juan de la Cruz: la oración profunda, '
      'el silencio interior y la entrega total a Dios como camino de santidad.',
  mision:
      'Desde su llegada a la capilla en 2010, animan la vida espiritual de '
      'la comunidad a través de la liturgia, la adoración eucarística y el '
      'acompañamiento a quienes buscan profundizar su fe.',
  actividades: [
    'Adoración eucarística',
    'Retiros espirituales',
    'Lectio Divina',
    'Acompañamiento espiritual',
    'Formación en oración',
  ],
  activa: true,
);

const _hijasStaAna = _CongregacionData(
  nombre: 'Hijas de Santa Ana',
  subtitulo: 'Congregación religiosa femenina',
  periodo: 'Hasta 2018',
  icono: Icons.auto_stories,
  imagen: 'assets/hijas_de_santa_ana.jpg',
  carisma:
      'Las Hijas de Santa Ana centraron su carisma en la educación cristiana '
      'y el servicio a la familia. Su presencia en la capilla fue un pilar '
      'formativo para generaciones de jóvenes y familias del barrio.',
  mision:
      'Durante décadas acompañaron la catequesis, los grupos juveniles y la '
      'preparación sacramental, dejando una huella imborrable en la identidad '
      'espiritual de la comunidad.',
  actividades: [
    'Catequesis infantil',
    'Grupos juveniles',
    'Preparación sacramental',
    'Visitas a familias',
    'Escuela de padres',
  ],
  activa: false,
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
        Text('Congregación Religiosa', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Conoce a las congregaciones que han consagrado su vida al servicio '
          'de Dios y de nuestra comunidad.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _CongregacionCard extends StatelessWidget {
  const _CongregacionCard({required this.data});

  final _CongregacionData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final accentColor =
        data.activa ? colorScheme.primary : colorScheme.outline;
    final containerColor = data.activa
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final onContainerColor = data.activa
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de color
          Container(
            padding: const EdgeInsets.all(16),
            color: containerColor,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: accentColor.withValues(alpha: 0.15),
                  child: Icon(data.icono, color: accentColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.nombre,
                        style: textTheme.titleMedium?.copyWith(
                          color: onContainerColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.subtitulo,
                        style: textTheme.bodySmall?.copyWith(
                          color: onContainerColor.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _PeriodoBadge(
                        texto: data.periodo,
                        activa: data.activa,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Imagen
          AspectRatio(
            aspectRatio: 16 / 9,
            child: data.imagen != null
                ? Image.asset(data.imagen!, fit: BoxFit.cover)
                : _ImagePlaceholder(nombre: data.nombre),
          ),
          // Cuerpo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(label: 'Carisma', colorScheme: colorScheme),
                const SizedBox(height: 6),
                Text(
                  data.carisma,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                _SectionLabel(label: 'Misión pastoral', colorScheme: colorScheme),
                const SizedBox(height: 6),
                Text(
                  data.mision,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                _SectionLabel(label: 'Actividades', colorScheme: colorScheme),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: data.actividades
                      .map(
                        (a) => Chip(
                          label: Text(a, style: const TextStyle(fontSize: 12)),
                          avatar: Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: accentColor,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecularesCard extends StatelessWidget {
  const _SecularesCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      colorScheme.tertiaryContainer,
                  child: Icon(
                    Icons.people,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seculares de Santa Ana',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rama secular — Hijas de Santa Ana',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Activa',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Imagen placeholder
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _ImagePlaceholder(nombre: 'Seculares de Santa Ana'),
            ),
            const SizedBox(height: 12),
            Text(
              'Las Seculares de Santa Ana son laicas que abrazan el carisma '
              'de las Hijas de Santa Ana desde el mundo. Comprometidas con '
              'la familia, la educación y el servicio, mantienen vivo el '
              'espíritu de la congregación en la vida cotidiana y en la '
              'pastoral de la capilla.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodoBadge extends StatelessWidget {
  const _PeriodoBadge({
    required this.texto,
    required this.activa,
    required this.colorScheme,
  });

  final String texto;
  final bool activa;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: activa
            ? colorScheme.primary.withValues(alpha: 0.15)
            : colorScheme.outline.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: activa
              ? colorScheme.primary.withValues(alpha: 0.4)
              : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            activa ? Icons.circle : Icons.history,
            size: 10,
            color: activa ? colorScheme.primary : colorScheme.outline,
          ),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: activa ? colorScheme.primary : colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.colorScheme});

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: colorScheme.primary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 36,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 8),
          Text(
            nombre,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
