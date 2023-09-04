import 'package:shopping_app/helper/quantity_helper.dart';
import 'package:shopping_app/model/product.dart';

class Ingredient {
  static String getIrifromId(int id) {
    return '/api/ingredients/$id';
  }

  int id;
  Product? product;
  double quantity;
  String? customName;
  double? customPrice;
  String? customQuantityType;
  String? recipeURI;

  get iri => Ingredient.getIrifromId(id);

  Ingredient({
    required this.id,
    this.product,
    required this.quantity,
    required this.recipeURI,
    this.customName,
    this.customPrice,
    this.customQuantityType,
  });

  get name {
    if (product == null && customName != null) {
      return customName;
    } else if (product != null) {
      return product!.name;
    } else {
      return '';
    }
  }

  get price {
    if (product == null && customPrice != null) {
      return customPrice;
    } else if (product != null) {
      return product!.price / product!.quantity * quantity;
    } else {
      return '';
    }
  }

  get quantityVariation {
    if (product == null && customQuantityType != null) {
      return QuantityHelper.getQuantityVariation(customQuantityType!, quantity);
    } else if (product != null) {
      return QuantityHelper.getQuantityVariation(
          product!.quantityType, product!.quantity);
    } else {
      return '';
    }
  }

  get quantityValue {
    if (product == null && customQuantityType != null) {
      return QuantityHelper.getQuantityValue(customQuantityType!, quantity);
    } else if (product != null) {
      return QuantityHelper.getQuantityValue(product!.quantityType, quantity);
    } else {
      return '';
    }
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    double? customPrice =
        json['customPrice'] == null ? null : double.parse(json['customPrice']);
    return Ingredient(
      id: json['id'],
      product:
          json['product'] == null ? null : Product.fromJson(json['product']),
      quantity: double.parse(json['quantity']),
      recipeURI: json['recipe'],
      customName: json['customName'],
      customPrice: customPrice,
      customQuantityType: json['customQuantityType'],
    );
  }
}
