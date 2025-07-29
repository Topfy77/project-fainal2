import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class AddOrEditProductScreen extends StatefulWidget {
  final Product? product;

  AddOrEditProductScreen({this.product});

  @override
  _AddOrEditProductScreenState createState() => _AddOrEditProductScreenState();
}

class _AddOrEditProductScreenState extends State<AddOrEditProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _photoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.proName;
      _priceController.text = widget.product!.proPrice.toString();
      _qtyController.text = widget.product!.proQty.toString();
      _photoController.text = widget.product!.photo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Edit Product')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _qtyController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _photoController,
              decoration: InputDecoration(labelText: 'Photo URL'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final price = int.tryParse(_priceController.text) ?? 0;
                final qty = int.tryParse(_qtyController.text) ?? 0;
                final photo = _photoController.text;
                try {
                  if (widget.product == null) {
                    await apiService.addProduct(name, price, qty, photo as File);
                  } else {
                    await apiService.updateProduct(widget.product!.proId, name, price, qty, photo as File?);
                  }
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Text(widget.product == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}