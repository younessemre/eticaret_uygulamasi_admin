import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter_admin/widget/title_text.dart';
import 'package:flutter/material.dart';

import 'order_details_screen.dart';

class OrderScreen extends StatelessWidget {
  static const routName = "/OrderScreen";
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
    // Tüm kullanıcıların orders alt koleksiyonlarını tek seferde çeker
        .collectionGroup('orders')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TitleTextWidget(label: "Siparişler"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: query.snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Hata: ${snap.error}'));
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Sipariş bulunamadı.'));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.white.withOpacity(.08)),
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final orderNo = (data['orderNo'] ?? '').toString();
              final total = (data['total'] ?? 0);
              final items = (data['items'] as List?)?.cast<Map>() ?? const [];

              return ListTile(
                title: Text(
                  "Sipariş No: $orderNo",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: Text(
                  "Tutar: \$${(total as num).toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(
                        orderNo: orderNo,
                        total: (total as num).toDouble(),
                        items: items
                            .map<Map<String, dynamic>>(
                                (e) => e.map((k, v) => MapEntry(k.toString(), v)))
                            .toList(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}