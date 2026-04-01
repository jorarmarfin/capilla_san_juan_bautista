import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentBanner = 0;

  final List<String> _bannerImages = const [
    'https://images.unsplash.com/photo-1483695028939-5bb13f8648b0?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1466442929976-97f336a657be?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1504052434569-70ad5836ab65?auto=format&fit=crop&w=1200&q=80',
  ];

  @override
  void dispose() {
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
                Image.network(
                  'https://images.unsplash.com/photo-1548625361-58f9b86fd5e9?auto=format&fit=crop&w=1600&q=80',
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x00000000), Color(0xAA000000)],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Oracion del dia', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Senor, danos un corazon humilde para servir a nuestra comunidad con alegria y esperanza.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text('Accesos rapidos', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _QuickActionChip(icon: Icons.schedule, label: 'Horarios'),
              _QuickActionChip(icon: Icons.auto_stories, label: 'Evangelio'),
              _QuickActionChip(icon: Icons.favorite, label: 'Intenciones'),
              _QuickActionChip(icon: Icons.volunteer_activism, label: 'Ayuda'),
            ],
          ),
          const SizedBox(height: 18),
          Text('Banners', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bannerImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentBanner = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _bannerImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: colorScheme.secondary.withValues(
                                alpha: 0.2,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.image, size: 42),
                            );
                          },
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0x00000000), Color(0x88000000)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          bottom: 12,
                          child: Text(
                            'Banner ${index + 1} (maqueta)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerImages.length, (index) {
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
          const SizedBox(height: 18),
          Text('Horarios de misa', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: const [
                _ScheduleTile(day: 'Lunes a Viernes', time: '7:00 PM'),
                Divider(height: 1),
                _ScheduleTile(day: 'Sabado', time: '6:00 PM'),
                Divider(height: 1),
                _ScheduleTile(day: 'Domingo', time: '8:00 AM y 6:00 PM'),
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
            children: const [
              Expanded(
                child: _ServiceCard(
                  icon: Icons.church_outlined,
                  title: 'Sacramentos',
                  subtitle: 'Bautizo, matrimonio y confirmacion',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ServiceCard(
                  icon: Icons.record_voice_over_outlined,
                  title: 'Consejeria',
                  subtitle: 'Acompanamiento pastoral',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _ServiceCard(
            icon: Icons.location_on_outlined,
            title: 'Contacto y ubicacion',
            subtitle: 'Jr. Principal 123, San Juan | +51 999 999 999',
          ),
          const SizedBox(height: 18),
          Text('Redes sociales', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.facebook),
                label: const Text('Facebook'),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Instagram'),
              ),
              FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.tertiary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.ondemand_video),
                label: const Text('YouTube'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () {},
      avatar: Icon(icon, size: 18),
      label: Text(label),
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
