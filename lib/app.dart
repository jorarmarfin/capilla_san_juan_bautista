import 'package:capilla_san_juan_bautista/core/theme/app_theme.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/home_shell.dart';
import 'package:flutter/material.dart';

class CapillaApp extends StatelessWidget {
  const CapillaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capilla San Juan Bautista',
      theme: AppTheme.light,
      home: const HomeShell(),
    );
  }
}
