import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import '../widgets/new_item.dart';
import '../models/product.dart';

class ShoppingListScreen extends ConsumerWidget {
  final Category? categoryFilter; // Якщо null - показуємо все
  const ShoppingListScreen({super.key, this.categoryFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(productsProvider);
    // Фільтруємо список, якщо вибрана категорія
    final products = categoryFilter == null 
        ? allProducts 
        : allProducts.where((p) => p.category.id == categoryFilter!.id).toList();

    double totalSum = products.fold(0, (sum, item) => sum + (item.price * item.count));

    Widget content = const Center(child: Text('Немає товарів у цій категорії'));

    if (products.isNotEmpty) {
      content = ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) {
           final item = products[index];
           return Dismissible(
             key: ValueKey(item.id),
             background: Container(color: Colors.red),
             onDismissed: (direction) {
               ref.read(productsProvider.notifier).removeProduct(item);
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 content: const Text('Видалено'),
                 action: SnackBarAction(
                   label: 'Undo',
                   onPressed: () => ref.read(productsProvider.notifier).undoDelete(item, index),
                 ),
               ));
             },
             child: InkWell(
               onTap: () {
                 showModalBottomSheet(
                   context: context, 
                   isScrollControlled: true,
                   builder: (ctx) => NewItem(product: item));
               },
               child: ListTile(
                 leading: Container(width: 24, height: 24, color: item.category.color),
                 title: Text(item.name),
                 subtitle: Text('${item.count} шт. x ${item.price} грн'),
                 trailing: Text('${(item.count * item.price).toStringAsFixed(1)} грн'),
               ),
             ),
           );
        },
      );
    }

    if (categoryFilter != null) {
      return Scaffold(
        appBar: AppBar(title: Text(categoryFilter!.title)),
        body: content,
      );
    }

    return Column(
      children: [
        Expanded(child: content),
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('РАЗОМ:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${totalSum.toStringAsFixed(2)} грн', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }
}