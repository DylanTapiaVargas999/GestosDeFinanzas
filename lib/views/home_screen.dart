import 'package:flutter/material.dart';
import 'invoice_scanner_screen.dart';
import 'json_viewer_screen.dart';
import 'category_summary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestos de Finanzas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvoiceScannerScreen(
                      apiKey: "AIzaSyAPwGfQo9eI2KubbXhabdH8ESDRR4s5Llo",
                    ),
                  ),
                );
              },
              child: const Text('Ir a Escáner de Facturas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JsonViewerScreen(),
                  ),
                );
              },
              child: const Text('Ver Archivo JSON'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategorySummaryScreen(),
                  ),
                );
              },
              child: const Text('Ver Resumen por Categoría'),
            ),
          ],
        ),
      ),
    );
  }
}