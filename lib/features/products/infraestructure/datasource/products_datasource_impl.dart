import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/datasource/products_datasource.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/infraestructure/errors/product_errors.dart';
import 'package:teslo_shop/features/products/infraestructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Enviroment.apiUrl,
            headers: {"Authorization": "Bearer $accessToken"}));

  @override
  Future<Product> createProduct(Product product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsontoEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductErrors(message: 'Producto no encontrado');
      }
      throw ProductErrors(message: 'Error al obtener el producto');
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductByPage(
      {int limit = 10, int offset = 0}) async {
    try {
      final response = await dio.get<dynamic>(
        '/products',
        queryParameters: <String, dynamic>{
          'limit': limit,
          'offset': offset,
        },
      );

      final data = response.data;
      if (data is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Respuesta inesperada al listar productos',
        );
      }

      return data
          .map<Product>((dynamic json) =>
              ProductMapper.jsontoEntity(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }
}
