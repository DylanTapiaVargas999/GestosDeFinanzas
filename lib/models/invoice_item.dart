class InvoiceItem {
  final String category;
  final String product;
  final double price;

  InvoiceItem({
    required this.category,
    required this.product,
    required this.price,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      category: json['categoria'],
      product: json['producto'],
      price: json['precio'].toDouble(),
    );
  }
}