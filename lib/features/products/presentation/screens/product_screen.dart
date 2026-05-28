import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/form/product_form_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  /* msg */
  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Producto actualizado correctamente"),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("productId: $productId");
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
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (productState.product == null) return;
            ref
                .read(productFormProvider(productState.product!).notifier)
                .onFormSubmitted()
                .then((value) {
              if (!value) return;
              showSnackbar(context);
            });
          },
          child: const Icon(Icons.save)),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 500,
          child: _ImageGallery(imgs: productForm.images),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            productForm.title.value,
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
    final productForm = ref.watch(productFormProvider(product));

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
            initialValue: productForm.title.value,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onTitleChanged(value),
            errorMessage: productForm.title.errorMessage,
          ),
          const SizedBox(height: 10),
          CustomProductField(
            label: "Descripción",
            initialValue: productForm.description.value,
            maxLines: 5,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onDescriptionChanged(value),
            errorMessage: productForm.description.errorMessage,
          ),
          const SizedBox(height: 10),
          CustomProductField(
            label: "Slug",
            initialValue: productForm.slug.value,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onSlugChanged(value),
            errorMessage: productForm.slug.errorMessage,
          ),
          const SizedBox(height: 10),
          CustomProductField(
            label: "Precio",
            initialValue: productForm.price.value.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onPriceChanged(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text("Extras",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Tamaños"),
          const SizedBox(height: 10),
          _SizesSelector(
              selectedSizes: productForm.sizes,
              onSizesChanged: (sizes) => ref
                  .read(productFormProvider(product).notifier)
                  .onSizeChanged(sizes)),
          const SizedBox(height: 10),
          const Text("Género"),
          const SizedBox(height: 10),
          _GenderSelector(
              gender: product.gender,
              onGenderChanged: (gender) => ref
                  .read(productFormProvider(product).notifier)
                  .onGenderChanged(gender)),

          const SizedBox(height: 15),
          const Text("Existencias",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          //existencias
          CustomProductField(
            label: "Stock",
            initialValue: productForm.stock.value.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onStockChanged(int.tryParse(value) ?? -1),
            errorMessage: productForm.stock.errorMessage,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _SizesSelector extends StatefulWidget {
  final List<String> selectedSizes;

  final Function(List<String> selectedSizes) onSizesChanged;

  const _SizesSelector(
      {required this.selectedSizes, required this.onSizesChanged});

  @override
  State<_SizesSelector> createState() => _SizesSelectorState();
}

class _SizesSelectorState extends State<_SizesSelector> {
  late Set<String> _selected;
  static List<String> sizes = ["XS", "S", "M", "L", "XL", "XXL"];

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedSizes);
  }

  @override
  void didUpdateWidget(_SizesSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSizes != widget.selectedSizes) {
      _selected = Set.from(widget.selectedSizes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      multiSelectionEnabled: true,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 12)));
      }).toList(),
      selected: _selected,
      onSelectionChanged: (newSelection) {
        setState(() {
          _selected = newSelection;
        });
        widget.onSizesChanged(_selected.toList());
        print("talla" + _selected.toString());
      },
    );
  }
}

class _GenderSelector extends StatefulWidget {
  final String gender;

  final Function(String gender) onGenderChanged;

  const _GenderSelector({required this.gender, required this.onGenderChanged});

  @override
  State<_GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<_GenderSelector> {
  static const List<String> genders = ['men', 'women', 'kid', 'unisex'];

  late String _gender;

  @override
  void initState() {
    super.initState();
    final normalizeGender = widget.gender.toLowerCase();
    _gender =
        genders.contains(normalizeGender) ? normalizeGender : genders.first;
  }

  @override
  void didUpdateWidget(_GenderSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gender != widget.gender) {
      final normalizeGender = widget.gender.toLowerCase();
      _gender =
          genders.contains(normalizeGender) ? normalizeGender : genders.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      multiSelectionEnabled: false,
      segments: genders.map((gender) {
        return ButtonSegment(
            value: gender,
            label: Text(gender, style: const TextStyle(fontSize: 12)));
      }).toList(),
      selected: {_gender},
      onSelectionChanged: (newSelection) {
        if (newSelection.isEmpty) return;
        setState(() {
          _gender = newSelection.first;
        });
        widget.onGenderChanged(_gender);
        print("gender: $_gender");
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
                  "assets/images/no-image.jpg",
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
