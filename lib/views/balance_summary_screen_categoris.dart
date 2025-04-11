import 'package:flutter/material.dart';
import 'package:gemini_3/viewmodels/json_table.dart';
import '../viewmodels/user_balance_viewmodel.dart';
import '../viewmodels/category_filter_viewmodel.dart';
import 'filtered_purchases_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final InvoiceViewModel _invoiceViewModel = InvoiceViewModel();
  final UserBalanceViewModel _balanceViewModel = UserBalanceViewModel();
  bool isLoading = true;
  String? errorMessage;
  double totalSpent = 0.0;
  double availableBalance = 0.0;
  List<Map<String, dynamic>> allPurchases = [];

  final List<String> categories = [
    'Alimentos',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Hogar',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Cargar datos de las facturas
      await _invoiceViewModel.loadAndProcessData();
      totalSpent = _invoiceViewModel.getTotalSum();
      allPurchases = _invoiceViewModel.allPurchases;

      // Cargar el balance del usuario
      await _balanceViewModel.loadBalance();
      availableBalance = _balanceViewModel.getBalance();
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar los datos: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToFilteredPurchases(String category) {
    final filterViewModel = CategoryFilterViewModel(allPurchases);
    final filteredPurchases = filterViewModel.filterByCategory(category);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredPurchasesScreen(
          category: category,
          filteredPurchases: filteredPurchases,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mostrar el balance y los gastos
                      Text(
                        'Saldo Total: \$${availableBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gasto Total: \$${totalSpent.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Dinero Restante: \$${(availableBalance - totalSpent).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: (availableBalance - totalSpent) >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Mostrar los botones de categorías
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Número de columnas
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1.0, // Hace que los botones sean cuadrados
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              onPressed: () {
                                _navigateToFilteredPurchases(categories[index]);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                backgroundColor: Colors.green, // Color verde para los botones
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Sin bordes redondeados
                                ),
                              ),
                              child: Text(
                                categories[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}