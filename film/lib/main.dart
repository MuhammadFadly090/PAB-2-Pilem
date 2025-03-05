import 'package:flutter/material.dart';
import 'package:film/screens/home_screen.dart'; // Import file home_screen.dart

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilem App', 
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(), 
      debugShowCheckedModeBanner: false, 
    );
  }
}