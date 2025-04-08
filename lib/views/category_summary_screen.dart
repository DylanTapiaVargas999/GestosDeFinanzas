import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CategorySummaryScreen extends StatefulWidget {
  const CategorySummaryScreen({super.key});

  @override
  State<CategorySummaryScreen> createState() => _CategorySummaryScreenState();
}

class _CategorySummaryScreenState extends State<CategorySummaryScreen> {
  Map<String, double> categoryTotals = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndProcessData();
  }

  Future<void> _loadAndProcessData() async {
    try {
      // Obtén el archivo JSON
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/response.json';
      final file = File(filePath);

      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> data = jsonDecode(content);

        // Procesa los datos para calcular los totales por categoría
        final Map<String, double> totals = {};
        for (var entry in data) {
          if (entry['compras'] != null) {
            for (var compra in entry['compras']) {
              final categoria = compra['categoria'] as String;
              final precio = (compra['precio'] as num).toDouble();

              if (totals.containsKey(categoria)) {
                totals[categoria] = totals[categoria]! + precio;
              } else {
                totals[categoria] = precio;
              }
            }
          }
        }

        setState(() {
          categoryTotals = totals;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al procesar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen por Categoría'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryTotals.isEmpty
              ? const Center(
                  child: Text(
                    'No hay datos disponibles.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
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
                          itemCount: categoryTotals.length,
                          itemBuilder: (context, index) {
                            final category = categoryTotals.keys.elementAt(index);
                            final total = categoryTotals[category]!;
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
                        'Total de Categorías: ${categoryTotals.length}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Suma Total: \$${categoryTotals.values.fold(0.0, (sum, value) => sum + value).toStringAsFixed(2)}',
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