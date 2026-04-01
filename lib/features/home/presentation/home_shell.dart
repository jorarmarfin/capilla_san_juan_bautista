import 'package:capilla_san_juan_bautista/features/calendario/presentation/calendario_page.dart';
import 'package:capilla_san_juan_bautista/features/congregacion/presentation/congregacion_page.dart';
import 'package:capilla_san_juan_bautista/features/coordinacion/presentation/coordinacion_page.dart';
import 'package:capilla_san_juan_bautista/features/creditos/presentation/creditos_page.dart';
import 'package:capilla_san_juan_bautista/features/dimensiones_pastorales/presentation/dimensiones_pastorales_page.dart';
import 'package:capilla_san_juan_bautista/features/fotos/presentation/fotos_page.dart';
import 'package:capilla_san_juan_bautista/features/grupos/presentation/grupos_page.dart';
import 'package:capilla_san_juan_bautista/features/historia/presentation/historia_page.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/home_page.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

enum AppSection {
  inicio,
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
      case AppSection.historia:
        return 'Historia';
      case AppSection.congregacion:
        return 'Congregaci+on Religiosa';
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

  Widget _buildSection() {
    switch (_currentSection) {
      case AppSection.inicio:
        return const HomePage();
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

  int _bottomIndexForSection(AppSection section) {
    switch (section) {
      case AppSection.inicio:
        return 0;
      case AppSection.calendario:
        return 1;
      case AppSection.grupos:
        return 2;
      case AppSection.dimensionesPastorales:
        return 3;
      case AppSection.historia:
      case AppSection.congregacion:
      case AppSection.coordinacion:
      case AppSection.fotos:
      case AppSection.creditos:
        return 0;
    }
  }

  void _onBottomDestinationSelected(int index) {
    setState(() {
      switch (index) {
        case 0:
          _currentSection = AppSection.inicio;
          break;
        case 1:
          _currentSection = AppSection.calendario;
          break;
        case 2:
          _currentSection = AppSection.grupos;
          break;
        case 3:
          _currentSection = AppSection.dimensionesPastorales;
          break;
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildSection(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomIndexForSection(_currentSection),
        onDestinationSelected: _onBottomDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            label: 'Grupos',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'Dimensiones',
          ),
        ],
      ),
    );
  }
}
