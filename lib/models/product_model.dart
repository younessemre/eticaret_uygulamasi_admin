import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProductModel with ChangeNotifier {
  final String productId;
  final String productTitle;
  final String productPrice;
  final String productCategory;
  final String productDescription;
  final String productImage;
  final String productQuantity; // string tutuluyor
  final Timestamp? createdAt;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createdAt,
  });

  factory ProductModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ProductModel(
      productId: data['productId']?.toString() ?? doc.id,
      productTitle: data['productTitle']?.toString() ?? '',
      productPrice: data['productPrice']?.toString() ?? '0',
      productCategory: data['productCategory']?.toString() ?? '',
      productDescription: data['productDescription']?.toString() ?? '',
      productImage: data['productImage']?.toString() ?? '',
      productQuantity: (data['productQuantity']?.toString() ?? '').isEmpty
          ? '15'
          : data['productQuantity'].toString(),
      createdAt: data['createdAt'] is Timestamp ? data['createdAt'] : null,
    );
  }
}