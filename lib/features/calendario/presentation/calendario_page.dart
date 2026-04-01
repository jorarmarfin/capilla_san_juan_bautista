import 'package:capilla_san_juan_bautista/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class CalendarioPage extends StatelessWidget {
  const CalendarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Calendario',
      description:
          'Actividades, celebraciones y eventos comunitarios organizados por fecha.',
      highlights: [
        'Misas semanales',
        'Fechas especiales',
        'Actividades comunitarias',
      ],
    );
  }
}
