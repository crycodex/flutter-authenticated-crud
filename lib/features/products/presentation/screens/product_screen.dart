import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar producto"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt))
        ],
      ),
      body: productState.isLoading
          ? const FullScreenLoader()
          : _ProductView(product: productState.product!),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.save)),
    );
  }
}

class _ProductView extends StatelessWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 500,
          child: _ImageGallery(imgs: product.images),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            product.title,
            style: textStyles.titleLarge,
          ),
        ),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;

  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Información del producto"),
          const SizedBox(height: 10),
          CustomProductField(
            isTopField: true,
            label: "Nombre",
            initialValue: product.title,
          ),
          const SizedBox(height: 10),
          CustomProductField(
            label: "Descripción",
            initialValue: product.description,
          ),
          const SizedBox(height: 10),
          CustomProductField(
            label: "Slug",
            initialValue: product.slug,
          ),
          const SizedBox(height: 10),
          CustomProductField(
            label: "Precio",
            initialValue: product.price.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 15),
          const Text("Extras"),
          _SizesSelector(selectedSizes: product.sizes),
          const SizedBox(height: 10),
          _GenderSelector(gender: product.gender),

          const SizedBox(height: 15),
          const Text("Existencias"),
          //existencias
          CustomProductField(
            label: "Stock",
            initialValue: product.stock.toString(),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          const CustomProductField(
            label: "Tamaños",
          ),
        ],
      ),
    );
  }
}

class _SizesSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  const _SizesSelector({required this.selectedSizes});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 12)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        print(newSelection);
      },
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String gender;
  final List<String> genders = const ['men', 'women', 'kid', 'unisex'];

  const _GenderSelector({required this.gender});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: genders.map((gender) {
        return ButtonSegment(
            value: gender,
            label: Text(gender, style: const TextStyle(fontSize: 12)));
      }).toList(),
      selected: {gender.toLowerCase()},
      onSelectionChanged: (newSelection) {
        print(newSelection);
      },
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> imgs;
  const _ImageGallery({required this.imgs});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      controller: PageController(viewportFraction: 0.8),
      children: imgs.isEmpty
          ? [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  "assets/images/no-image.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              )
            ]
          : imgs.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  e,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              );
            }).toList(),
    );
  }
}
