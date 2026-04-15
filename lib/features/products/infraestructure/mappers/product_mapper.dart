import 'package:teslo_shop/config/const/enviroment.dart';
import 'package:teslo_shop/features/auth/infraestructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductMapper {
  static jsontoEntity(Map<String, dynamic> json) {
    final dynamic rawPrice = json['price'];
    final int price = rawPrice is num
        ? rawPrice.toInt()
        : int.tryParse(rawPrice?.toString() ?? '') ?? 0;

    final dynamic rawSizes = json['sizes'];
    final List<String> sizes = rawSizes is List
        ? rawSizes.map((dynamic size) => size.toString()).toList()
        : const <String>[];

    final dynamic rawTags = json['tags'];
    final List<String> tags = rawTags is List
        ? rawTags.map((dynamic tag) => tag.toString()).toList()
        : const <String>[];

    final dynamic rawImages = json['images'];
    final List<String> images = rawImages is List
        ? rawImages
            .map((dynamic image) => image.toString())
            .map((String image) => image.startsWith('http')
                ? image
                : '${Enviroment.apiUrl}/files/product/$image')
            .toList()
        : const <String>[];

    final dynamic rawUser = json['user'];
    final Map<String, dynamic> userJson =
        rawUser is Map<String, dynamic> ? rawUser : <String, dynamic>{};

    return Product(
      id: json['id'],
      title: json['title'],
      price: price,
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'] ?? 0,
      sizes: sizes,
      gender: json['gender'],
      tags: tags,
      images: images,
      user: UserMapper.userJsonToEntity(userJson),
    );
  }
}
