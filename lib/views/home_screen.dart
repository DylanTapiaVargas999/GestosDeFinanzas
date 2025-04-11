import 'package:flutter/material.dart';
import 'package:gemini_3/views/balance_summary_screen.dart';
import 'balance_summary_screen_categoris.dart'; // Importa la nueva pantalla de categorías
import 'invoice_scanner_screen.dart';
import 'json_viewer_screen.dart';
import 'category_summary_screen.dart';
import 'purchase_list_screen.dart';
import 'text_invoice_screen.dart';
import 'user_balance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de pantallas para la navegación
  final List<Widget> _screens = [
    const InvoiceScannerScreen(
      apiKey: "AIzaSyAPwGfQo9eI2KubbXhabdH8ESDRR4s5Llo",
    ),
    const JsonViewerScreen(),
    const CategorySummaryScreen(),
    const PurchaseListScreen(),
    const TextInvoiceScreen(),
    const UserBalanceScreen(),
    const BalanceSummaryScreen(),
    const CategoriesScreen(), // Nueva pantalla de categorías
  ];

  // Lista de títulos para cada pantalla
  final List<String> _titles = [
    'Escáner de Facturas',
    'Archivo JSON',
    'Resumen por Categoría',
    'Lista de Compras',
    'Factura por Texto',
    'Configurar Balance',
    'Resumen de Balance',
    'Categorías', // Título para la nueva pantalla
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Escáner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: 'JSON',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Resumen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Compras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Texto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Balance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Resumen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
        ],
      ),
    );
  }
}