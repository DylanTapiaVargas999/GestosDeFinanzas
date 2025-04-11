import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class InvoiceViewModel {
  // Lista de categorías predefinidas
  final List<String> categories = [
    'Alimentos',
    'Hogar',
    'Ropa',
    'Salud',
    'Tecnología',
    'Entretenimiento',
    'Transporte',
    'Mascotas',
    'Otros',
  ];

  Map<String, double> categoryTotals = {};
  List<Map<String, dynamic>> allPurchases = [];

  InvoiceViewModel() {
    _initializeCategoryTotals();
  }

  // Inicializa el mapa con todas las categorías en 0
  void _initializeCategoryTotals() {
    categoryTotals = {
      for (var category in categories) category: 0.0,
    };
  }

  // Carga y procesa los datos del archivo JSON
  Future<void> loadAndProcessData() async {
    try {
      // Obtén el archivo JSON
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/response.json';
      final file = File(filePath);

      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> data = jsonDecode(content);

        // Procesa los datos para calcular los totales por categoría
        for (var entry in data) {
          if (entry['compras'] != null) {
            for (var compra in entry['compras']) {
              final categoria = compra['categoria'] as String;
              final precio = (compra['precio'] as num).toDouble();
              final usuario = compra['usuario'] as String; // Nuevo campo
              final fecha = compra['fecha'] as String; // Nuevo campo

              // Actualiza los totales por categoría
              if (categoryTotals.containsKey(categoria)) {
                categoryTotals[categoria] = categoryTotals[categoria]! + precio;
              }

              // Agrega la compra a la lista de todas las compras
              allPurchases.add({
                'categoria': categoria,
                'producto': compra['producto'],
                'precio': precio,
                'usuario': usuario, // Agregamos el usuario
                'fecha': fecha, // Agregamos la fecha
              });
            }
          }
        }

        // Ordenar las compras por fecha (más reciente primero)
        allPurchases.sort((a, b) {
          final fechaA = DateTime.parse(a['fecha']);
          final fechaB = DateTime.parse(b['fecha']);
          return fechaB.compareTo(fechaA); // Orden descendente
        });
      }
    } catch (e) {
      print('Error al procesar los datos: $e');
    }
  }

  // Devuelve la suma total de todas las categorías
  double getTotalSum() {
    return categoryTotals.values.fold(0.0, (sum, value) => sum + value);
  }
}