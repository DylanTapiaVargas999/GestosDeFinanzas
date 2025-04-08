import 'package:flutter/material.dart';
import 'invoice_scanner_screen.dart';
import 'json_viewer_screen.dart';

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
                // Navega a la pantalla de análisis de facturas
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
                // Navega a la pantalla para mostrar el archivo JSON
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JsonViewerScreen(),
                  ),
                );
              },
              child: const Text('Ver Archivo JSON'),
            ),
          ],
        ),
      ),
    );
  }
}