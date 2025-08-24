import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set App Group ID for iOS widget communication
  await HomeWidget.setAppGroupId('group.com.example.interactiveMapDemo');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Map Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
