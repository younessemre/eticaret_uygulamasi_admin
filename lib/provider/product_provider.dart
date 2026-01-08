import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter_admin/models/product_model.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get products => List.unmodifiable(_products);

  ProductModel? findByProId(String productId) {
    try {
      return _products.firstWhere((e) => e.productId == productId);
    } catch (_) {
      return null;
    }
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    return _products
        .where((e) =>
        e.productCategory.toLowerCase().contains(categoryName.toLowerCase()))
        .toList();
  }

  List<ProductModel> searchQuery({
    required String searchText,
    required List<ProductModel> passedList,
  }) {
    return passedList
        .where((e) =>
        e.productTitle.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  // Firestore'dan tüm ürünleri çek
  Future<void> fetchProducts() async {
    final qs = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .get();

    _products
      ..clear()
      ..addAll(qs.docs.map((d) => ProductModel.fromDoc(d)));

    notifyListeners();
  }
}