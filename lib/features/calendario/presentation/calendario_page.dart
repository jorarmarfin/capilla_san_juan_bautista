import 'dart:async';
import 'dart:convert';

import 'package:capilla_san_juan_bautista/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------------------------------------------------------------------------
// Enum de modo de búsqueda
// ---------------------------------------------------------------------------

enum _SearchMode { texto, fecha }

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  Future<List<_CalEvento>>? _allEventsFuture;
  String? _mesFiltro;

  // Búsqueda
  _SearchMode _searchMode = _SearchMode.texto;
  final _textController = TextEditingController();
  DateTime? _selectedDate;
  Future<List<_CalEvento>>? _searchFuture;
  String? _activeQuery; // null = sin búsqueda activa
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _allEventsFuture = _fetchAllEvents();
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ---- API calls ----

  static Future<List<_CalEvento>> _fetchAllEvents() async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}/projects/${AppConfig.projectUuid}/events',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('Error ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['events'] as List<dynamic>)
        .map((e) => _CalEvento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<_CalEvento>> _fetchSearch(String q) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}/projects/${AppConfig.projectUuid}/events/search',
    ).replace(queryParameters: {'q': q});
    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('Error ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['events'] as List<dynamic>)
        .map((e) => _CalEvento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---- Handlers de búsqueda ----

  void _onTextChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      _clearSearch();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _triggerSearch(value.trim());
    });
  }

  void _onModeChanged(_SearchMode mode) {
    _clearSearch();
    setState(() => _searchMode = mode);
  }

  void _triggerSearch(String q) {
    setState(() {
      _activeQuery = q;
      _searchFuture = _fetchSearch(q);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _textController.clear();
    setState(() {
      _activeQuery = null;
      _searchFuture = null;
      _selectedDate = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (!mounted || picked == null) return;
    final q =
        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    setState(() => _selectedDate = picked);
    _triggerSearch(q);
  }

  // ---- Month helpers ----

  static String _mesKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}';

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

  // ---- Build ----

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchSection(
          mode: _searchMode,
          textController: _textController,
          selectedDate: _selectedDate,
          isSearching: _activeQuery != null,
          onModeChanged: _onModeChanged,
          onTextChanged: _onTextChanged,
          onPickDate: _pickDate,
          onClear: _clearSearch,
        ),
        Expanded(
          child: _activeQuery != null
              ? _buildSearchView()
              : _buildAllEventsView(),
        ),
      ],
    );
  }

  Widget _buildAllEventsView() {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<_CalEvento>>(
      future: _allEventsFuture,
      builder: (context, snapshot) {
        if (_allEventsFuture == null ||
            snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: LoadingAnimationWidget.beat(
              color: colorScheme.primary,
              size: 48,
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return _ErrorView(colorScheme: colorScheme);
        }

        final todos = snapshot.data!;
        final meses = todos
            .map((e) => _mesKey(e.startDate))
            .toSet()
            .toList()
          ..sort();
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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

  Widget _buildSearchView() {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<_CalEvento>>(
      future: _searchFuture,
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
          return _ErrorView(
            colorScheme: colorScheme,
            message: 'No se pudo completar la búsqueda.',
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: _SearchResultsSection(
            results: snapshot.data!,
            query: _activeQuery!,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Barra de búsqueda fija
// ---------------------------------------------------------------------------

class _SearchSection extends StatelessWidget {
  const _SearchSection({
    required this.mode,
    required this.textController,
    required this.selectedDate,
    required this.isSearching,
    required this.onModeChanged,
    required this.onTextChanged,
    required this.onPickDate,
    required this.onClear,
  });

  final _SearchMode mode;
  final TextEditingController textController;
  final DateTime? selectedDate;
  final bool isSearching;
  final ValueChanged<_SearchMode> onModeChanged;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onPickDate;
  final VoidCallback onClear;

  static String _formatDate(DateTime dt) {
    const meses = [
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
    return '${dt.day} ${meses[dt.month]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle modo
          SegmentedButton<_SearchMode>(
            segments: const [
              ButtonSegment(
                value: _SearchMode.texto,
                label: Text('Título / contenido'),
                icon: Icon(Icons.search, size: 16),
              ),
              ButtonSegment(
                value: _SearchMode.fecha,
                label: Text('Fecha'),
                icon: Icon(Icons.calendar_today_outlined, size: 16),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (v) => onModeChanged(v.first),
            style: SegmentedButton.styleFrom(
              textStyle: textTheme.labelSmall,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 10),
          // Input según modo
          if (mode == _SearchMode.texto)
            TextField(
              controller: textController,
              onChanged: onTextChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar por título o descripción...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: 'Limpiar búsqueda',
                        onPressed: onClear,
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                isDense: true,
                filled: true,
                fillColor:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: Text(
                      selectedDate != null
                          ? _formatDate(selectedDate!)
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        color: selectedDate != null
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onPressed: onPickDate,
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                    ),
                  ),
                ),
                if (isSearching) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClear,
                    tooltip: 'Limpiar búsqueda',
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Resultados de búsqueda
// ---------------------------------------------------------------------------

class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection({
    required this.results,
    required this.query,
  });

  final List<_CalEvento> results;
  final String query;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'Resultados para ',
                  style: textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: '"$query"',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${results.length} ${results.length == 1 ? 'resultado' : 'resultados'}',
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
        if (results.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sin resultados para esta búsqueda.',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          )
        else
          ...results.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EventoCard(evento: e),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Vista de error reutilizable
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.colorScheme, this.message});

  final ColorScheme colorScheme;
  final String? message;

  @override
  Widget build(BuildContext context) {
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
            message ?? 'No se pudieron cargar los eventos.',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
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
  final String startTime;
  final String? location;

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
// Widgets estáticos
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

  final List<String> meses;
  final String? seleccionado;
  final ValueChanged<String> onChanged;

  static String _label(String key) {
    final month = int.tryParse(key.split('-').last) ?? 0;
    return _mesAbrev[month];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                  fontWeight: activo ? FontWeight.bold : FontWeight.normal,
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
                    if (evento.location != null)
                      evento.hasLocationUrl
                          ? _LocationLink(url: evento.location!, color: color)
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

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
