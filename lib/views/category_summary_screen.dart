import 'package:flutter/material.dart';
import '../viewmodels/json_table.dart';

class CategorySummaryScreen extends StatefulWidget {
  const CategorySummaryScreen({super.key});

  @override
  State<CategorySummaryScreen> createState() => _CategorySummaryScreenState();
}

class _CategorySummaryScreenState extends State<CategorySummaryScreen> {
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
        title: const Text('Resumen por Categoría'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Gastos por Categoría',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _viewModel.categoryTotals.length,
                      itemBuilder: (context, index) {
                        final category =
                            _viewModel.categoryTotals.keys.elementAt(index);
                        final total = _viewModel.categoryTotals[category]!;
                        return ListTile(
                          title: Text(category),
                          trailing: Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total de Categorías: ${_viewModel.categoryTotals.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Suma Total: \$${_viewModel.getTotalSum().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}