class Product {
  final int proId;
  final String proName;
  final int proPrice;
  final int proQty;
  final String photo;
  final int userId;

  Product({
    required this.proId,
    required this.proName,
    required this.proPrice,
    required this.proQty,
    required this.photo,
    required this.userId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      proId: json['pro_id'],
      proName: json['pro_name'],
      proPrice: json['pro_price'],
      proQty: json['pro_qty'],
      photo: json['photo'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pro_id': proId,
      'pro_name': proName,
      'pro_price': proPrice,
      'pro_qty': proQty,
      'photo': photo,
      'user_id': userId,
    };
  }
}