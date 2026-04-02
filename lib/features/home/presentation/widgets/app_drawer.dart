import 'package:capilla_san_juan_bautista/core/theme/app_colors.dart';
import 'package:capilla_san_juan_bautista/features/home/presentation/home_shell.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    required this.currentSection,
    required this.onSectionSelected,
    super.key,
  });

  final AppSection currentSection;
  final ValueChanged<AppSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.church, color: AppColors.primary),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Capilla San Juan Bautista',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Comunidad, fe y servicio',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _DrawerItem(
              title: AppSection.inicio.label,
              icon: Icons.home,
              isSelected: currentSection == AppSection.inicio,
              onTap: () => onSectionSelected(AppSection.inicio),
            ),
            _DrawerItem(
              title: AppSection.sacramentos.label,
              icon: Icons.church_outlined,
              isSelected: currentSection == AppSection.sacramentos,
              onTap: () => onSectionSelected(AppSection.sacramentos),
            ),
            _DrawerItem(
              title: AppSection.historia.label,
              icon: Icons.history,
              isSelected: currentSection == AppSection.historia,
              onTap: () => onSectionSelected(AppSection.historia),
            ),
            _DrawerItem(
              title: AppSection.congregacion.label,
              icon: Icons.church,
              isSelected: currentSection == AppSection.congregacion,
              onTap: () => onSectionSelected(AppSection.congregacion),
            ),
            _DrawerItem(
              title: AppSection.dimensionesPastorales.label,
              icon: Icons.auto_awesome,
              isSelected: currentSection == AppSection.dimensionesPastorales,
              onTap: () => onSectionSelected(AppSection.dimensionesPastorales),
            ),
            _DrawerItem(
              title: AppSection.grupos.label,
              icon: Icons.groups,
              isSelected: currentSection == AppSection.grupos,
              onTap: () => onSectionSelected(AppSection.grupos),
            ),
            _DrawerItem(
              title: AppSection.coordinacion.label,
              icon: Icons.manage_accounts,
              isSelected: currentSection == AppSection.coordinacion,
              onTap: () => onSectionSelected(AppSection.coordinacion),
            ),
            _DrawerItem(
              title: AppSection.calendario.label,
              icon: Icons.calendar_month,
              isSelected: currentSection == AppSection.calendario,
              onTap: () => onSectionSelected(AppSection.calendario),
            ),
            _DrawerItem(
              title: AppSection.fotos.label,
              icon: Icons.photo_library,
              isSelected: currentSection == AppSection.fotos,
              onTap: () => onSectionSelected(AppSection.fotos),
            ),
            _DrawerItem(
              title: AppSection.creditos.label,
              icon: Icons.favorite,
              isSelected: currentSection == AppSection.creditos,
              onTap: () => onSectionSelected(AppSection.creditos),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        selected: isSelected,
        selectedTileColor: colorScheme.primary.withValues(alpha: 0.12),
        leading: Icon(
          icon,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
