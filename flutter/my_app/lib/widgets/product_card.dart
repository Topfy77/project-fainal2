import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  ProductCard({required this.product, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: product.photo != null
          ? Image.network(
              'http://localhost:3000/uploads/${product.photo}',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => SizedBox(width: 60, height: 60),
            )
          : SizedBox(width: 60, height: 60),
      title: Text(product.proName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Text('Price: ${product.proPrice} | Qty: ${product.proQty}',
          style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue[700]),
              onPressed: onEdit,
            ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[700]),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}