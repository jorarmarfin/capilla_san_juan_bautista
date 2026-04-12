import 'package:capilla_san_juan_bautista/core/theme/app_theme.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/home_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CapillaApp extends StatelessWidget {
  const CapillaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capilla San Juan Bautista',
      theme: AppTheme.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'PE'),
        Locale('en', 'US'),
      ],
      home: const HomeShell(),
    );
  }
}
