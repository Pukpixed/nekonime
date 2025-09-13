import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nekonime',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const FirstScreen(), // 👈 ใช้ได้แล้ว
    );
  }
}
