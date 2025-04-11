import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const InvoiceAnalyzerApp());
}

class InvoiceAnalyzerApp extends StatelessWidget {
  const InvoiceAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factura Analyzer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light, // Cambiado a modo claro
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Cambia la pantalla inicial a HomeScreen
    );
  }
}