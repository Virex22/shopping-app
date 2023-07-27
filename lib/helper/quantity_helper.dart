import 'package:shopping_app/model/product.dart';

class QuantityHelper {
  static String getQuantity(Product product) {
    if (product.quantityType == 'unit') {
      return '${product.quantity.toInt()}';
    } else if (product.quantityType == 'liquid') {
      return _getLiquidQuantity(product);
    } else if (product.quantityType == 'weight') {
      return _getWeightQuantity(product);
    }
    return '${product.quantity.toInt()}';
  }

  static int getQuantityValue(Product product) {
    if (product.quantityType == 'unit') {
      return product.quantity.toInt();
    } else if (product.quantityType == 'liquid') {
      if (product.quantity < 1) {
        return (product.quantity * 1000).toInt();
      } else {
        return product.quantity.toInt();
      }
    } else if (product.quantityType == 'weight') {
      if (product.quantity < 1) {
        return (product.quantity * 1000).toInt();
      } else if (product.quantity < 1000) {
        return product.quantity.toInt();
      } else {
        return (product.quantity ~/ 1000).toInt();
      }
    }
    return product.quantity.toInt();
  }

  static String removeDecimalZeroFormat(double num) {
    String formattedNum = num.toStringAsFixed(3);

    while (formattedNum.endsWith('0')) {
      formattedNum = formattedNum.substring(0, formattedNum.length - 1);
    }

    if (formattedNum.endsWith('.')) {
      formattedNum = formattedNum.substring(0, formattedNum.length - 1);
    }

    return formattedNum;
  }

  static String _getWeightQuantity(Product product) {
    double gram = product.quantity;

    if (gram < 1) {
      return '${(gram * 1000).toInt()}mg';
    } else if (gram < 1000) {
      return '${removeDecimalZeroFormat(gram)}g';
    } else {
      return '${removeDecimalZeroFormat(gram / 1000)}kg';
    }
  }

  static String _getLiquidQuantity(Product product) {
    double liter = product.quantity;

    if (liter < 1) {
      return '${(liter * 1000).toInt()}ml';
    } else {
      return '${removeDecimalZeroFormat(liter)}l';
    }
  }

  static double pharseQuantity(double quantity, String? quantityType) {
    if (quantityType != null) {
      quantityType = quantityType.toLowerCase();
    }
    List<String> acceptTypes = ['mg', 'g', 'kg', 'ml', 'l', 'unit'];
    if (quantityType != null && !acceptTypes.contains(quantityType)) {
      throw Exception(
          'Invalid quantity type, must be in $acceptTypes, $quantityType given');
    }
    if (quantityType == 'mg' || quantityType == 'ml') {
      return quantity / 1000;
    } else if (quantityType == 'g' ||
        quantityType == 'unit' ||
        quantityType == 'l') {
      return quantity;
    } else if (quantityType == 'kg') {
      return quantity * 1000;
    } else {
      throw Exception('you never should be here');
    }
  }

  static getQuantityType(String quantityType) {
    quantityType = quantityType.toLowerCase();
    if (quantityType == 'unit') {
      return 'unit';
    } else if (quantityType == 'ml' || quantityType == 'l') {
      return 'liquid';
    } else if (quantityType == 'mg' ||
        quantityType == 'g' ||
        quantityType == 'kg') {
      return 'weight';
    }
    throw Exception('Invalid quantity type');
  }

  static String getQuantityVariation(Product product) {
    double quantity = product.quantity;
    if (product.quantityType == 'unit') {
      return 'unit';
    } else if (product.quantityType == 'liquid') {
      return quantity < 1 ? 'ml' : 'l';
    } else if (product.quantityType == 'weight') {
      return quantity < 1 ? 'mg' : (quantity < 1000 ? 'g' : 'kg');
    }
    return 'unit';
  }
}
