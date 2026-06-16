import 'package:flutter_test/flutter_test.dart';
import 'package:mankas_tv/main.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const ManKasTvApp());
    expect(find.text('ManKas TV'), findsOneWidget);
  });
}
