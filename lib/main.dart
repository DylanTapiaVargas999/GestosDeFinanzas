import 'package:flutter/material.dart';
import 'views/invoice_scanner_screen.dart';

const String _apiKey = "AIzaSyAPwGfQo9eI2KubbXhabdH8ESDRR4s5Llo";

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
          brightness: Brightness.dark,
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: InvoiceScannerScreen(apiKey: _apiKey),
    );
  }
}