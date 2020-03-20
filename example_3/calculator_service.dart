import 'package:ingredient_calculator/models/mass_unit.dart';
import 'package:ingredient_calculator/models/product.dart';

class CalculatorService {
  final Product _product;

  CalculatorService(this._product);

  void setMassUnit(MassUnit unit) {
    _product.netTotalUnit = unit;
    calcAmount(_product.netTotal);
  }

  void calcAmount(num amount) {
    if (amount == null) amount = _product.netTotal;
    _product.netTotal = amount;

    for (final ingredient in _product.ingredients) {
      final convertedAmount = _convertAmount(
        amount,
        _product.netTotalUnit,
        ingredient.productionUnit,
      );

      num shownNetAmount = convertedAmount != null
          ? convertedAmount * (ingredient.share ?? 0)
          : 0;

      ingredient.netAmount = num.parse(shownNetAmount.toStringAsFixed(3));
    }
  }

  num _convertAmount(num amount, MassUnit fromUnit, MassUnit toUnit) {
    final milliAmountIds = [1, 4]; // milliliter & gram
    final regularAmountIds = [2, 3];

    if (regularAmountIds.contains(fromUnit.id) &&
        milliAmountIds.contains(toUnit.id)) {
      return amount * 1000;
    } else if (milliAmountIds.contains(fromUnit.id) &&
        regularAmountIds.contains(toUnit.id)) {
      return amount / 1000;
    }

    return amount;
  }
}
