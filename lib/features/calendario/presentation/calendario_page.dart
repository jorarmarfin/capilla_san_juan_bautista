import 'dart:convert';

import 'package:capilla_san_juan_bautista/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late final Future<List<_CalEvento>> _future;
  String? _mesFiltro; // clave "YYYY-MM"

  @override
  void initState() {
    super.initState();
    _future = _fetchEventos();
  }

  static Future<List<_CalEvento>> _fetchEventos() async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}/projects/${AppConfig.projectUuid}/events',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['events'] as List<dynamic>)
        .map((e) => _CalEvento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // "YYYY-MM" desde un DateTime
  static String _mesKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}';

  // Nombre completo del mes, incluye año solo si difiere del actual
  static String _mesNombre(String key) {
    const nombres = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final parts = key.split('-');
    if (parts.length < 2) return key;
    final month = int.tryParse(parts[1]) ?? 0;
    final year = parts[0];
    final currentYear = DateTime.now().year.toString();
    return year == currentYear ? nombres[month] : '${nombres[month]} $year';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<_CalEvento>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: LoadingAnimationWidget.beat(
              color: colorScheme.primary,
              size: 48,
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 48,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 12),
                Text(
                  'No se pudieron cargar los eventos.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        final todos = snapshot.data!;

        // Meses únicos presentes en los eventos, ordenados
        final meses = todos
            .map((e) => _mesKey(e.startDate))
            .toSet()
            .toList()
          ..sort();

        // Filtro activo: el guardado en estado (si sigue vigente) o el primero
        final filtroActivo =
            _mesFiltro != null && meses.contains(_mesFiltro)
                ? _mesFiltro!
                : (meses.isNotEmpty ? meses.first : null);

        final filtrados = filtroActivo != null
            ? (todos
                .where((e) => _mesKey(e.startDate) == filtroActivo)
                .toList()
              ..sort((a, b) => a.startDate.compareTo(b.startDate)))
            : (todos.toList()
              ..sort((a, b) => a.startDate.compareTo(b.startDate)));

        return SingleChildScrollView(
          key: const ValueKey('calendario_page'),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeader(),
              const SizedBox(height: 20),
              if (meses.length > 1) ...[
                _MesSelectorRow(
                  meses: meses,
                  seleccionado: filtroActivo,
                  onChanged: (m) => setState(() => _mesFiltro = m),
                ),
                const SizedBox(height: 20),
              ],
              const _HorariosCard(),
              const SizedBox(height: 24),
              _EventosSection(
                eventos: filtrados,
                mesLabel: filtroActivo != null
                    ? _mesNombre(filtroActivo)
                    : 'Próximos',
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

class _CalEvento {
  const _CalEvento({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.startTime,
    this.location,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  final String startTime; // "HH:MM" para mostrar
  final String? location; // URL de Google Maps, texto plano, o null

  bool get hasLocationUrl =>
      location != null && location!.startsWith('http');

  factory _CalEvento.fromJson(Map<String, dynamic> json) {
    final locationRaw = json['location'] as String?;
    return _CalEvento(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      startDate: DateTime.parse(json['start_date'] as String),
      startTime: _fmtTime(json['start_time'] as String? ?? ''),
      location:
          (locationRaw == null || locationRaw.isEmpty) ? null : locationRaw,
    );
  }

  // "HH:MM:SS" → "HH:MM"
  static String _fmtTime(String raw) =>
      raw.length >= 5 ? raw.substring(0, 5) : raw;
}

// ---------------------------------------------------------------------------
// Helpers de categoría → color / ícono
// ---------------------------------------------------------------------------

Color _categoryColor(ColorScheme cs, String category) {
  return switch (category.toLowerCase()) {
    'misa' => cs.primary,
    'formación' || 'formacion' => cs.secondary,
    'servicio' => cs.tertiary,
    'celebración' || 'celebracion' => const Color(0xFF7B44C8),
    'retiro' => cs.primary,
    _ => cs.secondary,
  };
}

IconData _categoryIcon(String category) {
  return switch (category.toLowerCase()) {
    'misa' => Icons.church,
    'formación' || 'formacion' => Icons.menu_book,
    'servicio' => Icons.volunteer_activism,
    'celebración' || 'celebracion' => Icons.celebration,
    'retiro' => Icons.self_improvement,
    _ => Icons.event,
  };
}

// Abreviatura del mes para la franja lateral de la card
const _mesAbrev = [
  '',
  'Ene',
  'Feb',
  'Mar',
  'Abr',
  'May',
  'Jun',
  'Jul',
  'Ago',
  'Sep',
  'Oct',
  'Nov',
  'Dic',
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
    required this.meses,
    required this.seleccionado,
    required this.onChanged,
  });

  final List<String> meses; // claves "YYYY-MM"
  final String? seleccionado;
  final ValueChanged<String> onChanged;

  static String _label(String key) {
    final month = int.tryParse(key.split('-').last) ?? 0;
    return _mesAbrev[month];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Scroll horizontal por si hay muchos meses
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: meses.map((mes) {
          final activo = mes == seleccionado;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilledButton(
              onPressed: () => onChanged(mes),
              style: FilledButton.styleFrom(
                backgroundColor: activo
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                foregroundColor: activo
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _label(mes),
                style: TextStyle(
                  fontWeight:
                      activo ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
                Text(
                  'Horarios de misa regulares',
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const _HorarioRow(dia: 'Jueves y Sábado', hora: '7:00 PM'),
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
          Text(
            dia,
            style:
                TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
          Text(
            hora,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventosSection extends StatelessWidget {
  const _EventosSection({
    required this.eventos,
    required this.mesLabel,
  });

  final List<_CalEvento> eventos;
  final String mesLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Eventos de $mesLabel', style: textTheme.titleLarge),
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
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...eventos.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EventoCard(evento: e),
            ),
          ),
      ],
    );
  }
}

class _EventoCard extends StatelessWidget {
  const _EventoCard({required this.evento});

  final _CalEvento evento;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final color = _categoryColor(colorScheme, evento.category);

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
                    '${evento.startDate.day}',
                    style: textTheme.titleLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _mesAbrev[evento.startDate.month],
                    style: textTheme.labelSmall?.copyWith(color: color),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Contenido
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            evento.title,
                            style: textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _CategoryBadge(
                          category: evento.category,
                          color: color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _InfoLine(
                      icon: Icons.schedule,
                      text: evento.startTime,
                      color: color,
                    ),
                    // Ubicación: URL → tappable, texto → normal, null → oculto
                    if (evento.location != null)
                      evento.hasLocationUrl
                          ? _LocationLink(
                              url: evento.location!,
                              color: color,
                            )
                          : _InfoLine(
                              icon: Icons.location_on_outlined,
                              text: evento.location!,
                              color: color,
                            ),
                    if (evento.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        evento.description,
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

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category, required this.color});

  final String category;
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
          Icon(_categoryIcon(category), size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            category,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
    required this.color,
  });

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
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Muestra "Ver ubicación" como enlace tappable cuando la ubicación es una URL.
class _LocationLink extends StatelessWidget {
  const _LocationLink({required this.url, required this.color});

  final String url;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_outlined, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              'Ver ubicación',
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
