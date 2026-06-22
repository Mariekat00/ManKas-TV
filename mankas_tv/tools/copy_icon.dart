import 'dart:io';

void main() {
  final input = File('assets/icon/images/icon-2.gif');
  final output = File('assets/icon/icon-2.png');
  output.writeAsBytesSync(input.readAsBytesSync());
  print('Copied icon-2.gif -> icon-2.png');
}
