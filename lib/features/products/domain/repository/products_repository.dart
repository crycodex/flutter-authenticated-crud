import '../entities/product.dart';

abstract class ProductsRepository {  

  Future<List<Product>> getProductByPage({int limit = 10, int offset = 0});

  Future<Product> getProductById(String id);

  Future<List<Product>> searchProductsByTerm(String term);

  Future<Product> createProduct(Product product);

}