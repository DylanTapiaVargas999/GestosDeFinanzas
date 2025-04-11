import 'package:flutter/material.dart';

class FilteredPurchasesScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> filteredPurchases;

  const FilteredPurchasesScreen({
    super.key,
    required this.category,
    required this.filteredPurchases,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compras de $category'),
      ),
      body: filteredPurchases.isEmpty
          ? const Center(
              child: Text(
                'No hay compras en esta categoría.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: filteredPurchases.length,
              itemBuilder: (context, index) {
                final purchase = filteredPurchases[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text('${purchase['producto']}'),
                    subtitle: Text(
                      'Precio: \$${purchase['precio'].toStringAsFixed(2)}\nCategoría: ${purchase['categoria']}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}