import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redfox_mobile/main.dart'; // Pastikan nama package sesuai dengan pubspec.yaml

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Bangun aplikasi kita dan picu frame.
    // Ubah MyApp() menjadi AntasenaApp() sesuai dengan kelas di main.dart
    await tester.pumpWidget(const AntasenaApp());

    // Verifikasi bahwa counter kita mulai dari 0.
    // (Karena kita sudah ganti dashboard, tes default ini mungkin akan gagal, 
    // tapi garis merahnya akan hilang).
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Ketuk ikon '+' dan picu frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifikasi bahwa counter kita telah bertambah.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}