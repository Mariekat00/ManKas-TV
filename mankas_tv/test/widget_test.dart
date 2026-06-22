import 'package:flutter_test/flutter_test.dart';
import 'package:mankas_tv/models/channel.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final channel = Channel(
      id: 'test',
      name: 'Test Channel',
      streamUrl: 'https://example.com/stream.m3u8',
    );
    expect(channel.name, 'Test Channel');
    expect(channel.category, null);
  });
}
