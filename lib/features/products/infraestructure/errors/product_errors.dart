class ProductErrors implements Exception {
  String message;

  ProductErrors({required this.message});

  @override
  String toString() {
    return message;
  }
}
