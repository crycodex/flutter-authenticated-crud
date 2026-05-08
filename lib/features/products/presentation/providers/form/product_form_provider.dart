import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/const/enviroment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  //create upadtecallback
  return ProductFormNotifier(
    product: product,
    //onssubmit callback
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final bool Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }) : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price.toDouble()),
          stock: Stock.dirty(product.stock),
          sizes: product.sizes,
          gender: product.gender,
          tags: product.tags.join(", "),
          images: product.images,
        ));

  Future<bool> onFormSubmitted() async {
    _touchEveryField();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      "id": state.id,
      "title": state.title.value,
      "slug": state.slug.value,
      "price": state.price.value,
      "stock": state.stock.value,
      "sizes": state.sizes,
      "gender": state.gender,
      "tags": state.tags.split(","),
      "images": state.images
          .map((image) =>
              image.replaceAll("${Enviroment.apiUrl}/files/product/", ""))
          .toList(),
      "description": state.description,
    };

    //onSubmitCallback(productLike);
    try {
      return onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchEveryField() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.stock.value),
    ]));
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.stock.value),
        ]));
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.stock.value),
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.stock.value),
        ]));
  }

  void onStockChanged(int value) {
    state = state.copyWith(
        stock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ]));
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }

  void onImagesChanged(List<String> images) {
    state = state.copyWith(images: images);
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final Stock stock;
  final List<String> sizes;
  final String gender;
  final String tags;
  final List<String> images;
  final String description;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(""),
    this.slug = const Slug.dirty(""),
    this.price = const Price.dirty(0),
    this.stock = const Stock.dirty(0),
    this.sizes = const [],
    this.gender = "men",
    this.tags = "",
    this.images = const [],
    this.description = "",
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    Stock? stock,
    List<String>? sizes,
    String? gender,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        stock: stock ?? this.stock,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
