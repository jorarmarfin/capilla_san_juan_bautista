import 'package:flutter/material.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  _FiltroMes _mesFiltro = _FiltroMes.abril;

  @override
  Widget build(BuildContext context) {
    final eventosFiltrados = _eventos
        .where((e) => e.mes == _mesFiltro)
        .toList()
      ..sort((a, b) => a.dia.compareTo(b.dia));

    return SingleChildScrollView(
      key: const ValueKey('calendario_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(),
          const SizedBox(height: 20),
          _MesSelectorRow(
            seleccionado: _mesFiltro,
            onChanged: (m) => setState(() => _mesFiltro = m),
          ),
          const SizedBox(height: 20),
          const _HorariosCard(),
          const SizedBox(height: 24),
          _EventosSection(eventos: eventosFiltrados, mes: _mesFiltro),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Enums y modelo
// ---------------------------------------------------------------------------

enum _FiltroMes { marzo, abril, mayo, junio }

enum _TipoEvento { misa, formacion, servicio, celebracion, retiro }

extension _FiltroMesLabel on _FiltroMes {
  String get label => switch (this) {
        _FiltroMes.marzo => 'Mar',
        _FiltroMes.abril => 'Abr',
        _FiltroMes.mayo => 'May',
        _FiltroMes.junio => 'Jun',
      };

  String get nombre => switch (this) {
        _FiltroMes.marzo => 'Marzo',
        _FiltroMes.abril => 'Abril',
        _FiltroMes.mayo => 'Mayo',
        _FiltroMes.junio => 'Junio',
      };
}

extension _TipoEventoInfo on _TipoEvento {
  String get label => switch (this) {
        _TipoEvento.misa => 'Misa',
        _TipoEvento.formacion => 'Formación',
        _TipoEvento.servicio => 'Servicio',
        _TipoEvento.celebracion => 'Celebración',
        _TipoEvento.retiro => 'Retiro',
      };

  IconData get icono => switch (this) {
        _TipoEvento.misa => Icons.church,
        _TipoEvento.formacion => Icons.menu_book,
        _TipoEvento.servicio => Icons.volunteer_activism,
        _TipoEvento.celebracion => Icons.celebration,
        _TipoEvento.retiro => Icons.self_improvement,
      };
}

class _Evento {
  const _Evento({
    required this.titulo,
    required this.dia,
    required this.mes,
    required this.hora,
    required this.lugar,
    required this.tipo,
    this.descripcion,
  });

  final String titulo;
  final int dia;
  final _FiltroMes mes;
  final String hora;
  final String lugar;
  final _TipoEvento tipo;
  final String? descripcion;
}

// ---------------------------------------------------------------------------
// Datos mock
// ---------------------------------------------------------------------------

const _eventos = <_Evento>[
  // Marzo
  _Evento(
    titulo: 'Misa dominical',
    dia: 2,
    mes: _FiltroMes.marzo,
    hora: '8:00 AM y 6:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.misa,
  ),
  _Evento(
    titulo: 'Retiro de Cuaresma',
    dia: 8,
    mes: _FiltroMes.marzo,
    hora: '9:00 AM — 5:00 PM',
    lugar: 'Salón parroquial',
    tipo: _TipoEvento.retiro,
    descripcion: 'Jornada de reflexión y oración para toda la comunidad.',
  ),
  _Evento(
    titulo: 'Vía Crucis comunitario',
    dia: 15,
    mes: _FiltroMes.marzo,
    hora: '7:00 PM',
    lugar: 'Recorrido por el barrio',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Recorrido por las calles del barrio meditando la Pasión.',
  ),
  _Evento(
    titulo: 'Catequesis Familiar',
    dia: 22,
    mes: _FiltroMes.marzo,
    hora: '9:00 AM',
    lugar: 'Aulas de catequesis',
    tipo: _TipoEvento.formacion,
  ),
  _Evento(
    titulo: 'Colecta solidaria',
    dia: 29,
    mes: _FiltroMes.marzo,
    hora: 'Todo el día',
    lugar: 'Puerta de la capilla',
    tipo: _TipoEvento.servicio,
    descripcion: 'Recolección de víveres para familias necesitadas.',
  ),

  // Abril
  _Evento(
    titulo: 'Domingo de Ramos',
    dia: 6,
    mes: _FiltroMes.abril,
    hora: '8:00 AM',
    lugar: 'Atrio de la capilla',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Procesión y misa de inicio de la Semana Santa.',
  ),
  _Evento(
    titulo: 'Misa Crismal',
    dia: 10,
    mes: _FiltroMes.abril,
    hora: '7:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.misa,
  ),
  _Evento(
    titulo: 'Jueves Santo',
    dia: 11,
    mes: _FiltroMes.abril,
    hora: '6:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Misa de la Última Cena y adoración nocturna.',
  ),
  _Evento(
    titulo: 'Viernes Santo — Pasión',
    dia: 12,
    mes: _FiltroMes.abril,
    hora: '3:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Celebración de la Pasión del Señor y veneración de la Cruz.',
  ),
  _Evento(
    titulo: 'Vigilia Pascual',
    dia: 13,
    mes: _FiltroMes.abril,
    hora: '8:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.celebracion,
    descripcion: 'La noche más importante del año litúrgico.',
  ),
  _Evento(
    titulo: 'Domingo de Resurrección',
    dia: 14,
    mes: _FiltroMes.abril,
    hora: '8:00 AM y 6:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.misa,
  ),
  _Evento(
    titulo: 'Reunión del consejo',
    dia: 19,
    mes: _FiltroMes.abril,
    hora: '9:00 AM',
    lugar: 'Salón parroquial',
    tipo: _TipoEvento.formacion,
    descripcion: 'Primera reunión mensual del Consejo de Coordinación.',
  ),
  _Evento(
    titulo: 'Encuentro grupo Emanuel',
    dia: 25,
    mes: _FiltroMes.abril,
    hora: '7:00 PM',
    lugar: 'Salón principal',
    tipo: _TipoEvento.formacion,
  ),

  // Mayo
  _Evento(
    titulo: 'Mes de María — inicio',
    dia: 1,
    mes: _FiltroMes.mayo,
    hora: '7:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Inicio del mes mariano con rosario y canto a la Virgen.',
  ),
  _Evento(
    titulo: 'Retiro MOVES',
    dia: 10,
    mes: _FiltroMes.mayo,
    hora: '8:00 AM — 6:00 PM',
    lugar: 'Casa de retiros',
    tipo: _TipoEvento.retiro,
    descripcion: 'Jornada anual del Movimiento de la Esperanza.',
  ),
  _Evento(
    titulo: 'Primera Comunión',
    dia: 18,
    mes: _FiltroMes.mayo,
    hora: '10:00 AM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Celebración de la Primera Eucaristía de los niños de catequesis.',
  ),
  _Evento(
    titulo: 'Visita a adultos mayores',
    dia: 24,
    mes: _FiltroMes.mayo,
    hora: '10:00 AM',
    lugar: 'Domicilios del barrio',
    tipo: _TipoEvento.servicio,
  ),

  // Junio
  _Evento(
    titulo: 'Corpus Christi',
    dia: 8,
    mes: _FiltroMes.junio,
    hora: '9:00 AM',
    lugar: 'Procesión por el barrio',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Procesión eucarística con altares en las calles.',
  ),
  _Evento(
    titulo: 'Confirmación',
    dia: 14,
    mes: _FiltroMes.junio,
    hora: '5:00 PM',
    lugar: 'Iglesia principal',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Sacramento de Confirmación para los jóvenes del grupo pastoral.',
  ),
  _Evento(
    titulo: 'Fiesta de San Juan Bautista',
    dia: 24,
    mes: _FiltroMes.junio,
    hora: '8:00 AM y 7:00 PM',
    lugar: 'Iglesia principal y atrio',
    tipo: _TipoEvento.celebracion,
    descripcion: 'Gran celebración del patrono de la capilla con misa, procesión y compartir comunitario.',
  ),
  _Evento(
    titulo: 'Campana de invierno',
    dia: 28,
    mes: _FiltroMes.junio,
    hora: 'Todo el día',
    lugar: 'Puerta de la capilla',
    tipo: _TipoEvento.servicio,
    descripcion: 'Recolección de abrigos y frazadas para familias vulnerables.',
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
        Text('Calendario', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Actividades, celebraciones y eventos de nuestra comunidad.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _MesSelectorRow extends StatelessWidget {
  const _MesSelectorRow({
    required this.seleccionado,
    required this.onChanged,
  });

  final _FiltroMes seleccionado;
  final ValueChanged<_FiltroMes> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: _FiltroMes.values.map((mes) {
        final activo = mes == seleccionado;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: FilledButton(
              onPressed: () => onChanged(mes),
              style: FilledButton.styleFrom(
                backgroundColor: activo
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                foregroundColor: activo
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(mes.label,
                  style: TextStyle(
                      fontWeight:
                          activo ? FontWeight.bold : FontWeight.normal)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HorariosCard extends StatelessWidget {
  const _HorariosCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Horarios de misa regulares',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            const _HorarioRow(dia: 'Lunes a Viernes', hora: '7:00 PM'),
            const _HorarioRow(dia: 'Sábados', hora: '6:00 PM'),
            const _HorarioRow(dia: 'Domingos', hora: '8:00 AM y 6:00 PM'),
          ],
        ),
      ),
    );
  }
}

class _HorarioRow extends StatelessWidget {
  const _HorarioRow({required this.dia, required this.hora});

  final String dia;
  final String hora;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dia,
              style: TextStyle(
                  fontSize: 13, color: colorScheme.onSurfaceVariant)),
          Text(hora,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary)),
        ],
      ),
    );
  }
}

class _EventosSection extends StatelessWidget {
  const _EventosSection({required this.eventos, required this.mes});

  final List<_Evento> eventos;
  final _FiltroMes mes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Eventos de ${mes.nombre}', style: textTheme.titleLarge),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${eventos.length} eventos',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (eventos.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Sin eventos registrados para este mes.',
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...eventos.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _EventoCard(evento: e),
              )),
      ],
    );
  }
}

class _EventoCard extends StatelessWidget {
  const _EventoCard({required this.evento});

  final _Evento evento;

  Color _tipoColor(ColorScheme cs) => switch (evento.tipo) {
        _TipoEvento.misa => cs.primary,
        _TipoEvento.formacion => cs.secondary,
        _TipoEvento.servicio => cs.tertiary,
        _TipoEvento.celebracion => const Color(0xFF7B44C8),
        _TipoEvento.retiro => cs.primary,
      };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final color = _tipoColor(colorScheme);

    return Card(
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Franja lateral con el día
            Container(
              width: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${evento.dia}',
                    style: textTheme.titleLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    evento.mes.label,
                    style: textTheme.labelSmall?.copyWith(color: color),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            evento.titulo,
                            style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        _TipoBadge(tipo: evento.tipo, color: color),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _InfoLine(
                        icon: Icons.schedule, text: evento.hora, color: color),
                    _InfoLine(
                        icon: Icons.location_on_outlined,
                        text: evento.lugar,
                        color: color),
                    if (evento.descripcion != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        evento.descripcion!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _TipoBadge extends StatelessWidget {
  const _TipoBadge({required this.tipo, required this.color});

  final _TipoEvento tipo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tipo.icono, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            tipo.label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(
      {required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
