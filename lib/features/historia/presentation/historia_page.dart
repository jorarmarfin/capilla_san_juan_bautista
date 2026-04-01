import 'package:capilla_san_juan_bautista/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class HistoriaPage extends StatelessWidget {
  const HistoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Historia',
      description:
          'Linea de tiempo de la capilla, fundacion y hitos de la comunidad.',
      highlights: [
        'Origen de la capilla',
        'Sacerdotes y servidores',
        'Momentos importantes',
      ],
    );
  }
}
