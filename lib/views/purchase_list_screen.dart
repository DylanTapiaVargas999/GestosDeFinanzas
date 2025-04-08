import 'package:flutter/material.dart';
import '../viewmodels/json_table.dart';

class PurchaseListScreen extends StatefulWidget {
  const PurchaseListScreen({super.key});

  @override
  State<PurchaseListScreen> createState() => _PurchaseListScreenState();
}

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  final InvoiceViewModel _viewModel = InvoiceViewModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadAndProcessData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _viewModel.allPurchases.isEmpty
              ? const Center(
                  child: Text(
                    'No hay compras registradas.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _viewModel.allPurchases.length,
                  itemBuilder: (context, index) {
                    final purchase = _viewModel.allPurchases[index];
                    return ListTile(
                      title: Text(purchase['producto']),
                      subtitle: Text('Categoría: ${purchase['categoria']}'),
                      trailing: Text(
                        '\$${(purchase['precio'] as num).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}