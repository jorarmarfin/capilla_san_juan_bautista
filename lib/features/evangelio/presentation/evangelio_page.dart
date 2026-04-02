import 'package:flutter/material.dart';

class EvangelioPage extends StatelessWidget {
  const EvangelioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      key: const ValueKey('evangelio_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera litúrgica
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book,
                        color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Evangelio del día',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Miércoles — Tiempo Pascual',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Cita bíblica
          _SectionLabel(text: 'Lectura', colorScheme: colorScheme),
          const SizedBox(height: 6),
          Text(
            'Evangelio según San Juan (Jn 14, 1-6)',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // Texto del evangelio
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.format_quote,
                          color: colorScheme.primary.withValues(alpha: 0.4),
                          size: 32),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'En aquel tiempo, dijo Jesús a sus discípulos:\n\n'
                          '«No se turbe vuestro corazón; creed en Dios y creed también en mí. '
                          'En la casa de mi Padre hay muchas moradas; si no, os lo habría dicho. '
                          'Voy a prepararos un lugar. '
                          'Cuando vaya y os prepare un lugar, volveré y os llevaré conmigo, '
                          'para que donde esté yo estéis también vosotros. '
                          'Y adonde yo voy, ya sabéis el camino.»\n\n'
                          'Tomás le dice: «Señor, no sabemos adónde vas, ¿cómo podemos saber el camino?»\n\n'
                          'Jesús le responde: «Yo soy el Camino, la Verdad y la Vida. '
                          'Nadie va al Padre sino por mí.»',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.7,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Palabra del Señor',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Reflexión
          _SectionLabel(text: 'Reflexión', colorScheme: colorScheme),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '«Yo soy el Camino»',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Jesús no dice simplemente que conoce el camino o que puede enseñarlo; '
                    'Él mismo es el Camino. En un mundo que ofrece innumerables rutas hacia '
                    'la felicidad, el Evangelio nos recuerda que la plenitud del ser humano '
                    'solo se alcanza en comunión con Dios.\n\n'
                    'La promesa de Jesús —"voy a prepararos un lugar"— no es una metáfora '
                    'lejana, sino una certeza que sostiene la vida cotidiana del creyente. '
                    'Frente a la angustia y la incertidumbre, la fe nos invita a no dejar '
                    'que el corazón se turbe.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Oración final
          _SectionLabel(text: 'Oración', colorScheme: colorScheme),
          const SizedBox(height: 10),
          Card(
            color: colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.volunteer_activism,
                      color: colorScheme.onSecondaryContainer, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Señor Jesús, tú eres el Camino, la Verdad y la Vida. '
                      'Ayúdame a no turbar mi corazón con las angustias del mundo, '
                      'sino a confiar siempre en Ti, que me preparas un lugar en la '
                      'casa del Padre. Amén.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Próximas lecturas
          _SectionLabel(text: 'Próximas lecturas', colorScheme: colorScheme),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _LecturaRow(
                  dia: 'Jueves',
                  cita: 'Jn 14, 7-14',
                  titulo: '"El que me ha visto a mí ha visto al Padre"',
                  colorScheme: colorScheme,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _LecturaRow(
                  dia: 'Viernes',
                  cita: 'Jn 14, 15-21',
                  titulo: '"Os daré otro Paráclito"',
                  colorScheme: colorScheme,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _LecturaRow(
                  dia: 'Sábado',
                  cita: 'Jn 15, 1-8',
                  titulo: '"Yo soy la vid, vosotros los sarmientos"',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child: Text(
              'Las lecturas se actualizarán con la API litúrgica.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, required this.colorScheme});

  final String text;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: colorScheme.primary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _LecturaRow extends StatelessWidget {
  const _LecturaRow({
    required this.dia,
    required this.cita,
    required this.titulo,
    required this.colorScheme,
  });

  final String dia;
  final String cita;
  final String titulo;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Container(
        width: 44,
        alignment: Alignment.center,
        child: Text(
          dia,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      title: Text(cita,
          style: textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(titulo,
          style: textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant)),
    );
  }
}
