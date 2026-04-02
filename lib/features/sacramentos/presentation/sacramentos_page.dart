import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SacramentosPage extends StatefulWidget {
  const SacramentosPage({super.key});

  @override
  State<SacramentosPage> createState() => _SacramentosPageState();
}

class _SacramentosPageState extends State<SacramentosPage> {
  late final Future<List<_SacramentoData>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  static Future<List<_SacramentoData>> _load() async {
    final raw = await rootBundle.loadString('assets/data/sacramentos.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => _SacramentoData.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_SacramentoData>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final sacramentos = snapshot.data ?? [];
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
              for (final s in sacramentos)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _SacramentoCard(data: s),
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

class _SacramentoData {
  const _SacramentoData({
    required this.nombre,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.descripcion,
    required this.requisitos,
    required this.contacto,
    required this.encargado,
    required this.fotoEquipo,
  });

  final String nombre;
  final String subtitulo;
  final IconData icono;
  final _SColor color;
  final String descripcion;
  final List<String> requisitos;
  final String contacto;
  final String encargado;
  final String? fotoEquipo;

  factory _SacramentoData.fromJson(Map<String, dynamic> json) {
    return _SacramentoData(
      nombre: json['nombre'] as String,
      subtitulo: json['subtitulo'] as String,
      icono: _iconFromString(json['icono'] as String),
      color: _colorFromString(json['color'] as String),
      descripcion: json['descripcion'] as String,
      requisitos: (json['requisitos'] as List<dynamic>).cast<String>(),
      contacto: json['contacto'] as String,
      encargado: json['encargado'] as String,
      fotoEquipo: json['foto_equipo'] as String?,
    );
  }

  static IconData _iconFromString(String name) => switch (name) {
        'brightness_high' => Icons.brightness_high,
        'local_fire_department' => Icons.local_fire_department,
        'water_drop' => Icons.water_drop,
        'favorite' => Icons.favorite,
        'handshake' => Icons.handshake,
        'healing' => Icons.healing,
        _ => Icons.church,
      };

  static _SColor _colorFromString(String value) => switch (value) {
        'primary' => _SColor.primary,
        'secondary' => _SColor.secondary,
        'tertiary' => _SColor.tertiary,
        _ => _SColor.neutral,
      };
}

enum _SColor { primary, secondary, tertiary, neutral }

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
        subtitle: RichText(
          text: TextSpan(
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
            children: [
              const TextSpan(
                text: 'Acércate a la secretaría en horario de atención o llama al ',
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () => launchUrl(Uri(scheme: 'tel', path: '+5116255500')),
                  child: Text(
                    '+51 1 6255500',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const TextSpan(text: '.'),
            ],
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
          // Cabecera
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
                    child: Icon(widget.data.icono, color: accentColor, size: 22),
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
                        // Foto del equipo
                        _FotoEquipo(
                          url: widget.data.fotoEquipo,
                          accentColor: accentColor,
                          encargado: widget.data.encargado,
                        ),
                        const SizedBox(height: 16),

                        // Descripción
                        Text(
                          widget.data.descripcion,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Requisitos
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
                                  child: Text(
                                    r,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Horario/contacto
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 15, color: accentColor),
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

class _FotoEquipo extends StatelessWidget {
  const _FotoEquipo({
    required this.url,
    required this.accentColor,
    required this.encargado,
  });

  final String? url;
  final Color accentColor;
  final String encargado;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 7,
        child: url != null && url!.isNotEmpty
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    _Placeholder(accentColor: accentColor, encargado: encargado),
              )
            : _Placeholder(accentColor: accentColor, encargado: encargado),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.accentColor, required this.encargado});

  final Color accentColor;
  final String encargado;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: accentColor.withValues(alpha: 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups_2_outlined,
              size: 36, color: accentColor.withValues(alpha: 0.4)),
          const SizedBox(height: 6),
          Text(
            encargado,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
