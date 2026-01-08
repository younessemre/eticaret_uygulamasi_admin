import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routName = "/OrderDetailsScreen";

  final String orderNo;
  final double total;
  final List<Map<String, dynamic>> items; // [{productId, qty}]

  const OrderDetailsScreen({
    super.key,
    required this.orderNo,
    required this.total,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sipariş No: $orderNo"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sipariş Özeti",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final row = items[index];
                final pid = (row['productId'] ?? '').toString();
                final qty = int.tryParse((row['qty'] ?? row['quantity'] ?? 1).toString()) ?? 1;

                // Ürünü Firestore products koleksiyonundan çek
                final ref = FirebaseFirestore.instance.collection('products').doc(pid);

                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: ref.get(),
                  builder: (ctx, snap) {
                    if (!snap.hasData) {
                      return const ListTile(
                        title: Text("Yükleniyor..."),
                      );
                    }
                    final p = snap.data!.data() ?? {};
                    final title = (p['productTitle'] ?? 'Bilinmeyen Ürün').toString();
                    final price = (p['productPrice'] ?? '0').toString();
                    final image = (p['productImage'] ?? '').toString();

                    final lineTotal =
                        (double.tryParse(price) ?? 0) * qty.toDouble();

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: image.isEmpty
                              ? const SizedBox(width: 48, height: 48)
                              : Image.network(image, width: 48, height: 48, fit: BoxFit.cover),
                        ),
                        title: Text(title),
                        subtitle: Text("\$$price   Adet: $qty"),
                        trailing: Text(
                          "\$${lineTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withOpacity(.08))),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Toplam:",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}