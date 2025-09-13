import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nekonime/main.dart'; // ตรวจสอบว่าชื่อโปรเจ็กต์ใน pubspec.yaml คือ nekonime จริง ๆ

void main() {
  testWidgets('Nekonime app shows AppBar and logo', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const MyApp());

    // ตรวจสอบว่า AppBar มีข้อความ Nekonime
    expect(find.text('Nekonime'), findsOneWidget);

    // ตรวจสอบว่าโลโก้ถูกโหลด
    expect(find.byType(Image), findsOneWidget);
  });
}
