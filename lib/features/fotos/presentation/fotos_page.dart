import 'package:flutter/material.dart';

class FotosPage extends StatefulWidget {
  const FotosPage({super.key});

  @override
  State<FotosPage> createState() => _FotosPageState();
}

class _FotosPageState extends State<FotosPage> {
  _Album? _albumSeleccionado;

  @override
  Widget build(BuildContext context) {
    return _albumSeleccionado == null
        ? _AlbumsView(onAlbumTap: (a) => setState(() => _albumSeleccionado = a))
        : _GrillaView(
            album: _albumSeleccionado!,
            onBack: () => setState(() => _albumSeleccionado = null),
          );
  }
}

// ---------------------------------------------------------------------------
// Modelo
// ---------------------------------------------------------------------------

class _Album {
  const _Album({
    required this.titulo,
    required this.fecha,
    required this.cantidad,
    required this.icono,
    required this.color,
  });

  final String titulo;
  final String fecha;
  final int cantidad;
  final IconData icono;
  final _AlbumColor color;
}

enum _AlbumColor { primary, secondary, tertiary, neutral }

const _albums = <_Album>[
  _Album(
    titulo: 'Semana Santa 2026',
    fecha: 'Abril 2026',
    cantidad: 18,
    icono: Icons.church,
    color: _AlbumColor.primary,
  ),
  _Album(
    titulo: 'Primera Comunión',
    fecha: 'Mayo 2025',
    cantidad: 24,
    icono: Icons.celebration,
    color: _AlbumColor.secondary,
  ),
  _Album(
    titulo: 'Fiesta de San Juan Bautista',
    fecha: 'Junio 2025',
    cantidad: 32,
    icono: Icons.star,
    color: _AlbumColor.tertiary,
  ),
  _Album(
    titulo: 'Retiro MOVES',
    fecha: 'Mayo 2025',
    cantidad: 15,
    icono: Icons.self_improvement,
    color: _AlbumColor.secondary,
  ),
  _Album(
    titulo: 'Corpus Christi',
    fecha: 'Junio 2025',
    cantidad: 20,
    icono: Icons.volunteer_activism,
    color: _AlbumColor.primary,
  ),
  _Album(
    titulo: 'Campaña solidaria',
    fecha: 'Agosto 2025',
    cantidad: 10,
    icono: Icons.favorite,
    color: _AlbumColor.neutral,
  ),
];

// ---------------------------------------------------------------------------
// Vista de álbumes
// ---------------------------------------------------------------------------

class _AlbumsView extends StatelessWidget {
  const _AlbumsView({required this.onAlbumTap});

  final ValueChanged<_Album> onAlbumTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      key: const ValueKey('fotos_page'),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Galería de Fotos', style: textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            'Momentos de nuestra comunidad organizados por álbum.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _albums.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) => _AlbumTile(
              album: _albums[index],
              onTap: () => onAlbumTap(_albums[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({required this.album, required this.onTap});

  final _Album album;
  final VoidCallback onTap;

  (Color, Color) _colors(ColorScheme cs) => switch (album.color) {
        _AlbumColor.primary => (cs.primaryContainer, cs.onPrimaryContainer),
        _AlbumColor.secondary => (
            cs.secondaryContainer,
            cs.onSecondaryContainer
          ),
        _AlbumColor.tertiary => (cs.tertiaryContainer, cs.onTertiaryContainer),
        _AlbumColor.neutral => (
            cs.surfaceContainerHighest,
            cs.onSurface,
          ),
      };

  Color _accent(ColorScheme cs) => switch (album.color) {
        _AlbumColor.primary => cs.primary,
        _AlbumColor.secondary => cs.secondary,
        _AlbumColor.tertiary => cs.tertiary,
        _AlbumColor.neutral => cs.outline,
      };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final (bgColor, fgColor) = _colors(colorScheme);
    final accentColor = _accent(colorScheme);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Miniatura del álbum
            Expanded(
              child: Container(
                color: bgColor,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(album.icono, size: 48, color: accentColor.withValues(alpha: 0.35)),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.photo, size: 11,
                                color: Colors.white),
                            const SizedBox(width: 3),
                            Text(
                              '${album.cantidad}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.titulo,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    album.fecha,
                    style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vista de grilla de fotos dentro de un álbum
// ---------------------------------------------------------------------------

class _GrillaView extends StatelessWidget {
  const _GrillaView({required this.album, required this.onBack});

  final _Album album;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera con botón atrás
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 16, 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(album.titulo,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      '${album.fecha} · ${album.cantidad} fotos',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Grilla
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            itemCount: album.cantidad,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) =>
                _FotoPlaceholder(index: index, album: album),
          ),
        ),
      ],
    );
  }
}

class _FotoPlaceholder extends StatelessWidget {
  const _FotoPlaceholder({required this.index, required this.album});

  final int index;
  final _Album album;

  Color _bg(ColorScheme cs) => switch (album.color) {
        _AlbumColor.primary =>
          cs.primaryContainer.withValues(alpha: 0.5 + (index % 3) * 0.15),
        _AlbumColor.secondary =>
          cs.secondaryContainer.withValues(alpha: 0.5 + (index % 3) * 0.15),
        _AlbumColor.tertiary =>
          cs.tertiaryContainer.withValues(alpha: 0.5 + (index % 3) * 0.15),
        _AlbumColor.neutral =>
          cs.surfaceContainerHighest.withValues(alpha: 0.6 + (index % 3) * 0.13),
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: _bg(colorScheme),
        child: Icon(
          Icons.image_outlined,
          size: 28,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
