import 'package:capilla_san_juan_bautista/shared/widgets/section_placeholder.dart';
import 'package:flutter/material.dart';

class DimensionesPastoralesPage extends StatelessWidget {
  const DimensionesPastoralesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPlaceholder(
      title: 'Dimensiones Pastorales',
      description:
          'Ejes de vida comunitaria para fortalecer la fe, el anuncio y el servicio en la capilla.',
      highlights: ['Liturgia', 'Koinonia', 'Martyria', 'Diakonia'],
    );
  }
}
