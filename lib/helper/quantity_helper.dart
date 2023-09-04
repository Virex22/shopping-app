class QuantityHelper {
  static String getQuantity(String quantityType, double quantity) {
    if (quantityType == 'unit') {
      return '${quantity.toInt()}';
    } else if (quantityType == 'liquid') {
      return _getLiquidQuantity(quantity);
    } else if (quantityType == 'weight') {
      return _getWeightQuantity(quantity);
    }
    return '${quantity.toInt()}';
  }

  static int getQuantityValue(String quantityType, double quantity) {
    if (quantityType == 'unit') {
      return quantity.toInt();
    } else if (quantityType == 'liquid') {
      if (quantity < 0.1) {
        return (quantity * 1000).toInt();
      } else if (quantity < 1) {
        return (quantity * 100).toInt();
      } else {
        return quantity.toInt();
      }
    } else if (quantityType == 'weight') {
      if (quantity < 1) {
        return (quantity * 1000).toInt();
      } else if (quantity < 1000) {
        return quantity.toInt();
      } else {
        return (quantity ~/ 1000).toInt();
      }
    }
    return quantity.toInt();
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

  static String _getWeightQuantity(double quantity) {
    // quantity is in gram
    if (quantity < 1) {
      return '${(quantity * 1000).toInt()}mg';
    } else if (quantity < 1000) {
      return '${removeDecimalZeroFormat(quantity)}g';
    } else {
      return '${removeDecimalZeroFormat(quantity / 1000)}kg';
    }
  }

  static String _getLiquidQuantity(double quantity) {
    // quantity is in liter
    if (quantity < 0.1) {
      return '${(quantity * 1000).toInt()}ml';
    } else if (quantity < 1) {
      return '${removeDecimalZeroFormat(quantity * 100)}cl';
    } else {
      return '${removeDecimalZeroFormat(quantity)}l';
    }
  }

  static double pharseQuantity(double quantity, String? quantityType) {
    if (quantityType != null) {
      quantityType = quantityType.toLowerCase();
    }
    List<String> acceptTypes = ['mg', 'g', 'kg', 'ml', 'l', 'cl', 'unit'];
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
    } else if (quantityType == 'cl') {
      return quantity / 100;
    } else {
      throw Exception('you never should be here');
    }
  }

  static getQuantityType(String quantityType) {
    quantityType = quantityType.toLowerCase();
    if (quantityType == 'unit') {
      return 'unit';
    } else if (quantityType == 'ml' ||
        quantityType == 'l' ||
        quantityType == 'cl') {
      return 'liquid';
    } else if (quantityType == 'mg' ||
        quantityType == 'g' ||
        quantityType == 'kg') {
      return 'weight';
    }
    throw Exception('Invalid quantity type');
  }

  static String getQuantityVariation(String quantityType, double quantity) {
    if (quantityType == 'unit') {
      return 'unit';
    } else if (quantityType == 'liquid') {
      return quantity < 0.1 ? 'ml' : (quantity < 1 ? 'cl' : 'L');
    } else if (quantityType == 'weight') {
      return quantity < 1 ? 'mg' : (quantity < 1000 ? 'g' : 'kg');
    }
    return 'unit';
  }
}
