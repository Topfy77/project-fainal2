import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../screens/all_products_screen.dart'; // เพิ่มการนำทางไปหน้า AllProductsScreen

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.proName, style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.blue[800],
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: product.photo != null
                  ? Image.network(
                      'http://localhost:3000/uploads/${product.photo}',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Image error: $error');
                        return Icon(Icons.error, size: 200, color: Colors.red);
                      },
                    )
                  : Icon(Icons.image_not_supported, size: 200, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Product Name: ${product.proName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Price: ${product.proPrice}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Quantity: ${product.proQty}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await apiService.deleteProduct(product.proId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Product deleted')),
                    );
                    // กลับไปหน้า AllProductsScreen โดยใช้ Navigator
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllProductsScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting product: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Buy', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}