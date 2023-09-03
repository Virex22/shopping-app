import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/helper/product_helper.dart';
import 'package:shopping_app/helper/quantity_helper.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/shop.dart';
import 'package:shopping_app/provider/product_provider.dart';

class IngredientProductSelection extends StatefulWidget {
  final Function({Product? product, double? quantity}) onFormChange;

  const IngredientProductSelection({super.key, required this.onFormChange});

  @override
  IngredientProductSelectionState createState() =>
      IngredientProductSelectionState();
}

class IngredientProductSelectionState
    extends State<IngredientProductSelection> {
  Shop? selectedShop;
  Product? selectedProduct;
  String? search;

  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().refreshShopListFromApi();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    late Widget page;

    if (productProvider.shops != null && selectedShop == null) {
      page = ListView.builder(
        itemCount: productProvider.shops!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Shop shop = productProvider.shops![index];
          return ListTile(
            title: Text(shop.name),
            subtitle: Text('${shop.productsCount} produits'),
            onTap: () {
              setState(() {
                selectedShop = shop;
              });
            },
          );
        },
      );
    } else if (selectedShop != null &&
        selectedShop!.product != null &&
        selectedShop!.product!.isNotEmpty) {
      List<Product> products = selectedShop!.product!;
      if (search != null && search!.isNotEmpty) {
        products = products
            .where((element) =>
                element.name.toLowerCase().contains(search!.toLowerCase()))
            .toList();
      }
      page = ListView.builder(
        itemCount: products.length + 2,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return TextField(
              onChanged: (text) {
                setState(() {
                  search = text;
                });
              },
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                border: InputBorder.none,
              ),
            );
          } else if (index == products.length + 1) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                title: const Center(child: Text('Retour')),
                onTap: () {
                  setState(() {
                    selectedShop = null;
                  });
                },
              ),
            );
          }
          Product product = products[index - 1];
          return Container(
            decoration: BoxDecoration(
              color:
                  selectedProduct != null && selectedProduct!.id == product.id
                      ? Theme.of(context).primaryColor
                      : null,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              title: Text(ProductHelper.getTitle(product)),
              subtitle: Text('${product.price} €'),
              onTap: () {
                setState(() {
                  selectedProduct = product;
                });
                widget.onFormChange(product: product);
              },
            ),
          );
        },
      );
    } else if (selectedShop != null &&
        selectedShop!.product != null &&
        selectedShop!.product!.isEmpty) {
      page = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Aucun produit'),
            ElevatedButton(
              child: const Text('Retour'),
              onPressed: () {
                setState(() {
                  selectedShop = null;
                });
              },
            ),
          ],
        ),
      );
    } else {
      page = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (selectedShop != null && selectedShop!.product == null) {
      productProvider.updateShopProductsFromApi(selectedShop!.id);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: page,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
              'Produit sélectionné :${selectedProduct != null ? selectedProduct!.name : 'Aucun'}'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (text) {
                    widget.onFormChange(quantity: double.parse(text));
                  },
                  decoration: const InputDecoration(
                    labelText: 'Quantité de l\'ingrédient',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Text(
                selectedProduct != null
                    ? QuantityHelper.getQuantityVariation(selectedProduct!)
                    : '',
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
