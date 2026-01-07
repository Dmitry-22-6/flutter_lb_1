import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';
import '../widgets/new_item.dart'; // Підключаємо нашу форму

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // Список тепер змінний
  final List<Product> _products = [
    Product(name: 'Молоко', count: 2, price: 35.0),
    Product(name: 'Хліб', count: 1, price: 24.5),
  ];

  // Функція відкриття вікна додавання
  void _openAddEntryOverlay() async {
    final newProduct = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const NewItem(),
    );

    if (newProduct != null) {
      setState(() {
        _products.add(newProduct);
      });
    }
  }

  // Функція редагування
  void _openEditEntryOverlay(Product product, int index) async {
    final editedProduct = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => NewItem(product: product),
    );

    if (editedProduct != null) {
      setState(() {
        _products[index] = editedProduct;
      });
    }
  }

  // Функція видалення з можливістю Undo
  void _removeProduct(int index) {
    final removedProduct = _products[index];
    setState(() {
      _products.removeAt(index);
    });

    // Показуємо повідомлення знизу (SnackBar)
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedProduct.name} видалено'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO (ПОВЕРНУТИ)',
          onPressed: () {
            setState(() {
              _products.insert(index, removedProduct);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalSum = 0;
    for (var item in _products) {
      totalSum += (item.price * item.count);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Варіант 3: Список Покупок'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: _openAddEntryOverlay,
            icon: const Icon(Icons.add), // Плюсик справа зверху
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _products.isEmpty
                ? const Center(child: Text('Список порожній, додайте щось!'))
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final item = _products[index];
                      // Dismissible дозволяє свайпати
                      return Dismissible(
                        key: ValueKey(item.hashCode), // Унікальний ключ
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          _removeProduct(index);
                        },
                        child: InkWell(
                          onTap: () => _openEditEntryOverlay(item, index),
                          child: ProductItem(product: item),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('РАЗОМ:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '${totalSum.toStringAsFixed(2)} грн',
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