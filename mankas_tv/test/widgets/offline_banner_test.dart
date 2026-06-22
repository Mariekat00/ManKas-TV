import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mankas_tv/services/connectivity_service.dart';
import 'package:mankas_tv/widgets/offline_banner.dart';

void main() {
  testWidgets('renders OfflineBanner widget structure', (WidgetTester tester) async {
    final service = ConnectivityService();
    addTearDown(() => service.dispose());
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: service,
          child: const Scaffold(body: OfflineBanner()),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(OfflineBanner), findsOneWidget);
  });

  testWidgets('hides offline message when connected', (WidgetTester tester) async {
    final service = ConnectivityService();
    addTearDown(() => service.dispose());
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: service,
          child: const Scaffold(body: OfflineBanner()),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Aucune connexion Internet'), findsNothing);
  });

  testWidgets('contains wifi_off icon', (WidgetTester tester) async {
    final service = ConnectivityService();
    addTearDown(() => service.dispose());
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: service,
          child: const Scaffold(body: OfflineBanner()),
        ),
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.wifi_off), findsNothing);
  });
}
