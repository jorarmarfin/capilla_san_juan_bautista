import 'dart:convert';

import 'package:capilla_san_juan_bautista/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AvisosParroquialesPage extends StatefulWidget {
  const AvisosParroquialesPage({super.key});

  @override
  State<AvisosParroquialesPage> createState() => _AvisosParroquialesPageState();
}

class _AvisosParroquialesPageState extends State<AvisosParroquialesPage> {
  late final Future<List<_Notice>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchNotices();
  }

  static Future<List<_Notice>> _fetchNotices() async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}/projects/${AppConfig.projectUuid}/notices',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('Error ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['notices'] as List<dynamic>)
        .map((e) => _Notice.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<_Notice>>(
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
                Text('No se pudieron cargar los avisos.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          );
        }

        final notices = snapshot.data!;

        if (notices.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.campaign_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                const SizedBox(height: 12),
                Text('No hay avisos por el momento.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          key: const ValueKey('avisos_parroquiales_page'),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Avisos de Capilla', style: textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(
                'Comunicados y anuncios de la comunidad.',
                style: textTheme.bodyLarge
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              for (final notice in notices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _NoticeCard(notice: notice),
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

class _Notice {
  const _Notice({
    required this.title,
    required this.content,
    required this.author,
    required this.publishedAt,
    this.filePath,
    this.fileType,
  });

  final String title;
  final String content;
  final String author;
  final String publishedAt;
  final String? filePath;
  final String? fileType;

  factory _Notice.fromJson(Map<String, dynamic> json) {
    final rawPath = json['file_path'] as String?;
    return _Notice(
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      publishedAt: _formatDate(json['published_at'] as String),
      filePath: rawPath != null
          ? '${AppConfig.storageUrl}/$rawPath'
          : null,
      fileType: json['file_type'] as String?,
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
// Widget
// ---------------------------------------------------------------------------

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice});

  final _Notice notice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.campaign_outlined,
                      size: 18, color: colorScheme.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    notice.title,
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              notice.content,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 13, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  notice.publishedAt,
                  style: textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 12),
                Icon(Icons.person_outline,
                    size: 13, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  notice.author,
                  style: textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            if (notice.filePath != null) ...[
              const SizedBox(height: 12),
              _NoticeFileButton(
                filePath: notice.filePath!,
                fileType: notice.fileType,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Botón de adjunto (imagen o documento)
// ---------------------------------------------------------------------------

class _NoticeFileButton extends StatelessWidget {
  const _NoticeFileButton({
    required this.filePath,
    required this.fileType,
  });

  final String filePath;
  final String? fileType;

  bool get _isImage => fileType == 'imagen';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        icon: Icon(
          _isImage ? Icons.image_outlined : Icons.download_outlined,
          size: 16,
        ),
        label: Text(_isImage ? 'Ver imagen' : 'Descargar documento'),
        style: OutlinedButton.styleFrom(
          foregroundColor:
              _isImage ? colorScheme.primary : colorScheme.secondary,
          side: BorderSide(
            color: _isImage
                ? colorScheme.primary.withValues(alpha: 0.4)
                : colorScheme.secondary.withValues(alpha: 0.4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(fontSize: 13),
        ),
        onPressed: () => _isImage
            ? _showImage(context)
            : _openDocument(context),
      ),
    );
  }

  void _showImage(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _ImageDialog(imageUrl: filePath),
    );
  }

  Future<void> _openDocument(BuildContext context) async {
    final uri = Uri.parse(filePath);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el documento.'),
          ),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Diálogo para mostrar imagen
// ---------------------------------------------------------------------------

class _ImageDialog extends StatelessWidget {
  const _ImageDialog({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.black54,
                    width: double.infinity,
                    height: 260,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.black54,
                  width: double.infinity,
                  height: 200,
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined,
                        color: Colors.white54, size: 48),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black54,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
