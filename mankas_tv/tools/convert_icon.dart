import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final inputBytes = File('assets/icon/images/icon-2.gif').readAsBytesSync();
  final image = img.decodeImage(inputBytes);
  if (image == null) {
    print('Failed to decode icon-2.gif');
    exit(1);
  }
  final png = img.encodePng(image);
  File('assets/icon/icon-2.png').writeAsBytesSync(png);
  print('Converted icon-2.gif -> icon-2.png (${image.width}x${image.height})');
}
