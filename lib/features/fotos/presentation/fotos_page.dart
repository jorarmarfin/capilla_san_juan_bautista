import 'dart:convert';

import 'package:capilla_san_juan_bautista/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

const _kPageSize = 6;

class FotosPage extends StatefulWidget {
  const FotosPage({super.key});

  @override
  State<FotosPage> createState() => _FotosPageState();
}

class _FotosPageState extends State<FotosPage> {
  late final Future<List<_Album>> _future;
  final _scrollController = ScrollController();

  List<_Album> _all = [];
  int _visibleCount = _kPageSize;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _future = _fetchAlbums();
    _future.then((albums) {
      if (mounted) setState(() => _all = albums);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadingMore) return;
    if (_visibleCount >= _all.length) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      setState(() => _loadingMore = true);
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() {
          _visibleCount = (_visibleCount + _kPageSize).clamp(0, _all.length);
          _loadingMore = false;
        });
      });
    }
  }

  static Future<List<_Album>> _fetchAlbums() async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}/projects/${AppConfig.projectUuid}/albums',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['albums'] as List<dynamic>;
    return list.map((e) => _Album.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<_Album>>(
      future: _future,
      builder: (context, snapshot) {
        final hasData = snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData;

        return CustomScrollView(
          key: const ValueKey('fotos_page'),
          controller: _scrollController,
          slivers: [
            // Cabecera
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Galería de Fotos', style: textTheme.headlineSmall),
                    const SizedBox(height: 6),
                    Text(
                      'Momentos de nuestra comunidad. Toca un álbum para verlo completo.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Estado: cargando / error / grilla
            if (!hasData)
              SliverFillRemaining(
                child: _buildStatus(snapshot, colorScheme),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _AlbumTile(album: _all[index]),
                    childCount: _visibleCount.clamp(0, _all.length),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                ),
              ),

            // Footer: spinner o espacio final
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: _loadingMore
                    ? Center(
                        child: LoadingAnimationWidget.beat(
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      )
                    : hasData && _visibleCount >= _all.length
                        ? Center(
                            child: Text(
                              '${_all.length} álbumes',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatus(
      AsyncSnapshot<List<_Album>> snapshot, ColorScheme colorScheme) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Center(
        child: LoadingAnimationWidget.beat(
          color: Theme.of(context).colorScheme.primary,
          size: 48,
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'No se pudieron cargar los álbumes.',
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

class _Album {
  const _Album({
    required this.name,
    required this.date,
    required this.photoCount,
    required this.thumbnailUrl,
    required this.url,
  });

  final String name;
  final String date;
  final int photoCount;
  final String thumbnailUrl;
  final String url;

  factory _Album.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] as String;
    return _Album(
      name: json['name'] as String,
      date: _formatDate(json['date'] as String),
      photoCount: json['photo_count'] as int,
      thumbnailUrl: '${AppConfig.storageUrl}/$thumbnail',
      url: json['url'] as String,
    );
  }

  static String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const meses = [
        '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
      ];
      return '${dt.day} ${meses[dt.month]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({required this.album});

  final _Album album;

  Future<void> _openUrl() async {
    final uri = Uri.parse(album.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openUrl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    album.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.photo_library_outlined,
                        size: 40,
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.photo, size: 11, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            '${album.photoCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 8,
                    child: Icon(
                      Icons.open_in_new,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    album.date,
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
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
