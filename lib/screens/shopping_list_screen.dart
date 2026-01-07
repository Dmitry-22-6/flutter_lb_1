import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class ShoppingListScreen extends StatelessWidget {
  ShoppingListScreen({super.key});

  final List<Product> products = [
    Product(name: 'Молоко', count: 2, price: 35.0),
    Product(name: 'Хліб', count: 1, price: 24.5),
    Product(name: 'Яйця (10 шт)', count: 1, price: 60.0),
    Product(name: 'Картопля (кг)', count: 3, price: 15.0),
    Product(name: 'М\'ясо', count: 1, price: 250.0),
    Product(name: 'Снікерс', count: 2, price: 20.0),
  ];

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var el in products) {
      total += el.price * el.count;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список покупок (Варіант 3)'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductItem(product: products[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Всього:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '${total.toStringAsFixed(2)} грн',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}