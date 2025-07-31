import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onBuy;

  ProductCard({required this.product, this.onDelete, this.onEdit, this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // แสดงรูปภาพ (จัดการค่า null)
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.photo != null
                ? Image.network(
                    'http://localhost:3000/uploads/${product.photo}',
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.red),
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null ? child : CircularProgressIndicator(),
                  )
                : Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
        SizedBox(height: 8),
        // แสดงชื่อและราคา (จัดการค่า null)
        Text(
          product.proName ?? 'No Name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.deepPurple),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Text(
          'Price: \$${product.proPrice ?? 0} | Qty: ${product.proQty ?? 0}', // หนี $ ด้วย \
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onEdit != null)
              IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            if (onDelete != null)
              IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ],
    );
  }
}