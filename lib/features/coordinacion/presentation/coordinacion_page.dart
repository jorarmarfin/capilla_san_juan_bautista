import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CoordinacionPage extends StatefulWidget {
  const CoordinacionPage({super.key});

  @override
  State<CoordinacionPage> createState() => _CoordinacionPageState();
}

class _CoordinacionPageState extends State<CoordinacionPage> {
  late final Future<_CoordinacionData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  static Future<_CoordinacionData> _load() async {
    final raw = await rootBundle.loadString('assets/data/coordinacion.json');
    return _CoordinacionData.fromJson(
        jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<_CoordinacionData>(
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
                Icon(Icons.cloud_off_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
                const SizedBox(height: 12),
                Text('No se pudo cargar la información.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        return SingleChildScrollView(
          key: const ValueKey('coordinacion_page'),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PageHeader(),
              const SizedBox(height: 24),
              _ConsejoPrincipal(consejo: data.consejo),
              const SizedBox(height: 28),
              _Divider(label: 'Información de contacto'),
              const SizedBox(height: 16),
              _ContactoCard(contacto: data.contacto),
              const SizedBox(height: 28),
              _Divider(label: 'Horarios de atención'),
              const SizedBox(height: 16),
              _HorariosCard(
                horarios: data.horariosAtencion,
                reunionConsejo: data.reunionConsejo,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Modelos
// ---------------------------------------------------------------------------

class _Miembro {
  const _Miembro({
    required this.nombre,
    required this.rol,
    required this.orden,
    required this.responsabilidades,
    this.imagen,
  });

  final String nombre;
  final String rol;
  final int orden;
  final List<String> responsabilidades;
  final String? imagen;

  factory _Miembro.fromJson(Map<String, dynamic> json) => _Miembro(
        nombre: json['nombre'] as String,
        rol: json['rol'] as String,
        orden: json['orden'] as int,
        responsabilidades: (json['responsabilidades'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        imagen: json['imagen'] as String?,
      );
}

class _Contacto {
  const _Contacto({
    required this.telefono,
    required this.correo,
    required this.direccion,
  });

  final String telefono;
  final String correo;
  final String direccion;

  factory _Contacto.fromJson(Map<String, dynamic> json) => _Contacto(
        telefono: json['telefono'] as String,
        correo: json['correo'] as String,
        direccion: json['direccion'] as String,
      );
}

class _Horario {
  const _Horario({required this.dia, required this.horario});

  final String dia;
  final String horario;

  factory _Horario.fromJson(Map<String, dynamic> json) => _Horario(
        dia: json['dia'] as String,
        horario: json['horario'] as String,
      );
}

class _CoordinacionData {
  const _CoordinacionData({
    required this.consejo,
    required this.contacto,
    required this.horariosAtencion,
    required this.reunionConsejo,
  });

  final List<_Miembro> consejo;
  final _Contacto contacto;
  final List<_Horario> horariosAtencion;
  final String reunionConsejo;

  factory _CoordinacionData.fromJson(Map<String, dynamic> json) =>
      _CoordinacionData(
        consejo: (json['consejo'] as List<dynamic>)
            .map((e) => _Miembro.fromJson(e as Map<String, dynamic>))
            .toList(),
        contacto:
            _Contacto.fromJson(json['contacto'] as Map<String, dynamic>),
        horariosAtencion: (json['horarios_atencion'] as List<dynamic>)
            .map((e) => _Horario.fromJson(e as Map<String, dynamic>))
            .toList(),
        reunionConsejo: json['reunion_consejo'] as String,
      );
}

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
        Text('Coordinación', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'El Consejo de Coordinación es el equipo laico que acompaña '
          'la gestión pastoral y administrativa de la capilla.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ConsejoPrincipal extends StatelessWidget {
  const _ConsejoPrincipal({required this.consejo});

  final List<_Miembro> consejo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final principales = consejo.where((m) => m.orden == 1).toList();
    final secundarios = consejo.where((m) => m.orden == 2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consejo de Coordinación', style: textTheme.titleLarge),
        const SizedBox(height: 14),
        for (final m in principales) ...[
          _MiembroCard(miembro: m, destacado: true),
          const SizedBox(height: 12),
        ],
        for (final m in secundarios) ...[
          _MiembroCard(miembro: m, destacado: false),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MiembroCard extends StatelessWidget {
  const _MiembroCard({required this.miembro, required this.destacado});

  final _Miembro miembro;
  final bool destacado;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final accentColor = destacado ? colorScheme.primary : colorScheme.outline;
    final headerBg = destacado
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final headerFg = destacado
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentColor.withValues(alpha: 0.18),
                  backgroundImage: miembro.imagen != null
                      ? AssetImage(miembro.imagen!)
                      : null,
                  child: miembro.imagen == null
                      ? Icon(Icons.person, size: 26, color: accentColor)
                      : null,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      miembro.nombre,
                      style: textTheme.titleSmall?.copyWith(
                        color: headerFg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      miembro.rol,
                      style: textTheme.labelSmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...miembro.responsabilidades.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.arrow_right, size: 16, color: accentColor),
                        const SizedBox(width: 2),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactoCard extends StatelessWidget {
  const _ContactoCard({required this.contacto});

  final _Contacto contacto;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        children: [
          _ContactoTile(
            icon: Icons.phone_outlined,
            label: 'Teléfono',
            valor: contacto.telefono,
            color: colorScheme.primary,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _ContactoTile(
            icon: Icons.email_outlined,
            label: 'Correo',
            valor: contacto.correo,
            color: colorScheme.primary,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _ContactoTile(
            icon: Icons.location_on_outlined,
            label: 'Dirección',
            valor: contacto.direccion,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ContactoTile extends StatelessWidget {
  const _ContactoTile({
    required this.icon,
    required this.label,
    required this.valor,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, size: 18, color: color),
      ),
      title: Text(label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      subtitle: Text(valor, style: const TextStyle(fontSize: 13)),
    );
  }
}

class _HorariosCard extends StatelessWidget {
  const _HorariosCard({
    required this.horarios,
    required this.reunionConsejo,
  });

  final List<_Horario> horarios;
  final String reunionConsejo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        children: [
          for (int i = 0; i < horarios.length; i++) ...[
            if (i > 0) Divider(height: 1, color: colorScheme.outlineVariant),
            _HorarioTile(
              dia: horarios[i].dia,
              horario: horarios[i].horario,
              color: colorScheme.primary,
            ),
          ],
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.tertiary.withValues(alpha: 0.12),
              child: Icon(Icons.info_outline,
                  size: 18, color: colorScheme.tertiary),
            ),
            title: const Text('Reuniones del consejo',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            subtitle: Text(reunionConsejo,
                style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _HorarioTile extends StatelessWidget {
  const _HorarioTile({
    required this.dia,
    required this.horario,
    required this.color,
  });

  final String dia;
  final String horario;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(Icons.schedule, size: 18, color: color),
      ),
      title: Text(dia,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      subtitle: Text(horario, style: const TextStyle(fontSize: 13)),
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
