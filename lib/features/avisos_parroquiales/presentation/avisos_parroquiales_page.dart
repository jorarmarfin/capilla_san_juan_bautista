import 'dart:convert';

import 'package:capilla_san_juan_bautista/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  });

  final String title;
  final String content;
  final String author;
  final String publishedAt;

  factory _Notice.fromJson(Map<String, dynamic> json) => _Notice(
        title: json['title'] as String,
        content: json['content'] as String,
        author: json['author'] as String,
        publishedAt: _formatDate(json['published_at'] as String),
      );

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
          ],
        ),
      ),
    );
  }
}
