import 'package:capilla_san_juan_bautista/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class CongregacionPage extends StatelessWidget {
  const CongregacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Congregacion Religiosa',
      description:
          'Espacio para compartir la vida espiritual, mision y servicio de la congregacion en la comunidad.',
      highlights: [
        'Carisma y espiritualidad',
        'Mision pastoral',
        'Actividades y encuentros',
      ],
    );
  }
}
