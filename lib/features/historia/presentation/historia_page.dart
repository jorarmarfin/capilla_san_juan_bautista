import 'package:flutter/material.dart';

class HistoriaPage extends StatelessWidget {
  const HistoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('historia_page'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _HeroBanner(),
          _Intro(),
          _Timeline(),
          _FundadoresSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Banner superior
// ---------------------------------------------------------------------------

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/800px-Placeholder_view_vector.svg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: colorScheme.primaryContainer,
              child: Icon(
                Icons.church,
                size: 80,
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
        // gradiente inferior para legibilidad del texto
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                ],
                stops: const [0.45, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Capilla San Juan Bautista',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Nuestra historia, nuestra fe',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Introduccion
// ---------------------------------------------------------------------------

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nuestra Historia', style: textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            'La Capilla San Juan Bautista nacio del amor y la fe de una comunidad '
            'que anhelaba un lugar de encuentro con Dios. Desde sus humildes '
            'comienzos hasta convertirse en el corazon espiritual del barrio, '
            'cada piedra de este templo guarda la historia de quienes la '
            'construyeron con sus manos y su oracion.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Linea de tiempo
// ---------------------------------------------------------------------------

class _TimelineEvent {
  const _TimelineEvent({
    required this.year,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String year;
  final String title;
  final String description;
  final IconData icon;
}

const _events = <_TimelineEvent>[
  _TimelineEvent(
    year: '1960',
    title: 'Los primeros pasos',
    description:
        'Un grupo de familias del barrio comienza a reunirse en casas particulares '
        'para celebrar la misa. Nace la semilla de la comunidad.',
    icon: Icons.groups,
  ),
  _TimelineEvent(
    year: '1965',
    title: 'El primer oratorio',
    description:
        'Se construye un pequeno oratorio de adobe como primer espacio de culto '
        'permanente, fruto de donaciones y trabajo voluntario.',
    icon: Icons.home_work,
  ),
  _TimelineEvent(
    year: '1972',
    title: 'Bendicion oficial',
    description:
        'El obispo diocesano bendice oficialmente la capilla y la dedica al '
        'patronazgo de San Juan Bautista, precursor del Senor.',
    icon: Icons.star,
  ),
  _TimelineEvent(
    year: '1985',
    title: 'Ampliacion del templo',
    description:
        'La comunidad crece y con ella el templo. Se amplian las naves laterales '
        'y se instala el vitral principal que ilumina el presbiterio.',
    icon: Icons.construction,
  ),
  _TimelineEvent(
    year: '1997',
    title: 'Restauracion y renovacion',
    description:
        'Proyecto de restauracion integral: nueva fachada, pisos de marmol '
        'y sistema de sonido. La capilla luce renovada para el nuevo milenio.',
    icon: Icons.auto_fix_high,
  ),
  _TimelineEvent(
    year: '2010',
    title: 'Cincuenta anos de comunidad',
    description:
        'Gran celebracion del 50 aniversario con una misa solemne presidida '
        'por el arzobispo y la participacion de cientos de fieles.',
    icon: Icons.celebration,
  ),
  _TimelineEvent(
    year: 'Hoy',
    title: 'Una comunidad viva',
    description:
        'La capilla sigue siendo el corazon del barrio: con grupos pastorales, '
        'catequesis, liturgia y servicio a los mas necesitados.',
    icon: Icons.favorite,
  ),
];

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Linea de Tiempo', style: textTheme.titleLarge),
          const SizedBox(height: 16),
          ...List.generate(_events.length, (index) {
            final event = _events[index];
            final isLast = index == _events.length - 1;
            return _TimelineItem(
              event: event,
              isLast: isLast,
              colorScheme: colorScheme,
              textTheme: textTheme,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.event,
    required this.isLast,
    required this.colorScheme,
    required this.textTheme,
  });

  final _TimelineEvent event;
  final bool isLast;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna del eje: circulo + linea vertical
          SizedBox(
            width: 56,
            child: Column(
              children: [
                _YearBadge(year: event.year, colorScheme: colorScheme),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            event.icon,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.title,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YearBadge extends StatelessWidget {
  const _YearBadge({required this.year, required this.colorScheme});

  final String year;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: Text(
        year,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: year.length > 4 ? 10 : 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Seccion fundadores / figuras clave
// ---------------------------------------------------------------------------

class _Fundador {
  const _Fundador({
    required this.nombre,
    required this.rol,
    required this.periodo,
  });

  final String nombre;
  final String rol;
  final String periodo;
}

const _fundadores = <_Fundador>[
  _Fundador(
    nombre: 'P. Miguel Arce',
    rol: 'Primer parroco fundador',
    periodo: '1965 - 1978',
  ),
  _Fundador(
    nombre: 'Hermana Rosa Villanueva',
    rol: 'Catequista y animadora pastoral',
    periodo: '1970 - 1992',
  ),
  _Fundador(
    nombre: 'Sr. Carlos Mendoza',
    rol: 'Presidente del primer consejo parroquial',
    periodo: '1972 - 1980',
  ),
];

class _FundadoresSection extends StatelessWidget {
  const _FundadoresSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Figuras que nos formaron', style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Sacerdotes y servidores que marcaron nuestra historia.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          ..._fundadores.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.person,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    f.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(f.rol),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      f.periodo,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
