import 'package:flutter/material.dart';

class HistoriaPage extends StatelessWidget {
  const HistoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('historia_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------------------
          // Encabezado
          // ----------------------------------------------------------------
          const _SectionTitle('Historia de la Capilla'),
          const SizedBox(height: 16),
          _HistoriaImagen(
            path: 'assets/capilla_san_juan_bautista_old.jpg',
            caption: 'Capilla San Juan Bautista — vista antigua',
          ),
          const SizedBox(height: 16),
          const _BodyText(
            'La capilla San Juan Bautista de "El Pueblito" funciona como un nodo '
            'de memoria histórica y, a la vez, como un espacio religioso vivo: '
            'allí confluyen el recuerdo del antiguo pueblo de reducción indígena '
            '(siglo XVI), la historia agraria del valle, la creación política del '
            'distrito (1967) y las prácticas devocionales contemporáneas.',
          ),
          const SizedBox(height: 24),

          // ----------------------------------------------------------------
          // Sección 1 — Orígenes coloniales
          // ----------------------------------------------------------------
          const _SectionHeading(
            icon: Icons.history_edu,
            text: 'Orígenes: La reducción indígena',
          ),
          const SizedBox(height: 10),
          const _BodyText(
            'El Pueblito nació alrededor de 1575 como reducción de indios, '
            'un modelo colonial que concentraba población dispersa en pueblos '
            'con traza urbana, plaza central y control eclesiástico. '
            'Documentos coloniales lo nombran "Pueblo de Todos los Santos de '
            'Lurigancho", y antes de la fundación española el territorio era '
            'habitado por poblaciones vinculadas a la cultura Ichma '
            '(1000 d.C. – 1532 d.C.).',
          ),
          const SizedBox(height: 12),
          const _BodyText(
            'En esa lógica, la capilla no fue un adorno tardío: fue el dispositivo '
            'central de evangelización y organización territorial. La advocación '
            '"San Juan" del distrito proviene precisamente del santo asociado a '
            'esta reducción, convirtiendo a la capilla en parte del ADN '
            'identitario del distrito.',
          ),
          const SizedBox(height: 16),

          // Imagen 1 — El Pueblo de Lurigancho, 1938
          _HistoriaImagen(
            path: 'assets/historia_05.jpeg',
            caption: 'El Pueblo de Lurigancho, 1938',
          ),
          const SizedBox(height: 12),
          // Imagen 2 — Vista aérea contemporánea de El Pueblito
          _HistoriaImagen(
            path: 'assets/historia_02.jpeg',
            caption: 'Vista aérea de El Pueblito, San Juan de Lurigancho',
          ),
          const SizedBox(height: 24),

          // ----------------------------------------------------------------
          // Sección 2 — El templo a través de los siglos
          // ----------------------------------------------------------------
          const _SectionHeading(
            icon: Icons.church_outlined,
            text: 'El templo a través de los siglos',
          ),
          const SizedBox(height: 10),
          const _BodyText(
            'La primera edificación religiosa del lugar colapsó con el gran '
            'terremoto de 1746, el mayor sismo registrado en Lima en la época '
            'colonial. Fuentes locales señalan que la capilla sufrió también '
            'incendios repetidos a lo largo de los siglos.',
          ),
          const SizedBox(height: 10),
          const _BodyText(
            'En los años cuarenta del siglo XX un nuevo sismo volvió a destruir '
            'la antigua capilla (las fuentes históricas debaten si fue en 1940 o '
            '1944). En torno a 1950, gracias al esfuerzo conjunto de la parroquia, '
            'vecinos y autoridades locales, se levantó el edificio actual que hoy '
            'conocemos como la Capilla San Juan Bautista.',
          ),
          const SizedBox(height: 16),

          // Imagen 3 — Construcción de la capilla (~1950)
          _HistoriaImagen(
            path: 'assets/historia_01.jpeg',
            caption: 'Construcción de la capilla San Juan Bautista, c. 1950',
          ),
          const SizedBox(height: 24),

          // ----------------------------------------------------------------
          // Sección 3 — Patrimonio material
          // ----------------------------------------------------------------
          const _SectionHeading(
            icon: Icons.auto_awesome_outlined,
            text: 'Patrimonio material: La imagen del santo',
          ),
          const SizedBox(height: 10),
          const _BodyText(
            'Entre los bienes más significativos de la capilla destaca una talla '
            'virreinal de San Juan Bautista en madera policromada con pan de oro, '
            'evidencia valiosa del proceso evangelizador en el valle del Rímac.',
          ),
          const SizedBox(height: 10),
          const _BodyText(
            'Tras la construcción del templo en 1950 varias imágenes dañadas '
            'fueron retiradas. Una imagen antigua de San Juan Bautista fue '
            'recuperada desde custodia privada gracias a la mediación de actores '
            'municipales, eclesiales y académicos, y posteriormente restaurada '
            'con apoyo universitario.',
          ),
          const SizedBox(height: 24),

          // ----------------------------------------------------------------
          // Sección 4 — Festividades y vida comunitaria
          // ----------------------------------------------------------------
          const _SectionHeading(
            icon: Icons.celebration_outlined,
            text: 'Festividades y vida comunitaria',
          ),
          const SizedBox(height: 10),
          const _BodyText(
            'Cada 24 de junio los vecinos celebran la Fiesta de San Juan Bautista: '
            'los fieles sacan la cruz desde la capilla y el patrón sale en '
            'procesión por las calles del Pueblito. La festividad reúne misa '
            'central, procesión de la imagen, verbena, bandas, danza y gastronomía '
            'local, mostrando la doble cara de la capilla: templo litúrgico y '
            'plataforma de sociabilidad comunitaria.',
          ),
          const SizedBox(height: 10),
          const _BodyText(
            'La capilla opera como institución de continuidad en un distrito de '
            'cambios rápidos: no solo "está allí", sino que ordena prácticas, '
            'recorridos y memorias frente a la urbanización acelerada de '
            'San Juan de Lurigancho.',
          ),
          const SizedBox(height: 16),
          // Imagen 4 — Comunidad reunida
          _HistoriaImagen(
            path: 'assets/historia_03.jpeg',
            caption: 'Comunidad de El Pueblito reunida en la capilla',
          ),
          const SizedBox(height: 12),
          // Imagen 5 — Vida comunitaria en el barrio
          _HistoriaImagen(
            path: 'assets/historia_04.jpeg',
            caption: 'Vida cotidiana en El Pueblito',
          ),
          const SizedBox(height: 28),

          // ----------------------------------------------------------------
          // Cronología
          // ----------------------------------------------------------------
          const _SectionHeading(
            icon: Icons.timeline,
            text: 'Cronología',
          ),
          const SizedBox(height: 16),
          const _TimelineItem(
            fecha: '~1000 d.C.',
            evento:
                'Poblaciones de la cultura Ichma habitan el valle hasta la llegada española (1532).',
          ),
          const _TimelineItem(
            fecha: '~1570–1575',
            evento:
                'Fundación del Pueblito como reducción de indios. La doctrina es dedicada a San Juan Bautista.',
          ),
          const _TimelineItem(
            fecha: '1746',
            evento:
                'Gran terremoto de Lima. Colapsa la primera edificación religiosa del valle.',
          ),
          const _TimelineItem(
            fecha: '1940 / 1944',
            evento:
                'Un nuevo sismo destruye la antigua capilla colonial. Las fuentes históricas difieren sobre el año exacto.',
          ),
          const _TimelineItem(
            fecha: '~1950',
            evento:
                'La comunidad, la parroquia y las autoridades locales construyen la capilla actual.',
          ),
          const _TimelineItem(
            fecha: '1967',
            evento:
                'Creación política del distrito de San Juan de Lurigancho. El Pueblito queda como su núcleo fundacional.',
          ),
          const _TimelineItem(
            fecha: '24 jun.\n(anual)',
            evento:
                'Fiesta patronal de San Juan Bautista: misa central, procesión del patrón y salida de la cruz desde la capilla.',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets auxiliares
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.headlineSmall);
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.65,
            ),
      );
}

class _HistoriaImagen extends StatelessWidget {
  const _HistoriaImagen({required this.path, required this.caption});

  final String path;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              path,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          caption,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.fecha,
    required this.evento,
    this.isLast = false,
  });

  final String fecha;
  final String evento;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha
          SizedBox(
            width: 72,
            child: Text(
              fecha,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 12),
          // Punto y línea
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Texto del evento
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                evento,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
