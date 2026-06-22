import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  const size = 512;
  final image = img.Image(width: size, height: size);

  // White background
  img.fill(image, color: img.ColorRgb8(255, 255, 255));

  // Draw gradient circle (blue to indigo)
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final dx = x - size ~/ 2;
      final dy = y - size ~/ 2;
      final dist = (dx * dx + dy * dy);
      if (dist < 200 * 200) {
        final ratio = (dx + size ~/ 2) / size;
        final r = (0x63 + (0x8B - 0x63) * ratio).round();
        final g = (0x66 + (0x5C - 0x66) * ratio).round();
        final b = (0xF1 + (0xF6 - 0xF1) * ratio).round();
        image.setPixel(x, y, img.ColorRgb8(r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255)));
      }
    }
  }

  // TV icon (simplified white shape)
  final cx = size ~/ 2;
  final cy = size ~/ 2;
  final tvW = 180;
  final tvH = 130;

  // TV body
  for (int y = cy - tvH ~/ 2; y < cy + tvH ~/ 2; y++) {
    for (int x = cx - tvW ~/ 2; x < cx + tvW ~/ 2; x++) {
      final inBorder = x < cx - tvW ~/ 2 + 4 || x >= cx + tvW ~/ 2 - 4 ||
          y < cy - tvH ~/ 2 + 4 || y >= cy + tvH ~/ 2 - 4;
      if (inBorder && x >= 0 && x < size && y >= 0 && y < size) {
        image.setPixel(x, y, img.ColorRgb8(255, 255, 255));
      }
    }
  }

  // Antenna
  for (int i = 0; i < 40; i++) {
    final px = cx + i;
    final py = cy - tvH ~/ 2 - 40 + i;
    if (px >= 0 && px < size && py >= 0 && py < size) {
      image.setPixel(px, py, img.ColorRgb8(255, 255, 255));
      image.setPixel(cx - (i), cy - tvH ~/ 2 - 40 + i, img.ColorRgb8(255, 255, 255));
    }
  }

  // Stand
  for (int i = 0; i < 30; i++) {
    for (int j = 0; j < 6; j++) {
      final px = cx - i ~/ 2 + j;
      final py = cy + tvH ~/ 2 + i;
      if (px >= 0 && px < size && py >= 0 && py < size) {
        image.setPixel(px, py, img.ColorRgb8(255, 255, 255));
      }
    }
  }

  final png = img.encodePng(image);
  File('assets/icon/icon-2.png').writeAsBytesSync(png);
  print('Generated icon-2.png (${image.width}x${image.height})');
}
