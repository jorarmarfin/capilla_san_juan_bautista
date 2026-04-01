import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capilla_san_juan_bautista/app.dart';

void main() {
  testWidgets('Carga home, slider y menu principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CapillaApp());

    expect(find.text('Inicio'), findsAtLeastNWidgets(1));
    expect(find.text('Banners'), findsOneWidget);
    expect(find.text('Redes sociales'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Capilla San Juan Bautista'), findsAtLeastNWidgets(1));
    expect(find.text('Congregacion Religiosa'), findsAtLeastNWidgets(1));
    expect(find.text('Dimensiones Pastorales'), findsAtLeastNWidgets(1));
    expect(find.text('Grupos'), findsAtLeastNWidgets(1));
    expect(find.text('Calendario'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Dimensiones Pastorales').first);
    await tester.pumpAndSettle();

    expect(find.text('Liturgia'), findsOneWidget);
    expect(find.text('Koinonia'), findsOneWidget);
    expect(find.text('Martyria'), findsOneWidget);
    expect(find.text('Diakonia'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.auto_awesome_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Dimensiones Pastorales'), findsAtLeastNWidgets(1));
  });
}
