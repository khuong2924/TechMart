import 'package:flutter/material.dart';
import 'package:tech_mart/views/Starter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Mart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const StarterPage(),
        '/home': (context) => const Placeholder(), // Replace with your HomePage when available
      },
      initialRoute: '/',
    );
  }
}