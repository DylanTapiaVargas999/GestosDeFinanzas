class CategoryFilterViewModel {
  final List<Map<String, dynamic>> allPurchases;

  CategoryFilterViewModel(this.allPurchases);

  // Filtrar compras por categoría
  List<Map<String, dynamic>> filterByCategory(String category) {
    return allPurchases
        .where((purchase) => purchase['categoria'] == category)
        .toList();
  }
}