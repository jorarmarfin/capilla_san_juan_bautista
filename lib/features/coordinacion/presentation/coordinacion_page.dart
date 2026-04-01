import 'package:capilla_san_juan_bautista/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class CoordinacionPage extends StatelessWidget {
  const CoordinacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Coordinacion',
      description:
          'Equipo pastoral y responsables por area para contacto rapido.',
      highlights: [
        'Equipo de coordinacion',
        'Contactos por area',
        'Horarios de atencion',
      ],
    );
  }
}
