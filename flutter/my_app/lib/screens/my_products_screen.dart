import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class MyProductsScreen extends StatefulWidget {
  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  dynamic _photo;
  final ImagePicker _picker = ImagePicker();
  int? _editingProductId;

  @override
  void initState() {
    super.initState();
    Provider.of<ApiService>(context, listen: false).fetchMyProducts();
  }

  Future<void> _pickImage() async {
    if (foundation.kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
      input.click();
      await input.onChange.first;
      if (input.files!.isNotEmpty) {
        setState(() {
          _photo = input.files!.first;
        });
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _photo = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _addOrUpdateProduct() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final name = _nameController.text;
    final price = int.tryParse(_priceController.text) ?? 0;
    final qty = int.tryParse(_qtyController.text) ?? 0;

    if (name.isEmpty || price <= 0 || qty < 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields correctly')));
      return;
    }

    try {
      if (_editingProductId == null) {
        await apiService.addProduct(name, price, qty, _photo);
      } else {
        await apiService.updateProduct(_editingProductId!, name, price, qty, _photo);
      }
      _resetForm();
      apiService.fetchMyProducts();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _resetForm() {
    _editingProductId = null;
    _nameController.clear();
    _priceController.clear();
    _qtyController.clear();
    _photo = null;
    setState(() {});
  }

  void _showEditDialog(Product product) {
    _editingProductId = product.proId;
    _nameController.text = product.proName;
    _priceController.text = product.proPrice.toString();
    _qtyController.text = product.proQty.toString();
    _photo = null; // โหลดรูปจาก backend ไม่รองรับ file preview ตรง

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInput(label: 'Product Name', controller: _nameController),
            _buildInput(label: 'Price', controller: _priceController, keyboardType: TextInputType.number),
            _buildInput(label: 'Quantity', controller: _qtyController, keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _pickImage, child: Text('Select Photo')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addOrUpdateProduct();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.roboto(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    if (_photo == null) {
      return OutlinedButton.icon(
        onPressed: _pickImage,
        icon: Icon(Icons.image),
        label: Text('Select Image'),
      );
    }

    final imageWidget = foundation.kIsWeb
        ? Image.network(html.Url.createObjectUrl(_photo), height: 120, fit: BoxFit.cover)
        : Image.file(_photo!, height: 120, fit: BoxFit.cover);

    return Column(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: imageWidget),
        TextButton(onPressed: _pickImage, child: Text('Change Image')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final products = apiService.products;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Products', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.indigo[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: products.isEmpty
                  ? Center(child: Text('No products available', style: GoogleFonts.roboto(fontSize: 18)))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (_, index) {
                        final product = products[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ProductCard(
                            product: product,
                            onEdit: () => _showEditDialog(product),
                            onDelete: () async {
                              try {
                                await apiService.deleteProduct(product.proId);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Product deleted')));
                                apiService.fetchMyProducts();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _editingProductId == null ? 'Add New Product' : 'Edit Product',
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo[800]),
            ),
            SizedBox(height: 16),
            _buildInput(label: 'Product Name', controller: _nameController),
            _buildInput(label: 'Price', controller: _priceController, keyboardType: TextInputType.number),
            _buildInput(label: 'Quantity', controller: _qtyController, keyboardType: TextInputType.number),
            _buildImagePicker(),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addOrUpdateProduct,
              icon: Icon(Icons.save),
              label: Text(_editingProductId == null ? 'Add Product' : 'Update Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
