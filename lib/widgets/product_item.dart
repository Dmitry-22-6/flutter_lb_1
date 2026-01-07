import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text('${product.count}x', style: const TextStyle(color: Colors.black)),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Ціна: ${product.price} грн'),
        trailing: Text(
          '${(product.count * product.price).toStringAsFixed(1)} грн',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
    );
  }
}