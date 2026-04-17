import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //img
        _ImgProduct(imgUrls: product.images),
        Text(product.title, textAlign: TextAlign.center,),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _ImgProduct extends StatelessWidget {
  final List<String> imgUrls;

  const _ImgProduct({required this.imgUrls});

  @override
  Widget build(BuildContext context) {
    if (imgUrls.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "assets/images/no-image.png",
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FadeInImage(
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
        placeholder: const AssetImage("assets/loaders/bottle-loader.gif"),
        image: NetworkImage(imgUrls.first),
        fadeInDuration: const Duration(milliseconds: 75),
        fadeOutCurve: Curves.easeInOut
      ),
    );
  }
}
