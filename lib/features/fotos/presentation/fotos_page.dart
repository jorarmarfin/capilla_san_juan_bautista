import 'package:capilla_san_juan_bautista/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class FotosPage extends StatelessWidget {
  const FotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Fotos',
      description:
          'Galeria visual de encuentros, celebraciones y vida parroquial.',
      highlights: [
        'Albumes por evento',
        'Recuerdos de comunidad',
        'Nuevas publicaciones',
      ],
    );
  }
}
