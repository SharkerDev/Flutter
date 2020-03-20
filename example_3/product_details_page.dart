import 'package:flutter/material.dart';
import 'package:ingredient_calculator/constants/mass_units.dart';
import 'package:ingredient_calculator/providers/ingredient_list_tile_provider.dart';
import 'package:ingredient_calculator/providers/product_details_page_provider.dart';
import 'package:ingredient_calculator/widgets/image_picker_buttom.dart';
import 'package:ingredient_calculator/widgets/ingredient_list_tile.dart';
import 'package:ingredient_calculator/widgets/num_field.dart';
import 'package:ingredient_calculator/widgets/unit_field.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductDetailsPageProvider>(context).product;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            product.image != null
                ? _buildPhotoSquare(context)
                : _buildNoPhotoSquare(context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'How much food are you preparing?',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  SizedBox(height: 20.0),
                  _buildWeightInputRow(context),
                  SizedBox(height: 20.0),
                  Text(
                    'For that you need:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  _buildIngredientsList(context),
                  SizedBox(height: 5.0),
                  _buildButtonsRow(context),
                  Divider(indent: 10.0),
                  SizedBox(height: 10.0),
                  Text(
                    'Preparation',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  if (product.preparationInstructions != null)
                    Text(product.preparationInstructions),
                  SizedBox(height: 20.0),
                  Divider(indent: 10.0),
                  SizedBox(height: 10.0),
                  Text(
                    'Preservation',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  // if (product.packaging != null)
                  //   _buildPreservationLabel(product.packaging),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSquare(BuildContext context) {
    final product = Provider.of<ProductDetailsPageProvider>(context).product;
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.memory(
              product.image,
              key: Key('product_image'),
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.25),
                Color.fromRGBO(0, 0, 0, 0.0),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildBackButton(context),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: _buildPhotoButton(30.0, context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoPhotoSquare(BuildContext context) {
    final product = Provider.of<ProductDetailsPageProvider>(context).product;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        width: double.infinity,
        height: 280.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.5),
              Color.fromRGBO(0, 0, 0, 0.0),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: _buildBackButton(context),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildPhotoButton(55.0, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: Navigator.of(context).maybePop,
      iconSize: 40.0,
      icon: Icon(
        Icons.keyboard_arrow_left,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _buildPhotoButton(double size, BuildContext context) {
    return ImagePickerButton(
      iconSize: size,
      icon: Icon(Icons.photo_camera),
      onImageAdded: Provider.of<ProductDetailsPageProvider>(context).setPhoto,
    );
  }

  Widget _buildWeightInputRow(BuildContext context) {
    final provider = Provider.of<ProductDetailsPageProvider>(context);
    final product = provider.product;
    return Row(
      children: <Widget>[
        Flexible(
          child: NumField(
            initialValue: product.netTotal,
            onChanged: (weight) => provider.setNetTotal(weight),
          ),
        ),
        SizedBox(width: 15.0),
        UnitField(
          initialUnitValue: product.netTotalUnit,
          values: MassUnits.values,
          onSelected: (selectedUnit) => provider.setMassUnit(selectedUnit),
        ),
      ],
    );
  }

  Row _buildButtonsRow(BuildContext context) {
    final provider = Provider.of<ProductDetailsPageProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Add ingredient',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: provider.addIngredient,
        ),
      ],
    );
  }

  Widget _buildIngredientsList(BuildContext context) {
    final ingredients =
        Provider.of<ProductDetailsPageProvider>(context).product.ingredients;

    return Column(
      children: ingredients
          .map(
            (ingredient) => ChangeNotifierProvider.value(
              value: IngredientListTileProvider(ingredient),
              child: IngredientListTile(),
            ),
          )
          .toList(),
    );
  }
}
