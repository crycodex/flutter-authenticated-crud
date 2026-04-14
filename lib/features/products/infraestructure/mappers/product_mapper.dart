import 'package:teslo_shop/config/const/enviroment.dart';
import 'package:teslo_shop/features/auth/infraestructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductMapper {
  static jsontoEntity(Map<String, dynamic> json) => Product(
      id: json['id'],
      title: json['title'],
      price: double.parse(json['price']).toInt(),
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'] ?? 0,
      sizes: List<String>.from(json['sizes'].map((size) => size.toString())),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((tag) => tag.toString())),
      images: List<String>.from(json['images'].map(((String image) =>
          image.startsWith("http")
              ? image
              : "${Enviroment.apiUrl}/files/product/$image"))),
      user: UserMapper.userJsonToEntity(json['user']));
}
