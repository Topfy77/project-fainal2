import 'package:flutter/material.dart';
import '../models/product.dart'; // ตรวจสอบให้แน่ใจว่า Product model ถูก import ถูกต้อง

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete; // Callback เมื่อกดปุ่มลบ
  final VoidCallback? onEdit;   // Callback เมื่อกดปุ่มแก้ไข
  final VoidCallback? onBuy;    // Callback เมื่อกดปุ่มซื้อ

  ProductCard({required this.product, this.onDelete, this.onEdit, this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // แถวแรก: รูปภาพ
        Container(
          height: 120, // กำหนดความสูงให้เหมาะสมกับ Grid
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
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.deepPurple,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Image error: $error');
                      return Icon(Icons.error, size: 40, color: Colors.red[300]);
                    },
                  )
                : Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400]),
          ),
        ),
        SizedBox(height: 8), // ระยะห่างระหว่างรูปและข้อมูล
        // แถวที่สอง: ชื่อสินค้าและราคา
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.proName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Price: ${product.proPrice} ฿| Qty: ${product.proQty}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}