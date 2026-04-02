import 'package:flutter/material.dart';

class SacramentosPage extends StatelessWidget {
  const SacramentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('sacramentos_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(),
          const SizedBox(height: 20),
          const _ContactoSolicitud(),
          const SizedBox(height: 24),
          for (final s in _sacramentos)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _SacramentoCard(data: s),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Datos
// ---------------------------------------------------------------------------

class _SacramentoData {
  const _SacramentoData({
    required this.nombre,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.descripcion,
    required this.requisitos,
    required this.contacto,
  });

  final String nombre;
  final String subtitulo;
  final IconData icono;
  final _SColor color;
  final String descripcion;
  final List<String> requisitos;
  final String contacto;
}

enum _SColor { primary, secondary, tertiary, neutral }

const _sacramentos = <_SacramentoData>[
  _SacramentoData(
    nombre: 'Bautismo',
    subtitulo: 'Sacramento de iniciación cristiana',
    icono: Icons.water_drop,
    color: _SColor.secondary,
    descripcion:
        'El Bautismo es el primer sacramento y la puerta de entrada a la vida '
        'cristiana. Mediante el agua y el Espíritu Santo, la persona nace de '
        'nuevo como hijo de Dios y es incorporada a la Iglesia.',
    requisitos: [
      'Solicitud con 30 días de anticipación',
      'Partida de nacimiento del bautizando',
      'DNI de los padres y padrinos',
      'Padrinos católicos confirmados',
      'Asistir a la charla prebautismal',
    ],
    contacto: 'Sábados 9:00 AM — Secretaría de la capilla',
  ),
  _SacramentoData(
    nombre: 'Primera Comunión',
    subtitulo: 'Eucaristía por primera vez',
    icono: Icons.brightness_high,
    color: _SColor.tertiary,
    descripcion:
        'La Primera Eucaristía es el momento en que el niño recibe a Jesús '
        'en el pan consagrado por primera vez. Requiere un proceso de '
        'preparación catequética de al menos un año.',
    requisitos: [
      'Estar bautizado',
      'Inscripción en catequesis de Primera Comunión',
      'Asistencia regular durante el año de formación',
      'Partida de bautismo',
      'Confesión previa al sacramento',
    ],
    contacto: 'Inscripciones en marzo — Aulas de catequesis',
  ),
  _SacramentoData(
    nombre: 'Confirmación',
    subtitulo: 'Plenitud del Bautismo',
    icono: Icons.local_fire_department,
    color: _SColor.primary,
    descripcion:
        'La Confirmación fortalece la gracia bautismal y une más '
        'perfectamente al confirmado con Cristo. El Espíritu Santo es '
        'donado para que el cristiano madure en su fe y la transmita.',
    requisitos: [
      'Estar bautizado y haber hecho la Primera Comunión',
      'Inscripción en el grupo Pastoral de Confirmación',
      'Proceso de formación de 1 a 2 años',
      'Elegir un padrino o madrina confirmado',
      'Retiro espiritual previo',
    ],
    contacto: 'Sábados 3:00 PM — Grupo Pastoral de Confirmación',
  ),
  _SacramentoData(
    nombre: 'Matrimonio',
    subtitulo: 'Sacramento del amor conyugal',
    icono: Icons.favorite,
    color: _SColor.tertiary,
    descripcion:
        'El Matrimonio cristiano es la alianza por la cual un hombre y una '
        'mujer constituyen una comunión de toda la vida, ordenada por su '
        'índole natural al bien de los cónyuges y a la generación de la vida.',
    requisitos: [
      'Solicitud con mínimo 6 meses de anticipación',
      'Partidas de bautismo y confirmación de ambos',
      'DNI de los novios y testigos',
      'Asistir al curso prematrimonial',
      'Certificado de soltería civil',
    ],
    contacto: 'Coordinador: Secretaría parroquial',
  ),
  _SacramentoData(
    nombre: 'Confesión',
    subtitulo: 'Sacramento de la Reconciliación',
    icono: Icons.handshake,
    color: _SColor.secondary,
    descripcion:
        'En la Confesión, el creyente recibe el perdón de Dios para los '
        'pecados cometidos después del Bautismo, mediante la absolución '
        'del sacerdote. Es el sacramento de la misericordia.',
    requisitos: [
      'Examen de conciencia previo',
      'Arrepentimiento sincero',
      'Propósito de enmienda',
      'No se requiere cita previa en los horarios regulares',
    ],
    contacto: 'Martes y jueves 6:00 PM — Sábados 4:00 PM',
  ),
  _SacramentoData(
    nombre: 'Unción de los Enfermos',
    subtitulo: 'Sacramento de la sanación',
    icono: Icons.healing,
    color: _SColor.neutral,
    descripcion:
        'La Unción de los Enfermos da a los enfermos graves la gracia de '
        'unirse estrechamente a la Pasión de Cristo, para su bien y el de '
        'toda la Iglesia. Se puede solicitar para enfermos graves o ancianos.',
    requisitos: [
      'Solicitud de un familiar o del propio enfermo',
      'Puede celebrarse en el hogar o en el hospital',
      'Comunicarse con anticipación a la capilla',
    ],
    contacto: 'Llamar al +51 999 000 111 para coordinar visita',
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
        Text('Sacramentos', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Los sacramentos son signos eficaces de la gracia instituidos '
          'por Cristo. Aquí encontrarás información sobre cada sacramento '
          'y cómo solicitarlo en nuestra capilla.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ContactoSolicitud extends StatelessWidget {
  const _ContactoSolicitud();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
          child: Icon(Icons.info_outline, color: colorScheme.primary),
        ),
        title: Text(
          'Para solicitar un sacramento',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Acércate a la secretaría en horario de atención o llama al +51 999 000 111.',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

class _SacramentoCard extends StatefulWidget {
  const _SacramentoCard({required this.data});

  final _SacramentoData data;

  @override
  State<_SacramentoCard> createState() => _SacramentoCardState();
}

class _SacramentoCardState extends State<_SacramentoCard> {
  bool _expandido = false;

  (Color, Color) _resolveContainer(ColorScheme cs) => switch (widget.data.color) {
        _SColor.primary => (cs.primaryContainer, cs.onPrimaryContainer),
        _SColor.secondary => (cs.secondaryContainer, cs.onSecondaryContainer),
        _SColor.tertiary => (cs.tertiaryContainer, cs.onTertiaryContainer),
        _SColor.neutral => (cs.surfaceContainerHighest, cs.onSurface),
      };

  Color _resolveAccent(ColorScheme cs) => switch (widget.data.color) {
        _SColor.primary => cs.primary,
        _SColor.secondary => cs.secondary,
        _SColor.tertiary => cs.tertiary,
        _SColor.neutral => cs.outline,
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
          // Cabecera — siempre visible, tapeable para expandir
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              color: containerColor,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: accentColor.withValues(alpha: 0.18),
                    child: Icon(widget.data.icono,
                        color: accentColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.nombre,
                          style: textTheme.titleMedium?.copyWith(
                            color: onContainerColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.data.subtitulo,
                          style: textTheme.bodySmall?.copyWith(
                            color: onContainerColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expandido
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: onContainerColor.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
          // Cuerpo expandible
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _expandido
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.descripcion,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _Label(text: 'Requisitos', color: accentColor),
                        const SizedBox(height: 8),
                        ...widget.data.requisitos.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 16, color: accentColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(r,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        height: 1.4,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 15, color: accentColor),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.data.contacto,
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
                  )
                : const SizedBox.shrink(),
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
