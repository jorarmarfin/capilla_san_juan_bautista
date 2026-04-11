import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AdoracionCapillitaPage extends StatefulWidget {
  const AdoracionCapillitaPage({super.key});

  @override
  State<AdoracionCapillitaPage> createState() => _AdoracionCapillitaPageState();
}

class _Bloque {
  const _Bloque({
    required this.titulo,
    required this.cuerpo,
    required this.imagen,
  });

  final String titulo;
  final String cuerpo;
  final String imagen;

  factory _Bloque.fromJson(Map<String, dynamic> json) => _Bloque(
        titulo: json['titulo'] as String,
        cuerpo: json['cuerpo'] as String,
        imagen: json['imagen'] as String,
      );
}

class _AdoracionCapillitaPageState extends State<AdoracionCapillitaPage> {
  List<_Bloque> _bloques = [];

  @override
  void initState() {
    super.initState();
    _cargarBloques();
  }

  Future<void> _cargarBloques() async {
    final raw = await rootBundle.loadString('assets/data/adoracion.json');
    final lista = jsonDecode(raw) as List<dynamic>;
    if (mounted) {
      setState(() {
        _bloques = lista
            .map((e) => _Bloque.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    }
  }

  void _abrirLightbox(BuildContext context, String imagePath) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ImagenLightbox(imagePath: imagePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoracion en la capillita'),
      ),
      body: _bloques.isEmpty
          ? Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              itemCount: _bloques.length + 2, // +1 header horario, +1 footer CTA
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _HorarioHeader(colorScheme: colorScheme, textTheme: textTheme);
                }
                if (index == _bloques.length + 1) {
                  return _FooterCTA(colorScheme: colorScheme, textTheme: textTheme);
                }
                final bloque = _bloques[index - 1];
                return _BloqueCard(
                  bloque: bloque,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onImageTap: () => _abrirLightbox(context, bloque.imagen),
                );
              },
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header con el horario
// ---------------------------------------------------------------------------

class _HorarioHeader extends StatelessWidget {
  const _HorarioHeader({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Card(
        color: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                child: Icon(Icons.access_time, color: colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adoración Santísimo',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Todos los jueves · 6:00 PM',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer
                          .withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card de cada bloque (foto + texto)
// ---------------------------------------------------------------------------

class _BloqueCard extends StatelessWidget {
  const _BloqueCard({
    required this.bloque,
    required this.colorScheme,
    required this.textTheme,
    required this.onImageTap,
  });

  final _Bloque bloque;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onImageTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onImageTap,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    bloque.imagen,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.church,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  right: 10,
                  top: 10,
                  child: Icon(
                    Icons.open_in_full,
                    color: Colors.white,
                    size: 18,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bloque.titulo,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bloque.cuerpo,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.6,
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

// ---------------------------------------------------------------------------
// Footer motivacional + botón WhatsApp
// ---------------------------------------------------------------------------

class _FooterCTA extends StatelessWidget {
  const _FooterCTA({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const _whatsappUrl =
      'https://wa.me/51945212352?text=Hola%2C%20quiero%20dejar%20una%20petici%C3%B3n%20para%20la%20Adoraci%C3%B3n%20al%20Sant%C3%ADsimo%20%F0%9F%99%8F';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Icon(Icons.favorite, color: colorScheme.primary, size: 32),
          const SizedBox(height: 12),
          Text(
            '¿Tienes alguna petición o intención especial?',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Durante la Adoración llevamos ante el Señor\ntodas las intenciones que nos confíes.\nNo estás solo — Él te escucha. 🙏',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => launchUrl(
              Uri.parse(_whatsappUrl),
              mode: LaunchMode.externalApplication,
            ),
            icon: const Icon(Icons.chat),
            label: const Text('Déjanos tu petición o intención'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lightbox fullscreen para ver la imagen completa
// ---------------------------------------------------------------------------

class _ImagenLightbox extends StatelessWidget {
  const _ImagenLightbox({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const ColoredBox(
              color: Colors.transparent,
              child: SizedBox.expand(),
            ),
          ),
          Center(
            child: InteractiveViewer(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: IconButton.filled(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
