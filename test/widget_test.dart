import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capilla_san_juan_bautista/app.dart';

void main() {
  testWidgets('Carga home, slider y menu principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CapillaApp());

    expect(find.text('Inicio'), findsAtLeastNWidgets(1));
    expect(find.text('Anuncios'), findsOneWidget);
    expect(find.text('Redes sociales'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Capilla San Juan Bautista'), findsAtLeastNWidgets(1));
    expect(find.text('Congregación Religiosa'), findsAtLeastNWidgets(1));
    expect(find.text('Dimensiones Pastorales'), findsAtLeastNWidgets(1));
    expect(find.text('Grupos'), findsAtLeastNWidgets(1));
    expect(find.text('Calendario'), findsAtLeastNWidgets(1));

    // Scroll con delta pequeño para que el item quede dentro del viewport
    final drawerScrollable = find.descendant(
      of: find.byType(Drawer),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Créditos'),
      40,
      scrollable: drawerScrollable,
    );
    await tester.pumpAndSettle();
    expect(find.text('Créditos'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Créditos').first);
    await tester.pumpAndSettle();

    expect(find.text('Desarrollador'), findsOneWidget);
    expect(find.text('Ing. Software'), findsOneWidget);
    expect(find.text('Luis Fernando Mayta Campos'), findsOneWidget);
    expect(find.text('luisitomayta.com'), findsOneWidget);
    expect(find.text('Tecnologia'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Dart'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dimensiones Pastorales').first);
    await tester.pumpAndSettle();

    expect(find.text('Liturgia'), findsOneWidget);
    expect(find.text('Koinonia'), findsOneWidget);
    expect(find.text('Martyria'), findsOneWidget);
    expect(find.text('Diakonia'), findsOneWidget);

    // Con selectedIcon, Inicio muestra Icons.home (relleno) cuando está seleccionado
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.auto_awesome_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Dimensiones Pastorales'), findsAtLeastNWidgets(1));
  });
}
