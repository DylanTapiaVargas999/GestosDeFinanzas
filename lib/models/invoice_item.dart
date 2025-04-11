class InvoiceItem {
  final String category;
  final String product;
  final double price;
  final String user; // Nuevo campo para el usuario
  final String date; // Nuevo campo para la fecha

  InvoiceItem({
    required this.category,
    required this.product,
    required this.price,
    required this.user, // Inicializamos el usuario
    required this.date, // Inicializamos la fecha
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      category: json['categoria'],
      product: json['producto'],
      price: json['precio'].toDouble(),
      user: json['usuario'], // Mapeamos el usuario desde el JSON
      date: json['fecha'], // Mapeamos la fecha desde el JSON
    );
  }
}