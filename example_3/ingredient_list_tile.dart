import 'dart:async';

import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:ingredient_calculator/constants/mass_units.dart';
import 'package:ingredient_calculator/providers/ingredient_list_tile_provider.dart';
import 'package:ingredient_calculator/providers/product_details_page_provider.dart';
import 'package:ingredient_calculator/services/helper_service.dart';
import 'package:ingredient_calculator/widgets/ingredient_select_field.dart';
import 'package:ingredient_calculator/widgets/num_field.dart';
import 'package:ingredient_calculator/widgets/text_or_date_field.dart';
import 'package:ingredient_calculator/widgets/unit_field.dart';
import 'package:provider/provider.dart';

class IngredientListTile extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConfigurableExpansionTile(
          //initiallyExpanded: _expanded,
          onExpansionChanged: (_) {},
          header: _buildHeader(
            constraints: constraints,
            expanded: false,
            context: context,
          ),
          headerExpanded: _buildHeader(
            constraints: constraints,
            expanded: true,
            context: context,
          ),
          children: [_buildIngredientEditRow(context)],
        );
      },
    );
  }

  Widget _buildHeader(
      {BoxConstraints constraints, BuildContext context, bool expanded}) {
    final ingredient =
        Provider.of<IngredientListTileProvider>(context).ingredient;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: expanded ? Colors.grey[200] : Theme.of(context).primaryColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 9.0,
        vertical: 10.0,
      ),
      height: 50,
      width: constraints.maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${ingredient.netAmount} ${ingredient.productionUnit.name}',
            style: TextStyle(
              color: expanded ? Colors.black : Colors.white,
            ),
          ),
          Row(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200.0),
                child: Text(
                  ingredient.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: expanded ? Colors.black : Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 3.0),
              expanded
                  ? Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientEditRow(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.black12,
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildIngredientNameField(context),
            SizedBox(height: 10.0),
            _buildIngredientBatchField(context),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                _buildIngredientAmountField(context),
                SizedBox(width: 10.0),
                _buildIngredientUnitField(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientUnitField(BuildContext context) {
    final provider = Provider.of<IngredientListTileProvider>(context);
    final ingredient = provider.ingredient;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Unit',
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: UnitField(
              values: MassUnits.values,
              initialUnitValue: ingredient.productionUnit,
              onSelected: provider.setMassUnit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientBatchField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Best before or batch',
          style: TextStyle(fontSize: 15.0),
        ),
        SizedBox(height: 5.0),
        TextOrDateField(
          padding: EdgeInsets.all(12.0),
          validator: (value) {
            if (value.isEmpty) {
              return 'Date is required';
            }
            return null;
          },
          onSelected: (value) {
            try {
              DateTime dateTime = parseWithoutTimeZone(value);

              //ingredient.batch = formatDateToDDMMYYYY(dateTime, 'dd.MM.y');
            } catch (_) {
              //ingredient.batch = value;
            }
          },
        ),
      ],
    );
  }

  Expanded _buildIngredientAmountField(BuildContext context) {
    final provider = Provider.of<IngredientListTileProvider>(context);
    final ingredient = provider.ingredient;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Amount',
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(height: 5.0),
          NumField(
            initialValue: ingredient.netAmount,
            validator: (value) {
              if (value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
            onChanged: provider.setAmount,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientNameField(BuildContext context) {
    final ingredientProvider = Provider.of<IngredientListTileProvider>(context);
    final productProvider = Provider.of<ProductDetailsPageProvider>(context);

    final ingredient = ingredientProvider.ingredient;
    final product = productProvider.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ingredient name',
          style: TextStyle(fontSize: 15.0),
        ),
        SizedBox(height: 5.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: IngredientSelectField(
            contentPadding: EdgeInsets.all(12.0),
            productionUnit: MassUnits.values.first,
            onSelect: ingredientProvider.setIngredient,
            product: product,
            initialIngredient: ingredient.name,

            // onSelect: (newIngredient) {
            //   weightedIngredient.ingredient = newIngredient;
            // },
            // product: widget.product,
            // productionUnit: weightedIngredient.ingredient.productionUnit,
          ),
        ),
      ],
    );
  }
}

class ExpansionTileController {
  final _streamConroller = StreamController<bool>.broadcast();

  void expand() {
    _streamConroller.add(true);
  }

  void collapse() {
    _streamConroller.add(false);
  }

  void listen(void Function(bool) onData) {
    _streamConroller.stream.listen(onData);
  }

  void close() {
    _streamConroller.close();
  }
}
