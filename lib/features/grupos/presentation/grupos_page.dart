import 'package:capilla_san_juan_bautista/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class GruposPage extends StatelessWidget {
  const GruposPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Grupos',
      description:
          'Espacios de participacion para ninos, jovenes, adultos y voluntariado.',
      highlights: ['Catequesis', 'Jovenes', 'Voluntariado'],
    );
  }
}
