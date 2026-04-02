import 'package:flutter/material.dart';

class CoordinacionPage extends StatelessWidget {
  const CoordinacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('coordinacion_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _PageHeader(),
          SizedBox(height: 24),
          _ConsejoPrincipal(),
          SizedBox(height: 28),
          _Divider(label: 'Información de contacto'),
          SizedBox(height: 16),
          _ContactoCard(),
          SizedBox(height: 28),
          _Divider(label: 'Horarios de atención'),
          SizedBox(height: 16),
          _HorariosCard(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Datos
// ---------------------------------------------------------------------------

class _MiembroData {
  const _MiembroData({
    required this.nombre,
    required this.rol,
    required this.responsabilidades,
    required this.icono,
    required this.orden,
  });

  final String nombre;
  final String rol;
  final List<String> responsabilidades;
  final IconData icono;
  final int orden; // 1 = principal, 2 = secundario
}

const _consejo = <_MiembroData>[
  _MiembroData(
    nombre: 'Sr. Roberto Quispe',
    rol: 'Coordinador',
    responsabilidades: [
      'Presidir las reuniones del consejo',
      'Representar a la capilla ante la parroquia',
      'Coordinar las dimensiones pastorales',
      'Convocar asambleas comunitarias',
    ],
    icono: Icons.person,
    orden: 1,
  ),
  _MiembroData(
    nombre: 'Sra. Patricia Flores',
    rol: 'Subcoordinadora',
    responsabilidades: [
      'Apoyar y reemplazar al coordinador',
      'Supervisar los grupos pastorales',
      'Gestionar el calendario de actividades',
    ],
    icono: Icons.person,
    orden: 1,
  ),
  _MiembroData(
    nombre: 'Srta. Carmen López',
    rol: 'Secretaria',
    responsabilidades: [
      'Redactar actas de reuniones',
      'Gestionar comunicaciones oficiales',
      'Archivar documentos del consejo',
    ],
    icono: Icons.person,
    orden: 2,
  ),
  _MiembroData(
    nombre: 'Sra. María Condori',
    rol: 'Tesorera',
    responsabilidades: [
      'Administrar los fondos de la capilla',
      'Rendir cuentas en asamblea',
      'Gestionar ingresos y egresos',
    ],
    icono: Icons.person,
    orden: 2,
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
  const _ConsejoPrincipal();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Separar principales (orden 1) de secundarios (orden 2)
    final principales = _consejo.where((m) => m.orden == 1).toList();
    final secundarios = _consejo.where((m) => m.orden == 2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consejo de Coordinación', style: textTheme.titleLarge),
        const SizedBox(height: 14),
        // Coordinador y Subcoordinador en fila
        Row(
          children: [
            for (final m in principales) ...[
              Expanded(child: _MiembroCard(miembro: m, destacado: true)),
              if (m != principales.last) const SizedBox(width: 12),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Secretaria y Tesorera en fila
        Row(
          children: [
            for (final m in secundarios) ...[
              Expanded(child: _MiembroCard(miembro: m, destacado: false)),
              if (m != secundarios.last) const SizedBox(width: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class _MiembroCard extends StatelessWidget {
  const _MiembroCard({required this.miembro, required this.destacado});

  final _MiembroData miembro;
  final bool destacado;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor =
        destacado ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest;
    final fgColor =
        destacado ? colorScheme.onPrimaryContainer : colorScheme.onSurface;
    final accentColor = destacado ? colorScheme.primary : colorScheme.outline;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar + rol
          Container(
            color: bgColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: accentColor.withValues(alpha: 0.18),
                  child: Icon(Icons.person, size: 32, color: accentColor),
                ),
                const SizedBox(height: 8),
                Text(
                  miembro.rol,
                  style: textTheme.labelSmall?.copyWith(
                    color: fgColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Nombre y responsabilidades
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  miembro.nombre,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ...miembro.responsabilidades.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.arrow_right,
                            size: 16, color: accentColor),
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
  const _ContactoCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        children: [
          _ContactoTile(
            icon: Icons.phone_outlined,
            label: 'Teléfono',
            valor: '+51 999 000 111',
            color: colorScheme.primary,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _ContactoTile(
            icon: Icons.email_outlined,
            label: 'Correo',
            valor: 'coordinacion@capillasanjuanbautista.pe',
            color: colorScheme.primary,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _ContactoTile(
            icon: Icons.location_on_outlined,
            label: 'Dirección',
            valor: 'Jr. Principal 123, San Juan Bautista',
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
  const _HorariosCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        children: [
          _HorarioTile(
            dia: 'Lunes y Miércoles',
            horario: '6:00 PM — 8:00 PM',
            color: colorScheme.primary,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _HorarioTile(
            dia: 'Sábados',
            horario: '9:00 AM — 12:00 PM',
            color: colorScheme.primary,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor:
                  colorScheme.tertiary.withValues(alpha: 0.12),
              child: Icon(Icons.info_outline,
                  size: 18, color: colorScheme.tertiary),
            ),
            title: const Text('Reuniones del consejo',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            subtitle:
                const Text('Primer sábado de cada mes — Salón parroquial'),
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
