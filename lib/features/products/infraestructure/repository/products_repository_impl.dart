import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource productsDatasource;

  ProductsRepositoryImpl({required this.productsDatasource});

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) async {
    return productsDatasource.createProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return productsDatasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductByPage({int limit = 10, int offset = 0}) {
    return productsDatasource.getProductByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    return productsDatasource.searchProductsByTerm(term);
  }
}
