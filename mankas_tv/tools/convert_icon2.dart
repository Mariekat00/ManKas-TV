import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final inputBytes = File('assets/icon/icon-2.png').readAsBytesSync();
  final image = img.decodeImage(inputBytes);
  if (image == null) {
    print('Failed to decode icon-2 (was wrong format)');
    exit(1);
  }
  final png = img.encodePng(image);
  File('assets/icon/icon-2.png').writeAsBytesSync(png);
  print('Converted -> PNG ${image.width}x${image.height}');
}
