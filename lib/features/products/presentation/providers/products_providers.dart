import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: productsRepository);
});

//state notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository,
  }) : super(ProductsState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    try {
      final products = await productsRepository.getProductByPage(
        limit: state.limit,
        offset: state.offset,
      );

      if (products.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          isLastPage: true,
        );
        return;
      }

      final bool reachedEnd = products.length < state.limit;

      state = state.copyWith(
        isLoading: false,
        isLastPage: reachedEnd,
        offset: state.offset + products.length,
        products: [...state.products, ...products],
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) =>
      ProductsState(
          isLastPage: isLastPage ?? this.isLastPage,
          limit: limit ?? this.limit,
          offset: offset ?? this.offset,
          isLoading: isLoading ?? this.isLoading,
          products: products ?? this.products);
}
