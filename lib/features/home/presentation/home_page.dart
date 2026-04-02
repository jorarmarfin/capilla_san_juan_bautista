import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:capilla_san_juan_bautista/core/config/app_config.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/home_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onNavigate});

  final ValueChanged<AppSection> onNavigate;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _Oracion {
  const _Oracion({required this.texto, required this.autor});
  final String texto;
  final String autor;
}

class _Banner {
  const _Banner({required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;

  factory _Banner.fromJson(Map<String, dynamic> json) => _Banner(
        title: json['title'] as String,
        imageUrl: '${AppConfig.storageUrl}/${json['image_path']}',
      );
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentBanner = 0;
  Timer? _autoAdvanceTimer;
  _Oracion? _oracion;
  List<_Banner> _banners = [];

  @override
  void initState() {
    super.initState();
    _cargarOracionAleatoria();
    _cargarBanners();
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageController.hasClients && _banners.length > 1) {
        final next = (_currentBanner + 1) % _banners.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      key: const ValueKey('inicio_page'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.asset(
                  'assets/capilla_san_juan_bautista.jpg',
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 210,
                      color: colorScheme.primary.withValues(alpha: 0.18),
                      alignment: Alignment.center,
                      child: const Icon(Icons.church, size: 52),
                    );
                  },
                ),
                // FIX 3: colores sin hardcodear
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.68),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Text(
                    'Capilla San Juan Bautista',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _oracion == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.format_quote,
                                color: colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Text('Oración del día',
                                style: textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _oracion!.texto,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '— ${_oracion!.autor}',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text('Accesos rapidos', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          SizedBox(
            height: 88,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                _QuickActionTile(
                  icon: Icons.groups_outlined,
                  label: 'Grupos',
                  onPressed: () =>
                      widget.onNavigate(AppSection.grupos),
                ),
                _QuickActionTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Fotos',
                  onPressed: () =>
                      widget.onNavigate(AppSection.fotos),
                ),
                _QuickActionTile(
                  icon: Icons.church_outlined,
                  label: 'Sacramentos',
                  onPressed: () =>
                      widget.onNavigate(AppSection.sacramentos),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // FIX 8: "Anuncios" en lugar de "Banners"
          Text('Anuncios', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          if (_banners.isEmpty)
            SizedBox(
              height: 170,
              child: Center(
                child: LoadingAnimationWidget.beat(
                  color: colorScheme.primary,
                  size: 40,
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 170,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _banners.length,
                onPageChanged: (index) =>
                    setState(() => _currentBanner = index),
                itemBuilder: (context, index) {
                  final banner = _banners[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => _openLightbox(context, index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              banner.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: colorScheme.secondary
                                    .withValues(alpha: 0.2),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image, size: 42),
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.53),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 12,
                              bottom: 12,
                              child: Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_banners.length, (index) {
                final isActive = index == _currentBanner;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.primary.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(100),
                  ),
                );
              }),
            ),
          ],
          const SizedBox(height: 18),
          Text('Horarios de misa', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: const [
                _ScheduleTile(day: 'Jueves', time: '7:00 PM'),
                Divider(height: 1),
                _ScheduleTile(day: 'Sábado', time: '7:00 PM'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Avisos parroquiales', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: const [
                _NoticeTile(
                  icon: Icons.campaign_outlined,
                  title: 'Retiro comunitario',
                  subtitle: 'Este sabado 9:00 AM en el salon parroquial.',
                ),
                Divider(height: 1),
                _NoticeTile(
                  icon: Icons.favorite_outline,
                  title: 'Campana solidaria',
                  subtitle: 'Recoleccion de viveres hasta fin de mes.',
                ),
                Divider(height: 1),
                _NoticeTile(
                  icon: Icons.groups_2_outlined,
                  title: 'Encuentro de familias',
                  subtitle: 'Domingo luego de la misa de la tarde.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Servicios de la capilla', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ServicioTile(
                  icon: Icons.auto_stories_outlined,
                  label: 'Catequesis',
                  onTap: () => _showProximamente(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ServicioTile(
                  icon: Icons.volunteer_activism_outlined,
                  label: 'Solidaridad',
                  onTap: () => _showProximamente(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ServicioTile(
                  icon: Icons.location_on_outlined,
                  label: 'Ubicación',
                  onTap: () => launchUrl(
                    Uri.parse(
                      'https://www.google.com/maps?q=-12.0175726,-77.0034234',
                    ),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Redes sociales', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () => launchUrl(
              Uri.parse('https://www.facebook.com/capilla.bautista'),
              mode: LaunchMode.externalApplication,
            ),
            icon: const Icon(Icons.facebook),
            label: const Text('Facebook'),
          ),
        ],
      ),
    );
  }

  Future<void> _cargarOracionAleatoria() async {
    final raw = await rootBundle.loadString('assets/data/oraciones.json');
    final lista = (jsonDecode(raw) as List<dynamic>);
    final item = lista[Random().nextInt(lista.length)] as Map<String, dynamic>;
    if (mounted) {
      setState(() {
        _oracion = _Oracion(
          texto: item['texto'] as String,
          autor: item['autor'] as String,
        );
      });
    }
  }

  void _showProximamente(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proximamente disponible'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _cargarBanners() async {
    try {
      final uri = Uri.parse(
        '${AppConfig.baseUrl}/projects/${AppConfig.projectUuid}/banners',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['banners'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .where((e) => e['is_active'] == true)
          .map(_Banner.fromJson)
          .toList();
      if (mounted) setState(() => _banners = list);
    } catch (_) {
      // Falla silenciosa — el slider queda vacío
    }
  }

  void _openLightbox(BuildContext context, int index) {
    final banner = _banners[index];
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _BannerLightbox(
        imageUrl: banner.imageUrl,
        label: banner.title,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lightbox de banners
// ---------------------------------------------------------------------------

class _BannerLightbox extends StatelessWidget {
  const _BannerLightbox({required this.imageUrl, required this.label});

  final String imageUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Fondo negro tapeable para cerrar
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const ColoredBox(
              color: Colors.transparent,
              child: SizedBox.expand(),
            ),
          ),
          // Imagen centrada con interactividad
          Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
          ),
          // Botón de cerrar
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
          // Label en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      colorScheme.primary.withValues(alpha: 0.15),
                  child: Icon(icon, size: 22, color: colorScheme.primary),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.day, required this.time});

  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text(day),
      trailing: Text(time, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _ServicioTile extends StatelessWidget {
  const _ServicioTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(icon, color: colorScheme.primary, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
