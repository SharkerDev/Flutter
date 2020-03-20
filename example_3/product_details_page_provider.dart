import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ingredient_calculator/constants/product.dart';
import 'package:ingredient_calculator/models/ingredient.dart';
import 'package:ingredient_calculator/models/mass_unit.dart';
import 'package:ingredient_calculator/models/product.dart';
import 'package:ingredient_calculator/services/calculator_service.dart';

class ProductDetailsPageProvider with ChangeNotifier {
  final Product product = testProduct;

  void setPhoto(File file) async {
    product.image = await file.readAsBytes();
    notifyListeners();
  }

  void setNetTotal(num netTotal) {
    final calculator = CalculatorService(this.product);
    calculator.calcAmount(netTotal);
    notifyListeners();
  }

  void setMassUnit(MassUnit unit) {
    final calculator = CalculatorService(this.product);
    calculator.setMassUnit(unit);
    notifyListeners();
  }

  void addIngredient() {
    product.ingredients.add(Ingredient(
      name: '',
      productionUnit: product.netTotalUnit,
    ));
    notifyListeners();
  }
}
