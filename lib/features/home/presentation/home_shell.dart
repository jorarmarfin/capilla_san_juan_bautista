import 'package:capilla_san_juan_bautista/features/avisos_parroquiales/presentation/avisos_parroquiales_page.dart';
import 'package:capilla_san_juan_bautista/features/calendario/presentation/calendario_page.dart';
import 'package:capilla_san_juan_bautista/features/congregacion/presentation/congregacion_page.dart';
import 'package:capilla_san_juan_bautista/features/coordinacion/presentation/coordinacion_page.dart';
import 'package:capilla_san_juan_bautista/features/creditos/presentation/creditos_page.dart';
import 'package:capilla_san_juan_bautista/features/dimensiones_pastorales/presentation/dimensiones_pastorales_page.dart';
import 'package:capilla_san_juan_bautista/features/sacramentos/presentation/sacramentos_page.dart';
import 'package:capilla_san_juan_bautista/features/fotos/presentation/fotos_page.dart';
import 'package:capilla_san_juan_bautista/features/grupos/presentation/grupos_page.dart';
import 'package:capilla_san_juan_bautista/features/historia/presentation/historia_page.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/home_page.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/widgets/app_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

enum AppSection {
  inicio,
  avisosParroquiales,
  sacramentos,
  historia,
  congregacion,
  dimensionesPastorales,
  grupos,
  coordinacion,
  calendario,
  fotos,
  creditos,
}

extension AppSectionX on AppSection {
  String get label {
    switch (this) {
      case AppSection.inicio:
        return 'Capilla San Juan Bautista';
      case AppSection.avisosParroquiales:
        return 'Avisos de Capilla';
      case AppSection.sacramentos:
        return 'Sacramentos';
      case AppSection.historia:
        return 'Historia';
      case AppSection.congregacion:
        return 'Congregación Religiosa';
      case AppSection.dimensionesPastorales:
        return 'Dimensiones Pastorales';
      case AppSection.grupos:
        return 'Grupos';
      case AppSection.coordinacion:
        return 'Coordinación';
      case AppSection.calendario:
        return 'Calendario';
      case AppSection.fotos:
        return 'Fotos';
      case AppSection.creditos:
        return 'Créditos';
    }
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  AppSection _currentSection = AppSection.inicio;
  // FIX 7: índice del bottom nav independiente de la sección activa
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      _checkForUpdate();
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (_) {
      // Silencioso: si falla (no Play Store, emulador, etc.) la app continúa normal
    }
  }

  Widget _buildSection() {
    switch (_currentSection) {
      case AppSection.inicio:
        return HomePage(onNavigate: _navigateTo);
      case AppSection.avisosParroquiales:
        return const AvisosParroquialesPage();
      case AppSection.sacramentos:
        return const SacramentosPage();
      case AppSection.historia:
        return const HistoriaPage();
      case AppSection.congregacion:
        return const CongregacionPage();
      case AppSection.dimensionesPastorales:
        return const DimensionesPastoralesPage();
      case AppSection.grupos:
        return const GruposPage();
      case AppSection.coordinacion:
        return const CoordinacionPage();
      case AppSection.calendario:
        return const CalendarioPage();
      case AppSection.fotos:
        return const FotosPage();
      case AppSection.creditos:
        return const CreditosPage();
    }
  }

  void _navigateTo(AppSection section) {
    setState(() => _currentSection = section);
  }

  void _onBottomDestinationSelected(int index) {
    setState(() {
      _bottomIndex = index; // FIX 7: solo actualiza cuando el usuario toca el bottom nav
      switch (index) {
        case 0:
          _currentSection = AppSection.inicio;
        case 1:
          _currentSection = AppSection.calendario;
        case 2:
          _currentSection = AppSection.grupos;
        case 3:
          _currentSection = AppSection.dimensionesPastorales;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentSection.label)),
      drawer: AppDrawer(
        currentSection: _currentSection,
        onSectionSelected: (section) {
          setState(() {
            _currentSection = section;
          });
          Navigator.of(context).pop();
        },
      ),
      // FIX 2: KeyedSubtree para que AnimatedSwitcher detecte el cambio de sección
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey(_currentSection),
          child: _buildSection(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomIndex, // FIX 7
        onDestinationSelected: _onBottomDestinationSelected,
        // FIX 6: selectedIcon con variante rellena en cada destino
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Grupos',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Dimensiones',
          ),
        ],
      ),
    );
  }
}
